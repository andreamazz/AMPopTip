import FBSnapshotTestCase
import Foundation
import Nimble
import QuartzCore
import UIKit

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

@objc public class FBSnapshotTest: NSObject {

    var referenceImagesDirectory: String?
    var tolerance: CGFloat = 0

    static let sharedInstance = FBSnapshotTest()

    public class func setReferenceImagesDirectory(_ directory: String?) {
        sharedInstance.referenceImagesDirectory = directory
    }

    // swiftlint:disable:next function_parameter_count
    class func compareSnapshot(_ instance: Snapshotable, isDeviceAgnostic: Bool = false,
                               usesDrawRect: Bool = false, snapshot: String, record: Bool,
                               referenceDirectory: String, tolerance: CGFloat,
                               filename: String) -> Bool {

        let testName = parseFilename(filename: filename)
        let snapshotController: FBSnapshotTestController = FBSnapshotTestController(testName: testName)
        snapshotController.isDeviceAgnostic = isDeviceAgnostic
        snapshotController.recordMode = record
        snapshotController.referenceImagesDirectory = referenceDirectory
        snapshotController.usesDrawViewHierarchyInRect = usesDrawRect

        let reason = "Missing value for referenceImagesDirectory - " +
                     "Call FBSnapshotTest.setReferenceImagesDirectory(FB_REFERENCE_IMAGE_DIR)"
        assert(snapshotController.referenceImagesDirectory != nil, reason)

        do {
            try snapshotController.compareSnapshot(ofViewOrLayer: instance.snapshotObject,
                                                   selector: Selector(snapshot), identifier: nil, tolerance: tolerance)
        } catch {
            return false
        }
        return true
    }
}

// Note that these must be lower case.
private var testFolderSuffixes = ["tests", "specs"]

public func setNimbleTestFolder(_ testFolder: String) {
    testFolderSuffixes = [testFolder.lowercased()]
}

public func setNimbleTolerance(_ tolerance: CGFloat) {
    FBSnapshotTest.sharedInstance.tolerance = tolerance
}

func getDefaultReferenceDirectory(_ sourceFileName: String) -> String {
    if let globalReference = FBSnapshotTest.sharedInstance.referenceImagesDirectory {
        return globalReference
    }

    // Search the test file's path to find the first folder with a test suffix,
    // then append "/ReferenceImages" and use that.

    // Grab the file's path
    let pathComponents = (sourceFileName as NSString).pathComponents as NSArray

    // Find the directory in the path that ends with a test suffix.
    let testPath = pathComponents.first { component -> Bool in
        return !testFolderSuffixes.filter {
            (component as AnyObject).lowercased.hasSuffix($0)
        }.isEmpty
    }

    guard let testDirectory = testPath else {
        fatalError("Could not infer reference image folder – You should provide a reference dir using " +
                   "FBSnapshotTest.setReferenceImagesDirectory(FB_REFERENCE_IMAGE_DIR)")
    }

    // Recombine the path components and append our own image directory.
    let currentIndex = pathComponents.index(of: testDirectory) + 1
    let folderPathComponents = pathComponents.subarray(with: NSRange(location: 0, length: currentIndex)) as NSArray
    let folderPath = folderPathComponents.componentsJoined(by: "/")

    return folderPath + "/ReferenceImages"
}

private func parseFilename(filename: String) -> String {
    let nsName = filename as NSString

    let type = ".\(nsName.pathExtension)"
    let sanitizedName = nsName.lastPathComponent.replacingOccurrences(of: type, with: "")

    return sanitizedName
}

func sanitizedTestName(_ name: String?) -> String {
	guard let testName = currentTestName() else {
		fatalError("Test matchers must be called from inside a test block")
	}

    var filename = name ?? testName
    filename = filename.replacingOccurrences(of: "root example group, ", with: "")
    let characterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
    let components = filename.components(separatedBy: characterSet.inverted)
    return components.joined(separator: "_")
}

func getTolerance() -> CGFloat {
    return FBSnapshotTest.sharedInstance.tolerance
}

func clearFailureMessage(_ failureMessage: FailureMessage) {
    failureMessage.actualValue = nil
    failureMessage.expected = ""
    failureMessage.postfixMessage = ""
    failureMessage.to = ""
}

private func performSnapshotTest(_ name: String?, isDeviceAgnostic: Bool = false, usesDrawRect: Bool = false,
                                 actualExpression: Expression<Snapshotable>, failureMessage: FailureMessage,
                                 tolerance: CGFloat?) -> Bool {
    // swiftlint:disable:next force_try force_unwrapping
    let instance = try! actualExpression.evaluate()!
    let testFileLocation = actualExpression.location.file
    let referenceImageDirectory = getDefaultReferenceDirectory(testFileLocation)
    let snapshotName = sanitizedTestName(name)
    let tolerance = tolerance ?? getTolerance()

    let result = FBSnapshotTest.compareSnapshot(instance, isDeviceAgnostic: isDeviceAgnostic,
                                                usesDrawRect: usesDrawRect, snapshot: snapshotName, record: false,
                                                referenceDirectory: referenceImageDirectory, tolerance: tolerance,
                                                filename: actualExpression.location.file)

    if !result {
        clearFailureMessage(failureMessage)
        failureMessage.expected = "expected a matching snapshot in \(snapshotName)"
    }

    return result
}

private func recordSnapshot(_ name: String?, isDeviceAgnostic: Bool = false, usesDrawRect: Bool = false,
                            actualExpression: Expression<Snapshotable>, failureMessage: FailureMessage) -> Bool {
    // swiftlint:disable:next force_try force_unwrapping
    let instance = try! actualExpression.evaluate()!
    let testFileLocation = actualExpression.location.file
    let referenceImageDirectory = getDefaultReferenceDirectory(testFileLocation)
    let snapshotName = sanitizedTestName(name)
    let tolerance = getTolerance()

    clearFailureMessage(failureMessage)

    if FBSnapshotTest.compareSnapshot(instance, isDeviceAgnostic: isDeviceAgnostic, usesDrawRect: usesDrawRect,
                                      snapshot: snapshotName, record: true, referenceDirectory: referenceImageDirectory,
                                      tolerance: tolerance, filename: actualExpression.location.file) {
        let name = name ?? snapshotName
        failureMessage.expected = "snapshot \(name) successfully recorded, replace recordSnapshot with a check"
    } else {
        let expectedMessage: String
        if let name = name {
            expectedMessage = "expected to record a snapshot in \(name)"
        } else {
            expectedMessage = "expected to record a snapshot"
        }
        failureMessage.expected = expectedMessage
    }

    return false
}

private func currentTestName() -> String? {
    return CurrentTestCaseTracker.shared.currentTestCase?.sanitizedName
}

internal var switchChecksWithRecords = false

public func haveValidSnapshot(named name: String? = nil, usesDrawRect: Bool = false,
                              tolerance: CGFloat? = nil) -> Predicate<Snapshotable> {

    return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
        if switchChecksWithRecords {
            return recordSnapshot(name, usesDrawRect: usesDrawRect, actualExpression: actualExpression,
                                  failureMessage: failureMessage)
        }

        return performSnapshotTest(name, usesDrawRect: usesDrawRect, actualExpression: actualExpression,
                                   failureMessage: failureMessage, tolerance: tolerance)
    }
}

public func haveValidDeviceAgnosticSnapshot(named name: String? = nil, usesDrawRect: Bool = false,
                                            tolerance: CGFloat? = nil) -> Predicate<Snapshotable> {

    return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
        if switchChecksWithRecords {
            return recordSnapshot(name, isDeviceAgnostic: true, usesDrawRect: usesDrawRect,
                                  actualExpression: actualExpression, failureMessage: failureMessage)
        }

        return performSnapshotTest(name, isDeviceAgnostic: true, usesDrawRect: usesDrawRect,
                                   actualExpression: actualExpression,
                                   failureMessage: failureMessage, tolerance: tolerance)
    }
}

public func recordSnapshot(named name: String? = nil, usesDrawRect: Bool = false) -> Predicate<Snapshotable> {

    return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
        return recordSnapshot(name, usesDrawRect: usesDrawRect,
                              actualExpression: actualExpression, failureMessage: failureMessage)
    }
}

public func recordDeviceAgnosticSnapshot(named name: String? = nil,
                                         usesDrawRect: Bool = false) -> Predicate<Snapshotable> {

    return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
        return recordSnapshot(name, isDeviceAgnostic: true, usesDrawRect: usesDrawRect,
                              actualExpression: actualExpression, failureMessage: failureMessage)
    }
}
