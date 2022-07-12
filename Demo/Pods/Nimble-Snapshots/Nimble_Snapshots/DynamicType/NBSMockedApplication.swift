import Foundation
import UIKit

public class NBSMockedApplication {

    private var isSwizzled: Bool = false

    public init() {}

    deinit {
        stopMockingPreferredContentSizeCategory()
    }
    // swiftlint:disable line_length
    /* On iOS 9, UIFont.preferredFont(forTextStyle:) uses UIApplication.shared.preferredContentSizeCategory
     to get the content size category. However, this changed on iOS 10. While I haven't found what UIFont uses to get
     the current category, swizzling preferredFontForTextStyle: to use UIFont.preferredFont(forTextStyle:compatibleWith:)
     (only available on iOS >= 10), passing an UITraitCollection with the desired contentSizeCategory.
     */
    // swiftlint:enable line_length
    public func mockPreferredContentSizeCategory(_ category: UIContentSizeCategory) {

        UIApplication.shared.nbs_preferredContentSizeCategory = category

        if !isSwizzled {
            UIApplication.nbs_swizzle()
            UIFont.nbs_swizzle()
            UITraitCollection.nbs_swizzle()
            isSwizzled = true
        }
        NotificationCenter.default.post(name: UIContentSizeCategory.didChangeNotification,
                                        object: UIApplication.shared,
                                        userInfo: [UIContentSizeCategory.newValueUserInfoKey: category])
    }

    public func stopMockingPreferredContentSizeCategory() {
        if isSwizzled {
            UIApplication.nbs_swizzle()
            UIFont.nbs_swizzle()
            UITraitCollection.nbs_swizzle()
            isSwizzled = false
        }
    }
}

extension UIFont {

    static func nbs_swizzle() {
        if !UITraitCollection.instancesRespond(to: #selector(getter: UIApplication.preferredContentSizeCategory)) {
            return
        }

        let selector = #selector(UIFont.preferredFont(forTextStyle:))
        let replacedSelector = #selector(nbs_preferredFont(for:))

        let originalMethod = class_getClassMethod(self, selector)
        let extendedMethod = class_getClassMethod(self, replacedSelector)
        if let originalMethod = originalMethod, let extendedMethod = extendedMethod {
            method_exchangeImplementations(originalMethod, extendedMethod)
        }
    }

    @objc
    static func nbs_preferredFont(for style: UIFont.TextStyle) -> UIFont? {
        let category = UIApplication.shared.preferredContentSizeCategory

        if #available(iOS 10.0, tvOS 10.0, *) {
            let categoryTrait = UITraitCollection(preferredContentSizeCategory: category)
            return UIFont.preferredFont(forTextStyle: style, compatibleWith: categoryTrait)
        }
        return UIFont.preferredFont(forTextStyle: style)
    }
}

extension UIApplication {

    enum AssociatedKeys {
        static var contentSizeCategory: UInt8 = 0
    }

    @objc var nbs_preferredContentSizeCategory: UIContentSizeCategory? {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedKeys.contentSizeCategory) as? UIContentSizeCategory
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.contentSizeCategory,
                                     newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    static func nbs_swizzle() {
        let selector = #selector(getter: UIApplication.preferredContentSizeCategory)
        let replacedSelector = #selector(getter: self.nbs_preferredContentSizeCategory)

        let originalMethod = class_getInstanceMethod(self, selector)
        let extendedMethod = class_getInstanceMethod(self, replacedSelector)
        if let originalMethod = originalMethod, let extendedMethod = extendedMethod {
            method_exchangeImplementations(originalMethod, extendedMethod)
        }
    }
}

extension UITraitCollection {

    @objc
    func nbs_preferredContentSizeCategory() -> UIContentSizeCategory {
        return UIApplication.shared.preferredContentSizeCategory
    }

    @objc
    func nbs__changedContentSizeCategory(fromTraitCollection arg: Any?) -> Bool {
        return true
    }

    static func nbs_swizzlePreferredContentSizeCategory() {
        let selector = #selector(getter: UIApplication.preferredContentSizeCategory)

        if !self.instancesRespond(to: selector) {
            return
        }

        let replacedSelector = #selector(getter: UIApplication.nbs_preferredContentSizeCategory)

        let originalMethod = class_getInstanceMethod(self, selector)
        let extendedMethod = class_getInstanceMethod(self, replacedSelector)

        if let originalMethod = originalMethod, let extendedMethod = extendedMethod {
            method_exchangeImplementations(originalMethod, extendedMethod)
        }
    }

    static func nbs_swizzleChangedContentSizeCategoryFromTraitCollection() {
        let selector = sel_registerName("_changedContentSizeCategoryFromTraitCollection:")

        if !self.instancesRespond(to: selector) {
            return
        }

        let replacedSelector = #selector(nbs__changedContentSizeCategory(fromTraitCollection:))

        let originalMethod = class_getInstanceMethod(self, selector)
        let extendedMethod = class_getInstanceMethod(self, replacedSelector)

        if let originalMethod = originalMethod, let extendedMethod = extendedMethod {
            method_exchangeImplementations(originalMethod, extendedMethod)
        }
    }

    static func nbs_swizzle() {
        nbs_swizzlePreferredContentSizeCategory()
        nbs_swizzleChangedContentSizeCategoryFromTraitCollection()
    }
}
