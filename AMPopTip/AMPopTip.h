//
//  AMPopTip.h
//  PopTipDemo
//
//  Created by Andrea Mazzini on 11/07/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

typedef NS_ENUM(NSInteger, AMPopTipDirection) {
    AMPopTipDirectionUp,
    AMPopTipDirectionDown,
    AMPopTipDirectionLeft,
    AMPopTipDirectionRight
};

@interface AMPopTip : UIView

@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *popoverColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat radius UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat padding UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGSize  arrowSize UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign, readonly) BOOL isVisible;

+ (instancetype)popTip;

- (BOOL)showText:(NSString *)text direction:(AMPopTipDirection)direction maxWidth:(CGFloat)maxWidth inView:(UIView *)view fromFrame:(CGRect)frame;
- (BOOL)hide;

@end
