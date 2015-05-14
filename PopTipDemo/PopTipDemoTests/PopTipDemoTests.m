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

#define kRECORD     YES

describe(@"AMPopTip", ^{

    beforeAll(^{
        setGlobalReferenceImageDir(FB_REFERENCE_IMAGE_DIR);
    });

    before(^{
        subject = [AMPopTip popTip];
    });

    describe(@"customized via UIAppearance", ^{
        after(^{
            [AMPopTip appearance].font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            [AMPopTip appearance].textColor = [UIColor whiteColor];
            [AMPopTip appearance].textAlignment = NSTextAlignmentCenter;
            [AMPopTip appearance].popoverColor = [UIColor redColor];
            [AMPopTip appearance].borderColor = [UIColor colorWithWhite:0.182 alpha:1.000];
            [AMPopTip appearance].borderWidth = 0;
            [AMPopTip appearance].radius = 4;
            [AMPopTip appearance].rounded = NO;
            [AMPopTip appearance].offset = 0;
            [AMPopTip appearance].padding = 6;
            [AMPopTip appearance].edgeInsets = UIEdgeInsetsZero;
            [AMPopTip appearance].arrowSize = CGSizeMake(8, 8);
            [AMPopTip appearance].animationIn = 0.4;
            [AMPopTip appearance].animationOut = 0.2;
            [AMPopTip appearance].delayIn = 0;
            [AMPopTip appearance].delayOut = 0;
            [AMPopTip appearance].entranceAnimation = AMPopTipEntranceAnimationScale;
            [AMPopTip appearance].actionFloatOffset = 8;
            [AMPopTip appearance].actionBounceOffset = 8;
            [AMPopTip appearance].actionPulseOffset = 1.1;
            [AMPopTip appearance].actionAnimationIn = 0;
            [AMPopTip appearance].actionAnimationOut = 0;
            [AMPopTip appearance].actionDelayIn = 0;
            [AMPopTip appearance].actionDelayOut = 0;
            [AMPopTip appearance].edgeMargin = 0;
        });

        it(@"looks right", ^{
            UIViewController *controller = [[UIViewController alloc] init];

            [AMPopTip appearance].font = [UIFont fontWithName:@"Avenir-Light" size:20];
            [AMPopTip appearance].textColor = [UIColor redColor];
            [AMPopTip appearance].textAlignment = NSTextAlignmentCenter;
            [AMPopTip appearance].popoverColor = [UIColor yellowColor];
            [AMPopTip appearance].borderColor = [UIColor colorWithWhite:0.5 alpha:1.000];
            [AMPopTip appearance].borderWidth = 2;
            [AMPopTip appearance].radius = 0;
            [AMPopTip appearance].offset = 10;
            [AMPopTip appearance].padding = 2;
            [AMPopTip appearance].edgeInsets = UIEdgeInsetsMake(4, 2, 4, 2);
            [AMPopTip appearance].arrowSize = CGSizeMake(12, 12);
            [AMPopTip appearance].animationIn = 0;
            [AMPopTip appearance].animationOut = 0;
            [AMPopTip appearance].entranceAnimation = AMPopTipEntranceAnimationNone;
            [AMPopTip appearance].edgeMargin = 2;

            subject = [AMPopTip popTip];

            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionDown
                     maxWidth:140
                       inView:controller.view
                    fromFrame:CGRectMake(0, 0, 100, 100)];

            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"Appearance");
            expect(controller.view).to.haveValidSnapshotNamed(@"Appearance");

        });

        it(@"can be rounded", ^{
            UIViewController *controller = [[UIViewController alloc] init];

            [AMPopTip appearance].rounded = YES;

            subject = [AMPopTip popTip];

            [subject showText:@"It's all smooth sailing\nFrom here on out"
                    direction:AMPopTipDirectionDown
                     maxWidth:140
                       inView:controller.view
                    fromFrame:CGRectMake(0, 0, 100, 100)];

            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"Rounded");
            expect(controller.view).to.haveValidSnapshotNamed(@"Rounded");
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
