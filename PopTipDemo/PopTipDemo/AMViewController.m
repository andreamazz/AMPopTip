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
@property (nonatomic, weak) IBOutlet UISegmentedControl *segment;

@property (nonatomic, strong) AMPopTip *popTip;

@end

@implementation AMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.popTip = [AMPopTip popTip];
}

- (IBAction)actionButton:(UIButton *)sender
{
    if (sender == self.buttonTopLeft) {
        [self.popTip showText:@"I'm a popover popping over" direction:AMPopTipDirectionDown maxWidth:200 inView:self.view fromFrame:sender.frame];
    }
    if (sender == self.buttonTopRight) {
        [self.popTip showText:@"I'm a popover popping over" direction:AMPopTipDirectionDown maxWidth:200 inView:self.view fromFrame:sender.frame];
    }
    if (sender == self.buttonBottomLeft) {
        [self.popTip showText:@"I'm a popover popping over" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:sender.frame];
    }
    if (sender == self.buttonBottomRight) {
        [self.popTip showText:@"I'm a popover popping over" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:sender.frame];
    }
    if (sender == self.buttonCenter) {
        [self.popTip showText:@"I'm a popover popping over" direction:self.segment.selectedSegmentIndex maxWidth:200 inView:self.view fromFrame:sender.frame];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.popTip hide];
    [self.popTip setNeedsLayout];
}

@end
