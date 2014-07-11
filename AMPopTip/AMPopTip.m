//
//  AMPopTip.m
//  PopTipDemo
//
//  Created by Andrea Mazzini on 11/07/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "AMPopTip.h"

#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

#define kDefaultFont [UIFont systemFontOfSize:[UIFont systemFontSize]]
#define kDefaultTextColor [UIColor whiteColor]
#define kDefaultBackgroundColor [UIColor redColor]
#define kDefaultRadius 8
#define kDefaultPadding 6
#define kDefaultArrowSize CGSizeMake(16, 8)

@interface AMPopTip()

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) AMPopTipDirection direction;
@property (nonatomic, weak  ) UIView *containerView;
@property (nonatomic, assign) CGRect textBounds;
@property (nonatomic, assign) CGPoint arrowPosition;
@property (nonatomic, strong) NSMutableParagraphStyle *paragraphStyle;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGRect fromFrame;
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation AMPopTip

+ (instancetype)popTip
{
    return [[AMPopTip alloc] init];
}

- (instancetype)initWithFrame:(CGRect)ignoredFrame
{
    return [self init];
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        _paragraphStyle.alignment = NSTextAlignmentCenter;
        _font = kDefaultFont;
        _textColor = kDefaultTextColor;
        _popoverColor = kDefaultBackgroundColor;
        _radius = kDefaultRadius;
        _padding = kDefaultPadding;
        _arrowSize = kDefaultArrowSize;
        _isVisible = NO;
        _isAnimating = NO;
    }
    return self;
}

- (void)setup
{
    self.textBounds = [self.text boundingRectWithSize:(CGSize){self.maxWidth, DBL_MAX }
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: self.font}
                                              context:nil];
    
    _textBounds.origin = (CGPoint){self.padding, self.padding};
    
    CGRect frame = CGRectZero;
    if (self.direction == AMPopTipDirectionUp || self.direction == AMPopTipDirectionDown) {
        frame.size = (CGSize){self.textBounds.size.width + self.padding * 2.0, self.textBounds.size.height + self.padding * 2.0 + self.arrowSize.height};
        
        CGFloat x = self.fromFrame.origin.x + self.fromFrame.size.width / 2 - frame.size.width / 2;
        if (x < 0) { x = 0; }
        if (x + frame.size.width > self.containerView.frame.size.width) { x = self.containerView.frame.size.width - frame.size.width; }
        if (self.direction == AMPopTipDirectionDown) {
            frame.origin = (CGPoint){ x, self.fromFrame.origin.y + self.fromFrame.size.height};
        } else {

        }
    } else {
        frame.size = (CGSize){ self.textBounds.size.width + self.padding * 2.0 + self.arrowSize.height, self.textBounds.size.height + self.padding * 2.0};
        // TODO: maxWidth = MIN(maxWidth, space_between_bound_and_tip)
    }
    
    switch (self.direction) {
        case AMPopTipDirectionDown: {
            self.arrowPosition = (CGPoint){
                self.fromFrame.origin.x + self.fromFrame.size.width / 2 - frame.origin.x,
                self.fromFrame.origin.y + self.fromFrame.size.height - frame.origin.y
            };
            _textBounds.origin = (CGPoint){ self.textBounds.origin.x, self.textBounds.origin.y + self.arrowSize.height };
            self.layer.anchorPoint = (CGPoint){ 0.5, 0 };
            self.layer.position = (CGPoint){ self.layer.position.x, self.layer.position.y - frame.size.height / 2 };
            
            break;
        }
        case AMPopTipDirectionUp: {

            break;
        }
        case AMPopTipDirectionLeft: {
            break;
        }
        case AMPopTipDirectionRight: {
            break;
        }
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = frame;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *arrow = [[UIBezierPath alloc] init];
    
    CGRect baloonFrame;
    switch (self.direction) {
        case AMPopTipDirectionDown: {
            baloonFrame = (CGRect){ (CGPoint) { 0, self.arrowSize.height }, (CGSize){ self.frame.size.width, self.frame.size.height - self.arrowSize.height } };
            
            [arrow moveToPoint:self.arrowPosition];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x - self.arrowSize.width / 2, self.arrowPosition.y + self.arrowSize.height }];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x + self.arrowSize.width / 2, self.arrowPosition.y + self.arrowSize.height }];

            [self.popoverColor setFill];
            [arrow fill];
            
            break;
        }
        case AMPopTipDirectionUp: {
            baloonFrame = (CGRect){ (CGPoint) { 0, 0 }, (CGSize){ self.frame.size.width, self.frame.size.height - self.arrowSize.height } };
            break;
        }
        case AMPopTipDirectionLeft: {
            baloonFrame = (CGRect){ (CGPoint) { 0, 0 }, (CGSize){ self.frame.size.width, self.frame.size.height - self.arrowSize.height } };
            break;
        }
        case AMPopTipDirectionRight: {
            baloonFrame = (CGRect){ (CGPoint) { 0, 0 }, (CGSize){ self.frame.size.width, self.frame.size.height - self.arrowSize.height } };
            break;
        }
    }

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:baloonFrame cornerRadius:self.radius];
    
    [self.popoverColor setFill];
    [path fill];
    
    NSDictionary *titleAttributes = @{
                           NSParagraphStyleAttributeName: self.paragraphStyle,
                           NSFontAttributeName: self.font,
                           NSForegroundColorAttributeName: self.textColor
                           };
    
    [self.text drawInRect:self.textBounds withAttributes:titleAttributes];
}

- (BOOL)showText:(NSString *)text direction:(AMPopTipDirection)direction maxWidth:(CGFloat)maxWidth inView:(UIView *)view fromFrame:(CGRect)frame
{
    if (_isVisible || _isAnimating) {
        return NO;
    }
    
    self.text = text;
    self.direction = direction;
    self.containerView = view;
    self.maxWidth = maxWidth;
    self.fromFrame = frame;
    
    [self setup];

    self.isAnimating = YES;
    self.transform = CGAffineTransformMakeScale(0, 0);
    [self.containerView addSubview:self];
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
        self->_isVisible = YES;
    }];
    return YES;
}

- (BOOL)hide
{
    if (!_isVisible || _isAnimating) {
        return NO;
    }
    self.isAnimating = YES;
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.transform = CGAffineTransformIdentity;
        self.isAnimating = NO;
        self->_isVisible = NO;
    }];
    return YES;
}

@end
