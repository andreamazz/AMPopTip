//
//  PopTipDemoTests.m
//  PopTipDemoTests
//
//  Created by Andrea Mazzini on 11/07/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#define EXP_SHORTHAND
#include <Specta/Specta.h>
#include <Expecta/Expecta.h>
#include <Expecta+Snapshots/EXPMatchers+FBSnapshotTest.h>

#include "AMPopTip.h"

SpecBegin(PopTipDemoTests)

#define kRECORD     NO

describe(@"AMPopTip", ^{
   
    it(@"Top left", ^{
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
    
    it(@"Top right", ^{
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
    
    it(@"Bottom left", ^{
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
    
    it(@"Bottom right", ^{
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

SpecEnd
