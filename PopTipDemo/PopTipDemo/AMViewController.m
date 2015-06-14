//
//  AMViewController.m
//  PopTipDemo
//
//  Created by Andrea Mazzini on 11/07/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "AMViewController.h"
#import "AMPopTip.h"

@interface AMViewController ()

@property (nonatomic, weak) IBOutlet UIButton *buttonTopLeft;
@property (nonatomic, weak) IBOutlet UIButton *buttonTopRight;
@property (nonatomic, weak) IBOutlet UIButton *buttonBottomLeft;
@property (nonatomic, weak) IBOutlet UIButton *buttonBottomRight;
@property (nonatomic, weak) IBOutlet UIButton *buttonCenter;

@property (nonatomic, strong) AMPopTip *popTip;

@end

@implementation AMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AMPopTip appearance].font = [UIFont fontWithName:@"Avenir-Medium" size:12];

    self.popTip = [AMPopTip popTip];
    self.popTip.shouldDismissOnTap = YES;
    self.popTip.edgeMargin = 5;
    self.popTip.offset = 2;
    self.popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.popTip.tapHandler = ^{
        NSLog(@"Tap!");
    };
    self.popTip.dismissHandler = ^{
        NSLog(@"Dismiss!");
    };
}

- (IBAction)actionButton:(UIButton *)sender {
    [self.popTip hide];
    
    if ([self.popTip isVisible]) {
        return;
    }

    self.popTip.shouldDismissOnTap = YES;
    
    /*  Custom entrance animation  */
//    self.popTip.entranceAnimation = AMPopTipEntranceAnimationCustom;
//    __weak AMViewController *weakSelf = self;
//    self.popTip.entranceAnimationHandler = ^(void (^completion)(void)){
//        // Setup the animation
//        weakSelf.popTip.transform = CGAffineTransformMakeRotation(M_PI);
//        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.5 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
//            weakSelf.popTip.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL done){
//            completion();
//        }];
//    };

    /*  Entrance animation  */
//    self.popTip.entranceAnimation = AMPopTipEntranceAnimationTransition;


    /*  Custom action animation  */
//    self.popTip.actionAnimation = AMPopTipActionAnimationBounce;

    
    if (sender == self.buttonTopLeft) {
        self.popTip.popoverColor = [UIColor colorWithRed:0.95 green:0.65 blue:0.21 alpha:1];
        [self.popTip showText:@"I'm a popover popping over" direction:AMPopTipDirectionDown maxWidth:200 inView:self.view fromFrame:sender.frame];
    }
    if (sender == self.buttonTopRight) {
        self.popTip.popoverColor = [UIColor colorWithRed:0.97 green:0.9 blue:0.23 alpha:1];
        [self.popTip showText:@"I'm a popover popping over" direction:AMPopTipDirectionDown maxWidth:200 inView:self.view fromFrame:sender.frame];
    }
    if (sender == self.buttonBottomLeft) {
        self.popTip.popoverColor = [UIColor colorWithRed:0.73 green:0.91 blue:0.55 alpha:1];
        [self.popTip showText:@"I'm a popover popping over" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:sender.frame];
    }
    if (sender == self.buttonBottomRight) {
        self.popTip.popoverColor = [UIColor colorWithRed:0.81 green:0.04 blue:0.14 alpha:1];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"I'm a popover popping over " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:12], NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"with attributes!" attributes:@{
                                                                                                                           NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:14],
                                                                                                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                                           NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                                                                                                           }]];
        [self.popTip showAttributedText:attributedText direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:sender.frame];
    }
    if (sender == self.buttonCenter) {
        self.popTip.popoverColor = [UIColor colorWithRed:0.31 green:0.57 blue:0.87 alpha:1];
        static int direction = 0;
        [self.popTip showText:@"Animated popover, great for subtle UI tips and onboarding" direction:direction maxWidth:200 inView:self.view fromFrame:sender.frame duration:0];
        direction = (direction + 1) % 4;
    }
}

@end
