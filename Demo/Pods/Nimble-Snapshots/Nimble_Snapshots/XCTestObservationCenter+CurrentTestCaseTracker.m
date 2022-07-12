#import "XCTestObservationCenter+CurrentTestCaseTracker.h"
#if __has_include("Nimble_Snapshots-Swift.h")
    #import "Nimble_Snapshots-Swift.h"
#elif SWIFT_PACKAGE
@import Nimble_Snapshots;
#else
    #import <Nimble_Snapshots/Nimble_Snapshots-Swift.h>
#endif

@implementation XCTestObservationCenter (CurrentTestCaseTracker)

+ (void)load {
    [[self sharedTestObservationCenter] addTestObserver:[CurrentTestCaseTracker sharedInstance]];
}

@end
