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

@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, strong) AMPopTip *popTip;

@end

@implementation AMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.popTip = [AMPopTip popTip];
}

- (IBAction)actionButton:(id)sender
{
    [self.popTip showText:@"I'm a popover popping over" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:self.button.frame];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.popTip hide];
    [self.popTip setNeedsLayout];
}

@end
