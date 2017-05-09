import Foundation
import FBSnapshotTestCase
import UIKit
import Nimble
import QuartzCore
import Quick

@objc public protocol Snapshotable {
    var snapshotObject: UIView? { get }
}

extension UIViewController : Snapshotable {
    public var snapshotObject: UIView? {
        self.beginAppearanceTransition(true, animated: false)
        self.endAppearanceTransition()
        return view
    }
}

extension UIView : Snapshotable {
    public var snapshotObject: UIView? {
        return self
    }
}

@objc class FBSnapshotTest : NSObject {

    var currentExampleMetadata: ExampleMetadata?

    var referenceImagesDirectory: String?
    var tolerance: CGFloat = 0
    
    class var sharedInstance : FBSnapshotTest {
        struct Instance {
            static let instance: FBSnapshotTest = FBSnapshotTest()
        }
        return Instance.instance
    }

    class func setReferenceImagesDirectory(_ directory: String?) {
        sharedInstance.referenceImagesDirectory = directory
    }

    class func compareSnapshot(_ instance: Snapshotable, isDeviceAgnostic: Bool=false, usesDrawRect: Bool=false, snapshot: String, record: Bool, referenceDirectory: String, tolerance: CGFloat) -> Bool {
        let snapshotController: FBSnapshotTestController = FBSnapshotTestController(testName: _testFileName())
        #if swift(>=3.0)
            snapshotController.isDeviceAgnostic = isDeviceAgnostic
        #else
            snapshotController.deviceAgnostic = isDeviceAgnostic
        #endif
        snapshotController.recordMode = record
        snapshotController.referenceImagesDirectory = referenceDirectory
        snapshotController.usesDrawViewHierarchyInRect = usesDrawRect
        
        assert(snapshotController.referenceImagesDirectory != nil, "Missing value for referenceImagesDirectory - Call FBSnapshotTest.setReferenceImagesDirectory(FB_REFERENCE_IMAGE_DIR)")

        do {
            #if swift(>=3.0)
                try snapshotController.compareSnapshot(ofViewOrLayer: instance.snapshotObject, selector: Selector(snapshot), identifier: nil, tolerance: tolerance)
            #else
                try snapshotController.compareSnapshotOfViewOrLayer(instance.snapshotObject, selector: Selector(snapshot), identifier: nil, tolerance: tolerance)
            #endif
        }
        catch {
            return false;
        }
        return true;
    }
}

// Note that these must be lower case.
var testFolderSuffixes = ["tests", "specs"]

public func setNimbleTestFolder(_ testFolder: String) {
    #if swift(>=3.0)
        testFolderSuffixes = [testFolder.lowercased()]
    #else
        testFolderSuffixes = [testFolder.lowercaseString]
    #endif
}

public func setNimbleTolerance(_ tolerance: CGFloat) {
    FBSnapshotTest.sharedInstance.tolerance = tolerance
}

func _getDefaultReferenceDirectory(_ sourceFileName: String) -> String {
    if let globalReference = FBSnapshotTest.sharedInstance.referenceImagesDirectory {
        return globalReference
    }

    // Search the test file's path to find the first folder with a test suffix,
    // then append "/ReferenceImages" and use that.

    // Grab the file's path
    let pathComponents: NSArray = (sourceFileName as NSString).pathComponents as NSArray

    // Find the directory in the path that ends with a test suffix.
    let testPath = pathComponents.filter { component -> Bool in
        #if swift(>=3.0)
            return testFolderSuffixes.filter { (component as AnyObject).lowercased.hasSuffix($0) }.count > 0
        #else
            return testFolderSuffixes.filter { component.lowercaseString.hasSuffix($0) }.count > 0
        #endif
        }.first

    guard let testDirectory = testPath else {
        fatalError("Could not infer reference image folder – You should provide a reference dir using FBSnapshotTest.setReferenceImagesDirectory(FB_REFERENCE_IMAGE_DIR)")
    }

    // Recombine the path components and append our own image directory.
    #if swift(>=3.0)
        let currentIndex = pathComponents.index(of: testDirectory) + 1
        let folderPathComponents: NSArray = pathComponents.subarray(with: NSMakeRange(0, currentIndex)) as NSArray
        let folderPath = folderPathComponents.componentsJoined(by: "/")
    #else
      let currentIndex = pathComponents.indexOfObject(testDirectory) + 1
        let folderPathComponents: NSArray = pathComponents.subarrayWithRange(NSMakeRange(0, currentIndex))
        let folderPath = folderPathComponents.componentsJoinedByString("/")
    #endif

    return folderPath + "/ReferenceImages"
}

func _testFileName() -> String {
    let name = FBSnapshotTest.sharedInstance.currentExampleMetadata!.example.callsite.file as NSString
    let type = ".\(name.pathExtension)"
    #if swift(>=3.0)
        let sanitizedName = name.lastPathComponent.replacingOccurrences(of: type, with: "")
    #else
        let sanitizedName = name.lastPathComponent.stringByReplacingOccurrencesOfString(type, withString: "")
    #endif

    return sanitizedName
}

func _sanitizedTestName(_ name: String?) -> String {
    let quickExample = FBSnapshotTest.sharedInstance.currentExampleMetadata
    var filename = name ?? quickExample!.example.name
    #if swift(>=3.0)
        filename = filename.replacingOccurrences(of: "root example group, ", with: "")
        let characterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
        let components = filename.components(separatedBy: characterSet.inverted)
        return components.joined(separator: "_")
    #else
        filename = filename.stringByReplacingOccurrencesOfString("root example group, ", withString: "")
        let characterSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
        let components: NSArray = filename.componentsSeparatedByCharactersInSet(characterSet.invertedSet)

        return components.componentsJoinedByString("_")
    #endif
}

func _getTolerance() -> CGFloat {
    return FBSnapshotTest.sharedInstance.tolerance
}

func _clearFailureMessage(_ failureMessage: FailureMessage) {
    failureMessage.actualValue = nil
    failureMessage.expected = ""
    failureMessage.postfixMessage = ""
    failureMessage.to = ""
}

func _performSnapshotTest(_ name: String?, isDeviceAgnostic: Bool=false, usesDrawRect: Bool=false, actualExpression: Expression<Snapshotable>, failureMessage: FailureMessage, tolerance: CGFloat?) -> Bool {
    let instance = try! actualExpression.evaluate()!
    let testFileLocation = actualExpression.location.file
    let referenceImageDirectory = _getDefaultReferenceDirectory(testFileLocation)
    let snapshotName = _sanitizedTestName(name)
    let tolerance = tolerance ?? _getTolerance()

    let result = FBSnapshotTest.compareSnapshot(instance, isDeviceAgnostic: isDeviceAgnostic, usesDrawRect: usesDrawRect, snapshot: snapshotName, record: false, referenceDirectory: referenceImageDirectory, tolerance: tolerance)

    if !result {
        _clearFailureMessage(failureMessage)
        failureMessage.expected = "expected a matching snapshot in \(snapshotName)"
    }

    return result
}

func _recordSnapshot(_ name: String?, isDeviceAgnostic: Bool=false, usesDrawRect: Bool=false, actualExpression: Expression<Snapshotable>, failureMessage: FailureMessage) -> Bool {
    let instance = try! actualExpression.evaluate()!
    let testFileLocation = actualExpression.location.file
    let referenceImageDirectory = _getDefaultReferenceDirectory(testFileLocation)
    let snapshotName = _sanitizedTestName(name)
    let tolerance = _getTolerance()
    
    _clearFailureMessage(failureMessage)

    if FBSnapshotTest.compareSnapshot(instance, isDeviceAgnostic: isDeviceAgnostic, usesDrawRect: usesDrawRect, snapshot: snapshotName, record: true, referenceDirectory: referenceImageDirectory, tolerance: tolerance) {
        failureMessage.expected = "snapshot \(name ?? snapshotName) successfully recorded, replace recordSnapshot with a check"
    } else {
        failureMessage.expected = "expected to record a snapshot in \(name)"
    }

    return false
}

internal var switchChecksWithRecords = false

public func haveValidSnapshot(named name: String? = nil, usesDrawRect: Bool=false, tolerance: CGFloat? = nil) -> MatcherFunc<Snapshotable> {
    return MatcherFunc { actualExpression, failureMessage in
        if (switchChecksWithRecords) {
            return _recordSnapshot(name, usesDrawRect: usesDrawRect, actualExpression: actualExpression, failureMessage: failureMessage)
        }

        return _performSnapshotTest(name, usesDrawRect: usesDrawRect, actualExpression: actualExpression, failureMessage: failureMessage, tolerance: tolerance)
    }
}

public func haveValidDeviceAgnosticSnapshot(named name: String?=nil, usesDrawRect: Bool=false, tolerance: CGFloat? = nil) -> MatcherFunc<Snapshotable> {
    return MatcherFunc { actualExpression, failureMessage in
        if (switchChecksWithRecords) {
            return _recordSnapshot(name, isDeviceAgnostic: true, usesDrawRect: usesDrawRect, actualExpression: actualExpression, failureMessage: failureMessage)
        }

        return _performSnapshotTest(name, isDeviceAgnostic: true, usesDrawRect: usesDrawRect, actualExpression: actualExpression, failureMessage: failureMessage, tolerance: tolerance)
    }
}

public func recordSnapshot(named name: String? = nil, usesDrawRect: Bool=false) -> MatcherFunc<Snapshotable> {
    return MatcherFunc { actualExpression, failureMessage in
        return _recordSnapshot(name, usesDrawRect: usesDrawRect, actualExpression: actualExpression, failureMessage: failureMessage)
    }
}

public func recordDeviceAgnosticSnapshot(named name: String?=nil, usesDrawRect: Bool=false) -> MatcherFunc<Snapshotable> {
    return MatcherFunc { actualExpression, failureMessage in
        return _recordSnapshot(name, isDeviceAgnostic: true, usesDrawRect: usesDrawRect, actualExpression: actualExpression, failureMessage: failureMessage)
    }
}
