import Nimble
import UIKit

public func allContentSizeCategories() -> [UIContentSizeCategory] {
    return [
        .extraSmall, .small, .medium,
        .large, .extraLarge, .extraExtraLarge,
        .extraExtraExtraLarge, .accessibilityMedium,
        .accessibilityLarge, .accessibilityExtraLarge,
        .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge
    ]
}

func shortCategoryName(_ category: UIContentSizeCategory) -> String {
    return category.rawValue.replacingOccurrences(of: "UICTContentSizeCategory", with: "")
}

func combinePredicates<T>(_ predicates: [Predicate<T>],
                          ignoreFailures: Bool = false,
                          deferred: (() -> Void)? = nil) -> Predicate<T> {
    return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
        defer {
            deferred?()
        }

        return try predicates.reduce(true) { acc, matcher -> Bool in
            guard acc || ignoreFailures else {
                return false
            }

            let result = try matcher.matches(actualExpression, failureMessage: failureMessage)
            return result && acc
        }
    }
}

public func haveValidDynamicTypeSnapshot(named name: String? = nil,
                                         identifier: String? = nil,
                                         usesDrawRect: Bool = false,
                                         tolerance: CGFloat? = nil,
                                         sizes: [UIContentSizeCategory] = allContentSizeCategories(),
                                         isDeviceAgnostic: Bool = false) -> Predicate<Snapshotable> {
    let mock = NBSMockedApplication()

    let predicates: [Predicate<Snapshotable>] = sizes.map { category in
        let sanitizedName = sanitizedTestName(name)
        let nameWithCategory = "\(sanitizedName)_\(shortCategoryName(category))"

        return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
            mock.mockPreferredContentSizeCategory(category)
            updateTraitCollection(on: actualExpression)

            let predicate: Predicate<Snapshotable>
            if isDeviceAgnostic {
                predicate = haveValidDeviceAgnosticSnapshot(named: nameWithCategory, identifier: identifier,
                                                            usesDrawRect: usesDrawRect, tolerance: tolerance)
            } else {
                predicate = haveValidSnapshot(named: nameWithCategory,
                                              identifier: identifier,
                                              usesDrawRect: usesDrawRect,
                                              tolerance: tolerance)
            }

            return try predicate.matches(actualExpression, failureMessage: failureMessage)
        }
    }

    return combinePredicates(predicates) {
        mock.stopMockingPreferredContentSizeCategory()
    }
}

public func recordDynamicTypeSnapshot(named name: String? = nil,
                                      identifier: String? = nil,
                                      usesDrawRect: Bool = false,
                                      sizes: [UIContentSizeCategory] = allContentSizeCategories(),
                                      isDeviceAgnostic: Bool = false) -> Predicate<Snapshotable> {
    let mock = NBSMockedApplication()

    let predicates: [Predicate<Snapshotable>] = sizes.map { category in
        let sanitizedName = sanitizedTestName(name)
        let nameWithCategory = "\(sanitizedName)_\(shortCategoryName(category))"

        return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
            mock.mockPreferredContentSizeCategory(category)
            updateTraitCollection(on: actualExpression)

            let predicate: Predicate<Snapshotable>
            if isDeviceAgnostic {
                predicate = recordDeviceAgnosticSnapshot(named: nameWithCategory,
                                                         identifier: identifier,
                                                         usesDrawRect: usesDrawRect)
            } else {
                predicate = recordSnapshot(named: nameWithCategory, identifier: identifier, usesDrawRect: usesDrawRect)
            }

            return try predicate.matches(actualExpression, failureMessage: failureMessage)
        }
    }

    return combinePredicates(predicates, ignoreFailures: true) {
        mock.stopMockingPreferredContentSizeCategory()
    }
}

private func updateTraitCollection(on expression: Expression<Snapshotable>) {
    // swiftlint:disable:next force_try force_unwrapping
    let instance = try! expression.evaluate()!
    updateTraitCollection(on: instance)
}

private func updateTraitCollection(on element: Snapshotable) {
    if let environment = element as? UITraitEnvironment {
        if let vc = environment as? UIViewController {
            vc.beginAppearanceTransition(true, animated: false)
            vc.endAppearanceTransition()
        }

        environment.traitCollectionDidChange(nil)

        if let view = environment as? UIView {
            view.subviews.forEach(updateTraitCollection(on:))
        } else if let vc = environment as? UIViewController {
            #if swift(>=4.2)
            vc.children.forEach(updateTraitCollection(on:))
            #else
            vc.childViewControllers.forEach(updateTraitCollection(on:))
            #endif

            if vc.isViewLoaded {
                updateTraitCollection(on: vc.view)
            }
        }
    }
}
