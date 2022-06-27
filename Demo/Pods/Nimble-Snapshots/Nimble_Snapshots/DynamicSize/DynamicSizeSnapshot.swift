import Foundation
import Nimble
import QuartzCore
import UIKit

public enum ResizeMode {
    case frame
    case constrains
    case block(resizeBlock: (UIView, CGSize) -> Void)
    case custom(viewResizer: ViewResizer)

    func viewResizer() -> ViewResizer {
        switch self {
        case .frame:
            return FrameViewResizer()

        case .constrains:
            return ConstraintViewResizer()

        case .block(resizeBlock: let block):
            return BlockViewResizer(block: block)

        case .custom(viewResizer: let resizer):
            return resizer
        }
    }
}

public protocol ViewResizer {
    func resize(view: UIView, for size: CGSize)
}

struct FrameViewResizer: ViewResizer {
    func resize(view: UIView, for size: CGSize) {
        view.frame = CGRect(origin: .zero, size: size)
        view.layoutIfNeeded()
    }
}

struct BlockViewResizer: ViewResizer {

    let resizeBlock: (UIView, CGSize) -> Void

    init(block: @escaping (UIView, CGSize) -> Void) {
        self.resizeBlock = block
    }

    func resize(view: UIView, for size: CGSize) {
        self.resizeBlock(view, size)
    }
}

class ConstraintViewResizer: ViewResizer {

    typealias SizeConstrainsWrapper = (heightConstrain: NSLayoutConstraint, widthConstrain: NSLayoutConstraint)

    func resize(view: UIView, for size: CGSize) {
        let sizesConstrains = findConstrains(of: view)

        sizesConstrains.heightConstrain.constant = size.height
        sizesConstrains.widthConstrain.constant = size.width

        NSLayoutConstraint.activate([sizesConstrains.heightConstrain,
                                     sizesConstrains.widthConstrain])

        view.layoutIfNeeded()

        //iOS 9+ BUG: Before the first draw, iOS will not calculate the layout, 
        // it add a _UITemporaryLayoutWidth equals to its bounds and create a conflict. 
        // So to it do all the layout we create a Window and add it as subview
        if view.bounds.width != size.width || view.bounds.height != size.height {
            let window = UIWindow(frame: CGRect(origin: .zero, size: size))
            let viewController = UIViewController()
            viewController.view = UIView()
            viewController.view.addSubview(view)
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }

    func findConstrains(of view: UIView) -> SizeConstrainsWrapper {
        var height: NSLayoutConstraint! // swiftlint:disable:this implicitly_unwrapped_optional
        var width: NSLayoutConstraint! // swiftlint:disable:this implicitly_unwrapped_optional

        #if swift(>=4.2)
        let heightLayout = NSLayoutConstraint.Attribute.height
        let widthLayout = NSLayoutConstraint.Attribute.width
        let equalRelation = NSLayoutConstraint.Relation.equal
        #else
        let heightLayout = NSLayoutAttribute.height
        let widthLayout = NSLayoutAttribute.width
        let equalRelation = NSLayoutRelation.equal
        #endif

        for constrain in view.constraints {
            if constrain.firstAttribute == heightLayout &&
                constrain.relation == equalRelation && constrain.secondItem == nil {
                height = constrain
            }

            if constrain.firstAttribute == widthLayout &&
                constrain.relation == equalRelation && constrain.secondItem == nil {
                width = constrain
            }
        }

        if height == nil {
            height = NSLayoutConstraint(item: view, attribute: heightLayout, relatedBy: equalRelation, toItem: nil,
                                        attribute: heightLayout, multiplier: 1, constant: 0)
            view.addConstraint(height)
        }

        if width == nil {
            width = NSLayoutConstraint(item: view, attribute: widthLayout, relatedBy: equalRelation, toItem: nil,
                                       attribute: widthLayout, multiplier: 1, constant: 0)
            view.addConstraint(width)
        }

        return (height, width)
    }
}

public struct DynamicSizeSnapshot {
    let name: String?
    let identifier: String?
    let record: Bool
    let sizes: [String: CGSize]
    let resizeMode: ResizeMode

    init(name: String?, identifier: String?, record: Bool, sizes: [String: CGSize], resizeMode: ResizeMode) {
        self.name = name
        self.identifier = identifier
        self.record = record
        self.sizes = sizes
        self.resizeMode = resizeMode
    }
}

public func snapshot(_ name: String? = nil,
                     identifier: String? = nil,
                     sizes: [String: CGSize],
                     resizeMode: ResizeMode = .frame) -> DynamicSizeSnapshot {
    return DynamicSizeSnapshot(name: name, identifier: identifier, record: false, sizes: sizes, resizeMode: resizeMode)
}

public func haveValidDynamicSizeSnapshot(named name: String? = nil,
                                         identifier: String? = nil,
                                         sizes: [String: CGSize],
                                         isDeviceAgnostic: Bool = false,
                                         usesDrawRect: Bool = false,
                                         tolerance: CGFloat? = nil,
                                         resizeMode: ResizeMode = .frame) -> Predicate<Snapshotable> {
    return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
        return performDynamicSizeSnapshotTest(name,
                                              identifier: identifier,
                                              sizes: sizes,
                                              isDeviceAgnostic: isDeviceAgnostic,
                                              usesDrawRect: usesDrawRect,
                                              actualExpression: actualExpression,
                                              failureMessage: failureMessage,
                                              tolerance: tolerance,
                                              isRecord: false,
                                              resizeMode: resizeMode)
    }
}

// swiftlint:disable:next function_parameter_count
func performDynamicSizeSnapshotTest(_ name: String?,
                                    identifier: String? = nil,
                                    sizes: [String: CGSize],
                                    isDeviceAgnostic: Bool = false,
                                    usesDrawRect: Bool = false,
                                    actualExpression: Expression<Snapshotable>,
                                    failureMessage: FailureMessage,
                                    tolerance: CGFloat? = nil,
                                    isRecord: Bool,
                                    resizeMode: ResizeMode) -> Bool {
    // swiftlint:disable:next force_try force_unwrapping
    let instance = try! actualExpression.evaluate()!
    let testFileLocation = actualExpression.location.file
    let referenceImageDirectory = getDefaultReferenceDirectory(testFileLocation)
    let snapshotName = sanitizedTestName(name)
    let tolerance = tolerance ?? getTolerance()

    let resizer = resizeMode.viewResizer()

    let result = sizes.map { sizeName, size -> Bool in
        // swiftlint:disable:next force_unwrapping
        let view = instance.snapshotObject!
        let finalSnapshotName: String

        if let identifier = identifier {
            finalSnapshotName = "\(snapshotName)_\(identifier)_\(sizeName)"
        } else {
            finalSnapshotName = "\(snapshotName)_\(sizeName)"
        }

        resizer.resize(view: view, for: size)

        return FBSnapshotTest.compareSnapshot(instance, isDeviceAgnostic: isDeviceAgnostic, usesDrawRect: usesDrawRect,
                                              snapshot: finalSnapshotName, record: isRecord,
                                              referenceDirectory: referenceImageDirectory, tolerance: tolerance,
                                              filename: actualExpression.location.file, identifier: nil)
    }

    if isRecord {
        if result.filter({ !$0 }).isEmpty {
            let name = name ?? snapshotName
            failureMessage.actualValue = "snapshot \(name) successfully recorded, replace recordSnapshot with a check"
        } else {
            failureMessage.actualValue = "expected to record a snapshot in \(String(describing: name))"
        }

        return false
    } else {
        if !result.filter({ !$0 }).isEmpty {
            clearFailureMessage(failureMessage)
            failureMessage.actualValue = "expected a matching snapshot in \(snapshotName)"
            return false
        }

        return true
    }
}

public func recordSnapshot(_ name: String? = nil,
                           identifier: String? = nil,
                           sizes: [String: CGSize],
                           resizeMode: ResizeMode = .frame) -> DynamicSizeSnapshot {
    return DynamicSizeSnapshot(name: name, identifier: identifier, record: true, sizes: sizes, resizeMode: resizeMode)
}

public func recordDynamicSizeSnapshot(named name: String? = nil,
                                      identifier: String? = nil,
                                      sizes: [String: CGSize],
                                      isDeviceAgnostic: Bool = false,
                                      usesDrawRect: Bool = false,
                                      resizeMode: ResizeMode = .frame) -> Predicate<Snapshotable> {
    return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
        return performDynamicSizeSnapshotTest(name,
                                              identifier: identifier,
                                              sizes: sizes,
                                              isDeviceAgnostic: isDeviceAgnostic,
                                              usesDrawRect: usesDrawRect,
                                              actualExpression: actualExpression,
                                              failureMessage: failureMessage,
                                              isRecord: true,
                                              resizeMode: resizeMode)
    }
}

public func == (lhs: Expectation<Snapshotable>, rhs: DynamicSizeSnapshot) {
    if rhs.record {
        lhs.to(recordDynamicSizeSnapshot(named: rhs.name,
                                         identifier: rhs.identifier,
                                         sizes: rhs.sizes,
                                         resizeMode: rhs.resizeMode))
    } else {
        lhs.to(haveValidDynamicSizeSnapshot(named: rhs.name,
                                            identifier: rhs.identifier,
                                            sizes: rhs.sizes,
                                            resizeMode: rhs.resizeMode))
    }
}
