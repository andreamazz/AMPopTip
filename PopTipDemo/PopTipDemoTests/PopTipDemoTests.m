//
//  PopTipDemoTests.m
//  PopTipDemoTests
//
//  Created by Andrea Mazzini on 11/07/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#define EXP_SHORTHAND
@import Specta;
@import Expecta;
@import Expecta_Snapshots;
@import OCMock;

@import AMPopTip;

@interface AMPopTip (Mock)

- (void)bounceAnimation;
- (void)floatAnimation;
- (void)pulseAnimation;

@end

SpecBegin(PopTipDemoTests)

__block AMPopTip *subject;

#define kRECORD     NO

describe(@"AMPopTip", ^{

    beforeAll(^{
        setGlobalReferenceImageDir(FB_REFERENCE_IMAGE_DIR);
    });

    before(^{
        subject = [AMPopTip popTip];
    });

    sharedExamplesFor(@"init method", ^(NSDictionary *data) {
        it(@"should register the gesture recognizers", ^{
            expect([subject valueForKey:@"tapRemoveGesture"]).to.beKindOf([UITapGestureRecognizer class]);
            expect([subject valueForKey:@"swipeRemoveGesture"]).to.beKindOf([UISwipeGestureRecognizer class]);
        });
    });

    describe(@"popTip", ^{
        subject = [AMPopTip popTip];
        itShouldBehaveLike(@"init method", nil);
    });

    describe(@"init", ^{
        subject = [[AMPopTip alloc] init];
        itShouldBehaveLike(@"init method", nil);
    });

    describe(@"initWithFrame:", ^{
        subject = [[AMPopTip alloc] initWithFrame:CGRectZero];
        itShouldBehaveLike(@"init method", nil);
    });

    describe(@"AMPopTipEntranceAnimationCustom", ^{
        it(@"calls the provided block", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            __block int number = 0;
            subject = [AMPopTip popTip];

            subject.entranceAnimation = AMPopTipEntranceAnimationCustom;

            subject.entranceAnimationHandler = ^(void (^completion)(void)){
                number = 42;
                completion();
            };

            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionDown
                     maxWidth:140
                       inView:view
                    fromFrame:CGRectMake(0, 0, 100, 100)];

            expect(number).to.equal(42);
        });
    });

    describe(@"customized via appearance", ^{

        it(@"looks right", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subject = [AMPopTip popTip];

            subject.font = [UIFont fontWithName:@"Avenir-Light" size:20];
            subject.textColor = [UIColor redColor];
            subject.textAlignment = NSTextAlignmentCenter;
            subject.popoverColor = [UIColor yellowColor];
            subject.borderColor = [UIColor colorWithWhite:0.5 alpha:1.000];
            subject.borderWidth = 2;
            subject.radius = 0;
            subject.offset = 10;
            subject.padding = 2;
            subject.edgeInsets = UIEdgeInsetsMake(4, 2, 4, 2);
            subject.arrowSize = CGSizeMake(12, 12);
            subject.animationIn = 0;
            subject.animationOut = 0;
            subject.entranceAnimation = AMPopTipEntranceAnimationNone;
            subject.edgeMargin = 2;
            
            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionDown
                     maxWidth:140
                       inView:view
                    fromFrame:CGRectMake(0, 0, 100, 100)];

            if (kRECORD) expect(view).to.recordSnapshotNamed(@"Appearance");
            expect(view).to.haveValidSnapshotNamed(@"Appearance");

        });

        it(@"can be rounded", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subject = [AMPopTip popTip];

            subject.rounded = YES;

            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionDown
                     maxWidth:140
                       inView:view
                    fromFrame:CGRectMake(0, 0, 100, 100)];

            if (kRECORD) expect(view).to.recordSnapshotNamed(@"Rounded");
            expect(view).to.haveValidSnapshotNamed(@"Rounded");
        });
    });

    describe(@"showText:direction:maxWidth:inView:fromFrame:", ^{
        it(@"should set the properties", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:200 inView:view fromFrame:CGRectZero];
            subject.bubbleOffset = 10;
            expect([subject valueForKey:@"attributedText"]).to.beNil();
            expect([subject valueForKey:@"text"]).to.equal(@"Hi");
            expect([subject valueForKey:@"accessibilityLabel"]).to.equal(@"Hi");
            expect([subject valueForKey:@"direction"]).to.equal(AMPopTipDirectionUp);
            expect([subject valueForKey:@"containerView"]).to.equal(view);
            expect([subject valueForKey:@"maxWidth"]).to.equal(200);
            expect([subject valueForKey:@"bubbleOffset"]).to.equal(10);
        });
    });
    
    describe(@"showAttributedText:direction:maxWidth:inView:fromFrame:", ^{
        it(@"should set the properties", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:@"Hi" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
            [subject showAttributedText:attributed direction:AMPopTipDirectionUp maxWidth:200 inView:view fromFrame:CGRectZero];
            expect([subject valueForKey:@"text"]).to.beNil();
            expect([subject valueForKey:@"attributedText"]).to.equal(attributed);
            expect([subject valueForKey:@"accessibilityLabel"]).to.equal(@"Hi");
            expect([subject valueForKey:@"direction"]).to.equal(AMPopTipDirectionUp);
            expect([subject valueForKey:@"containerView"]).to.equal(view);
            expect([subject valueForKey:@"maxWidth"]).to.equal(200);
        });
    });

    describe(@"showText:direction:maxWidth:inView:fromFrame:duration:", ^{
        it(@"should set the properties", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:200 inView:view fromFrame:CGRectZero duration:1];
            expect([subject valueForKey:@"attributedText"]).to.beNil();
            expect([subject valueForKey:@"text"]).to.equal(@"Hi");
            expect([subject valueForKey:@"accessibilityLabel"]).to.equal(@"Hi");
            expect([subject valueForKey:@"direction"]).to.equal(AMPopTipDirectionUp);
            expect([subject valueForKey:@"containerView"]).to.equal(view);
            expect([subject valueForKey:@"maxWidth"]).to.equal(200);
        });

        it(@"should setup a timer", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:200 inView:view fromFrame:CGRectZero duration:1];
            expect([subject valueForKey:@"dismissTimer"]).toNot.beNil();
        });
    });

    describe(@"showAttributedText:direction:maxWidth:inView:fromFrame:duration:", ^{
        it(@"should set the properties", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:@"Hi" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
            [subject showAttributedText:attributed direction:AMPopTipDirectionUp maxWidth:200 inView:view fromFrame:CGRectZero duration:1];
            expect([subject valueForKey:@"text"]).to.beNil();
            expect([subject valueForKey:@"attributedText"]).to.equal(attributed);
            expect([subject valueForKey:@"accessibilityLabel"]).to.equal(@"Hi");
            expect([subject valueForKey:@"direction"]).to.equal(AMPopTipDirectionUp);
            expect([subject valueForKey:@"containerView"]).to.equal(view);
            expect([subject valueForKey:@"maxWidth"]).to.equal(200);
        });

        it(@"should setup a timer", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:@"Hi" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
            [subject showAttributedText:attributed direction:AMPopTipDirectionUp maxWidth:200 inView:view fromFrame:CGRectZero duration:1];
            expect([subject valueForKey:@"dismissTimer"]).toNot.beNil();
        });
    });

    context(@"calling show on a poptip", ^{
        it(@"displays well in the top left", ^{
            UIViewController *controller = [[UIViewController alloc] init];

            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionDown
                     maxWidth:140
                       inView:controller.view
                    fromFrame:CGRectMake(0, 0, 100, 100)];

            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"TopLeft-Down");
            expect(controller.view).to.haveValidSnapshotNamed(@"TopLeft-Down");


            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionRight
                     maxWidth:140
                       inView:controller.view
                    fromFrame:CGRectMake(0, 0, 100, 100)];

            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"TopLeft-Right");
            expect(controller.view).to.haveValidSnapshotNamed(@"TopLeft-Right");
        });

        it(@"displays well in the top right", ^{
            UIViewController *controller = [[UIViewController alloc] init];

            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionDown
                     maxWidth:140
                       inView:controller.view
                    fromFrame:CGRectMake(controller.view.frame.size.width - 100, 0, 100, 100)];

            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"TopRight-Down");
            expect(controller.view).to.haveValidSnapshotNamed(@"TopRight-Down");


            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionLeft
                     maxWidth:140
                       inView:controller.view
                    fromFrame:CGRectMake(controller.view.frame.size.width - 100, 0, 100, 100)];

            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"TopRight-Left");
            expect(controller.view).to.haveValidSnapshotNamed(@"TopRight-Left");
        });

        it(@"displays well in the bottom left", ^{
            UIViewController *controller = [[UIViewController alloc] init];

            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionUp
                     maxWidth:140
                       inView:controller.view
                    fromFrame:CGRectMake(0, controller.view.frame.size.height - 100, 100, 100)];

            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"BottomLeft-Down");
            expect(controller.view).to.haveValidSnapshotNamed(@"BottomLeft-Down");


            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionRight
                     maxWidth:140
                       inView:controller.view
                    fromFrame:CGRectMake(0, controller.view.frame.size.height - 100, 100, 100)];

            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"BottomLeft-Right");
            expect(controller.view).to.haveValidSnapshotNamed(@"BottomLeft-Right");
        });

        it(@"displays well in the bottom right", ^{
            UIViewController *controller = [[UIViewController alloc] init];

            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionUp
                     maxWidth:140
                       inView:controller.view
                    fromFrame:CGRectMake(controller.view.frame.size.width - 100, controller.view.frame.size.height - 100, 100, 100)];

            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"BottomRight-Down");
            expect(controller.view).to.haveValidSnapshotNamed(@"BottomRight-Down");


            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionLeft
                     maxWidth:140
                       inView:controller.view
                    fromFrame:CGRectMake(controller.view.frame.size.width - 100, controller.view.frame.size.height - 100, 100, 100)];

            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"BottomRight-Left");
            expect(controller.view).to.haveValidSnapshotNamed(@"BottomRight-Left");
        });
    });

    describe(@"tap inside gesture", ^{
        it(@"should hide the poptip when shouldDismissOnTap is on", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subject.shouldDismissOnTap = YES;
            subject.entranceAnimation = AMPopTipEntranceAnimationNone;
            subject.exitAnimation = AMPopTipExitAnimationNone;
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectZero];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [subject performSelector:@selector(handleTap:) withObject:nil];
#pragma clang diagnostic pop
            expect(subject.isVisible).after(1).to.beFalsy();
        });

        it(@"should not hide the poptip when shouldDismissOnTap is off", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subject.shouldDismissOnTap = NO;
            subject.entranceAnimation = AMPopTipEntranceAnimationNone;
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectZero];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [subject performSelector:@selector(handleTap:) withObject:nil];
#pragma clang diagnostic pop
            expect(subject.isVisible).after(1).to.beTruthy();
        });
    });

    describe(@"tap outside gesture", ^{
        it(@"should hide the poptip when shouldDismissOnTapOutside is on", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subject.shouldDismissOnTapOutside = YES;
            subject.entranceAnimation = AMPopTipEntranceAnimationNone;
            subject.exitAnimation = AMPopTipExitAnimationNone;
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectZero];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [subject performSelector:@selector(tapRemoveGestureHandler) withObject:nil];
#pragma clang diagnostic pop
            expect(subject.isVisible).after(1).to.beFalsy();
        });

        it(@"should not hide the poptip when shouldDismissOnTapOutside is off", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subject.shouldDismissOnTapOutside = NO;
            subject.entranceAnimation = AMPopTipEntranceAnimationNone;
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectZero];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [subject performSelector:@selector(tapRemoveGestureHandler) withObject:nil];
#pragma clang diagnostic pop
            expect(subject.isVisible).after(1).to.beTruthy();
        });
    });

    describe(@"swipe outside gesture", ^{
        it(@"should hide the poptip when shouldDismissOnSwipeOutside is on", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subject.shouldDismissOnSwipeOutside = YES;
            subject.entranceAnimation = AMPopTipEntranceAnimationNone;
            subject.exitAnimation = AMPopTipExitAnimationNone;
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectZero];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [subject performSelector:@selector(swipeRemoveGestureHandler) withObject:nil];
#pragma clang diagnostic pop
            expect(subject.isVisible).after(1).to.beFalsy();
        });

        it(@"should not hide the poptip when shouldDismissOnSwipeOutside is off", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subject.shouldDismissOnSwipeOutside = NO;
            subject.entranceAnimation = AMPopTipEntranceAnimationNone;
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectZero];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [subject performSelector:@selector(swipeRemoveGestureHandler) withObject:nil];
#pragma clang diagnostic pop
            expect(subject.isVisible).after(1).to.beTruthy();
        });
    });

    describe(@"hide", ^{
        it(@"invaldiates the dismiss timer", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subject.animationIn = 0;
            subject.delayIn = 0;
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectZero];
            [subject hide];
            expect([subject valueForKey:@"dismissTimer"]).to.beNil();
        });

        it(@"calls the dismiss handler", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subject.animationIn = 0;
            subject.delayIn = 0;
            subject.entranceAnimation = AMPopTipEntranceAnimationNone;
            subject.exitAnimation = AMPopTipExitAnimationNone;
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectZero];

            __block BOOL dismissCalled = NO;
            subject.dismissHandler = ^{
                dismissCalled = YES;
            };
            [subject hide];
            expect(dismissCalled).after(1).to.beTruthy();
        });

        it(@"removes the popover from the superview", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            subject.animationIn = 0;
            subject.delayIn = 0;
            subject.entranceAnimation = AMPopTipEntranceAnimationNone;
            subject.exitAnimation = AMPopTipExitAnimationNone;
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectZero];

            [subject hide];
            expect(subject.superview).after(1).to.beNil();
        });
    });

    describe(@"updateText:", ^{
        it(@"updates the text", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectMake(100, 100, 1, 1)];
            [subject updateText:@"Hello! Have a nice day!"];
            if (kRECORD) expect(view).to.recordSnapshotNamed(@"Updated-Text");
            expect(view).to.haveValidSnapshotNamed(@"Updated-Text");
        });
    });

    describe(@"startActionAnimation", ^{
        it(@"calls bounceAnimation when AMPopTipActionAnimationBounce is set", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectMake(100, 100, 1, 1)];
            subject.actionAnimation = AMPopTipActionAnimationBounce;

            id mock = OCMPartialMock(subject);
            OCMExpect([mock bounceAnimation]);
            [mock startActionAnimation];
            OCMVerifyAll(mock);
        });

        it(@"calls floatAnimation when AMPopTipActionAnimationFloat is set", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectMake(100, 100, 1, 1)];
            subject.actionAnimation = AMPopTipActionAnimationFloat;

            id mock = OCMPartialMock(subject);
            OCMExpect([mock floatAnimation]);
            [mock startActionAnimation];
            OCMVerifyAll(mock);
        });

        it(@"calls pulseAnimation when AMPopTipActionAnimationPulse is set", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectMake(100, 100, 1, 1)];
            subject.actionAnimation = AMPopTipActionAnimationPulse;

            id mock = OCMPartialMock(subject);
            OCMExpect([mock pulseAnimation]);
            [mock startActionAnimation];
            OCMVerifyAll(mock);
        });
    });

    describe(@"stopActionAnimation", ^{
        it(@"removes all the animations", ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            [subject showText:@"Hi" direction:AMPopTipDirectionUp maxWidth:140 inView:view fromFrame:CGRectMake(100, 100, 1, 1)];
            subject.actionAnimation = AMPopTipActionAnimationBounce;
            [subject startActionAnimation];

            [subject stopActionAnimation];
            expect(subject.layer.animationKeys.count).after(1).to.equal(0);
        });
    });
});

SpecEnd
