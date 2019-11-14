#import "XCTestObservationCenter+CurrentTestCaseTracker.h"
#if __has_include("Nimble_Snapshots-Swift.h")
    #import "Nimble_Snapshots-Swift.h"
#else
    #import <Nimble_Snapshots/Nimble_Snapshots-Swift.h>
#endif

@implementation XCTestObservationCenter (CurrentTestCaseTracker)

+ (void)load {
    [[self sharedTestObservationCenter] addTestObserver:[CurrentTestCaseTracker shared]];
}

@end
