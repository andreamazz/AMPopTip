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

#define kRECORD     NO

describe(@"AMPopTip", ^{
   
    beforeAll(^{
        setGlobalReferenceImageDir(FB_REFERENCE_IMAGE_DIR);
    });
    
    describe(@"can be customised via UIAppearance", ^{

    });
    
    context(@"showText:direction:maxWidth:inView:fromFrame:", ^{
        it(@"displays well in the top left", ^{
            UIViewController *controller = [[UIViewController alloc] init];
            
            AMPopTip *popTip = [AMPopTip popTip];
            
            [popTip showText:@"It's all smooth sailing\nFrom here on out"
                   direction:AMPopTipDirectionDown
                    maxWidth:140
                      inView:controller.view
                   fromFrame:CGRectMake(0, 0, 100, 100)];
            
            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"TopLeft-Down");
            expect(controller.view).to.haveValidSnapshotNamed(@"TopLeft-Down");
            
            
            [popTip showText:@"It's all smooth sailing\nFrom here on out"
                   direction:AMPopTipDirectionRight
                    maxWidth:140
                      inView:controller.view
                   fromFrame:CGRectMake(0, 0, 100, 100)];
            
            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"TopLeft-Right");
            expect(controller.view).to.haveValidSnapshotNamed(@"TopLeft-Right");
        });
        
        it(@"displays well in the top right", ^{
            UIViewController *controller = [[UIViewController alloc] init];
            
            AMPopTip *popTip = [AMPopTip popTip];
            
            [popTip showText:@"It's all smooth sailing\nFrom here on out"
                   direction:AMPopTipDirectionDown
                    maxWidth:140
                      inView:controller.view
                   fromFrame:CGRectMake(controller.view.frame.size.width - 100, 0, 100, 100)];
            
            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"TopRight-Down");
            expect(controller.view).to.haveValidSnapshotNamed(@"TopRight-Down");
            
            
            [popTip showText:@"It's all smooth sailing\nFrom here on out"
                   direction:AMPopTipDirectionLeft
                    maxWidth:140
                      inView:controller.view
                   fromFrame:CGRectMake(controller.view.frame.size.width - 100, 0, 100, 100)];
            
            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"TopRight-Left");
            expect(controller.view).to.haveValidSnapshotNamed(@"TopRight-Left");
        });
        
        it(@"displays well in the bottom left", ^{
            UIViewController *controller = [[UIViewController alloc] init];
            
            AMPopTip *popTip = [AMPopTip popTip];
            
            [popTip showText:@"It's all smooth sailing\nFrom here on out"
                   direction:AMPopTipDirectionUp
                    maxWidth:140
                      inView:controller.view
                   fromFrame:CGRectMake(0, controller.view.frame.size.height - 100, 100, 100)];
            
            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"BottomLeft-Down");
            expect(controller.view).to.haveValidSnapshotNamed(@"BottomLeft-Down");
            
            
            [popTip showText:@"It's all smooth sailing\nFrom here on out"
                   direction:AMPopTipDirectionRight
                    maxWidth:140
                      inView:controller.view
                   fromFrame:CGRectMake(0, controller.view.frame.size.height - 100, 100, 100)];
            
            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"BottomLeft-Right");
            expect(controller.view).to.haveValidSnapshotNamed(@"BottomLeft-Right");
        });
        
        it(@"displays well in the bottom right", ^{
            UIViewController *controller = [[UIViewController alloc] init];
            
            AMPopTip *popTip = [AMPopTip popTip];
            
            [popTip showText:@"It's all smooth sailing\nFrom here on out"
                   direction:AMPopTipDirectionUp
                    maxWidth:140
                      inView:controller.view
                   fromFrame:CGRectMake(controller.view.frame.size.width - 100, controller.view.frame.size.height - 100, 100, 100)];
            
            if (kRECORD) expect(controller.view).to.recordSnapshotNamed(@"BottomRight-Down");
            expect(controller.view).to.haveValidSnapshotNamed(@"BottomRight-Down");
            
            
            [popTip showText:@"It's all smooth sailing\nFrom here on out"
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
