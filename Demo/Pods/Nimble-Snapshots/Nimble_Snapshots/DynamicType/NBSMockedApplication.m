#import "NBSMockedApplication.h"
#import <objc/runtime.h>

@interface NBSMockedApplication ()

@property (nonatomic) BOOL isSwizzled;

@end

@interface UIFont (Swizzling)

+ (void)nbs_swizzle;

@end

@interface UIApplication (Swizzling)

+ (void)nbs_swizzle;

@property (nonatomic) UIContentSizeCategory nbs_preferredContentSizeCategory;

@end

@interface UITraitCollection (Swizzling)

+ (void)nbs_swizzle;

@end

@implementation NBSMockedApplication

/* On iOS 9, +[UIFont preferredFontForTextStyle:] uses -[UIApplication preferredContentSizeCategory]
    to get the content size category. However, this changed on iOS 10. While I haven't found what UIFont uses to get
    the current category, swizzling preferredFontForTextStyle: to use +[UIFont preferredFontForTextStyle: compatibleWithTraitCollection:]
    (only available on iOS >= 10), passing an UITraitCollection with the desired contentSizeCategory.
 */

- (void)mockPreferredContentSizeCategory:(UIContentSizeCategory)category {
    UIApplication.sharedApplication.nbs_preferredContentSizeCategory = category;

    if (!self.isSwizzled) {
        [UIApplication nbs_swizzle];
        [UIFont nbs_swizzle];
        [UITraitCollection nbs_swizzle];
        self.isSwizzled = YES;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:UIContentSizeCategoryDidChangeNotification
                                                        object:[UIApplication sharedApplication]
                                                      userInfo:@{UIContentSizeCategoryNewValueKey: category}];
}

- (void)stopMockingPreferredContentSizeCategory {
    if (self.isSwizzled) {
        [UIApplication nbs_swizzle];
        [UIFont nbs_swizzle];
        [UITraitCollection nbs_swizzle];
        self.isSwizzled = NO;
    }
}

- (void)dealloc {
    [self stopMockingPreferredContentSizeCategory];
}

@end

@implementation UIFont (Swizzling)

+ (UIFont *)nbs_preferredFontForTextStyle:(UIFontTextStyle)style {
    UIContentSizeCategory category = UIApplication.sharedApplication.preferredContentSizeCategory;
    if (@available(iOS 10.0, tvOS 10.0, *)) {
        UITraitCollection *categoryTrait = [UITraitCollection traitCollectionWithPreferredContentSizeCategory:category];
        return [UIFont preferredFontForTextStyle:style compatibleWithTraitCollection:categoryTrait];
    } else {
        return [UIFont preferredFontForTextStyle:style];
    }
}

+ (void)nbs_swizzle {
    if (![UITraitCollection instancesRespondToSelector:@selector(preferredContentSizeCategory)]) {
        return;
    }

    SEL selector = @selector(preferredFontForTextStyle:);
    SEL replacedSelector = @selector(nbs_preferredFontForTextStyle:);

    Method originalMethod = class_getClassMethod(self, selector);
    Method extendedMethod = class_getClassMethod(self, replacedSelector);
    method_exchangeImplementations(originalMethod, extendedMethod);
}

@end

@implementation UIApplication (Swizzling)

- (UIContentSizeCategory)nbs_preferredContentSizeCategory {
    return objc_getAssociatedObject(self, @selector(nbs_preferredContentSizeCategory));
}

- (void)setNbs_preferredContentSizeCategory:(UIContentSizeCategory)category {
    objc_setAssociatedObject(self, @selector(nbs_preferredContentSizeCategory),
                             category, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)nbs_swizzle {
    SEL selector = @selector(preferredContentSizeCategory);
    SEL replacedSelector = @selector(nbs_preferredContentSizeCategory);

    Method originalMethod = class_getInstanceMethod(self, selector);
    Method extendedMethod = class_getInstanceMethod(self, replacedSelector);
    method_exchangeImplementations(originalMethod, extendedMethod);
}

@end

@implementation UITraitCollection (Swizzling)

- (UIContentSizeCategory)nbs_preferredContentSizeCategory {
    return UIApplication.sharedApplication.preferredContentSizeCategory;
}

- (BOOL)nbs__changedContentSizeCategoryFromTraitCollection:(id)arg {
    return YES;
}

+ (void)nbs_swizzle {
    [self nbs_swizzlePreferredContentSizeCategory];
    [self nbs_swizzleChangedContentSizeCategoryFromTraitCollection];
}

+ (void)nbs_swizzlePreferredContentSizeCategory {
    SEL selector = @selector(preferredContentSizeCategory);

    if (![self instancesRespondToSelector:selector]) {
        return;
    }

    SEL replacedSelector = @selector(nbs_preferredContentSizeCategory);

    Method originalMethod = class_getInstanceMethod(self, selector);
    Method extendedMethod = class_getInstanceMethod(self, replacedSelector);
    method_exchangeImplementations(originalMethod, extendedMethod);
}

+ (void)nbs_swizzleChangedContentSizeCategoryFromTraitCollection {
    SEL selector = sel_registerName("_changedContentSizeCategoryFromTraitCollection:");

    if (![self instancesRespondToSelector:selector]) {
        return;
    }

    SEL replacedSelector = @selector(nbs__changedContentSizeCategoryFromTraitCollection:);

    Method originalMethod = class_getInstanceMethod(self, selector);
    Method extendedMethod = class_getInstanceMethod(self, replacedSelector);
    method_exchangeImplementations(originalMethod, extendedMethod);
}

@end
