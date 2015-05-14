//
//  PopTipDemoTests.m
//  PopTipDemoTests
//
//  Created by Andrea Mazzini on 11/07/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#define EXP_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <Expecta+Snapshots/EXPMatchers+FBSnapshotTest.h>

#import "AMPopTip.h"

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

    context(@"showText:direction:maxWidth:inView:fromFrame:", ^{
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
    
});

SpecEnd
