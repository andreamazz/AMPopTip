#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NBSMockedApplication : NSObject

- (void)mockPreferredContentSizeCategory:(UIContentSizeCategory)category;
- (void)stopMockingPreferredContentSizeCategory;

@end

NS_ASSUME_NONNULL_END
