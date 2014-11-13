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
#define kDefaultRadius 4
#define kDefaultPadding 6
#define kDefaultArrowSize CGSizeMake(8, 8)
#define kDefaultAnimationIn 0.4
#define kDefaultAnimationOut 0.2

@interface AMPopTip()

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSAttributedString *attributedText;
@property (nonatomic, strong) NSMutableParagraphStyle *paragraphStyle;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *removeGesture;
@property (nonatomic, strong) NSTimer *dismissTimer;
@property (nonatomic, weak  ) UIView *containerView;
@property (nonatomic, assign) AMPopTipDirection direction;
@property (nonatomic, assign) CGRect textBounds;
@property (nonatomic, assign) CGPoint arrowPosition;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGRect fromFrame;

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
        _textAlignment = NSTextAlignmentCenter;
        _font = kDefaultFont;
        _textColor = kDefaultTextColor;
        _popoverColor = kDefaultBackgroundColor;
        _radius = kDefaultRadius;
        _arrowSize = kDefaultArrowSize;
        _animationIn = kDefaultAnimationIn;
        _animationOut = kDefaultAnimationOut;
        _isVisible = NO;
        _shouldDismissOnTapOutside = YES;
        self.padding = kDefaultPadding;
        _edgeMargin = 0;
        
        _removeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeGestureHandler)];
    }
    return self;
}

- (void)dealloc
{
    [_removeGesture removeTarget:self action:@selector(removeGestureHandler)];
    _removeGesture = nil;
}

- (void)setPadding:(CGFloat)padding
{
    _padding = _horizontalPadding = _verticalPadding = padding;
}

- (void)layoutSubviews
{
    [self setup];
}

- (void)setup
{
    if (self.direction == AMPopTipDirectionLeft) {
        self.maxWidth = MIN(self.maxWidth, self.fromFrame.origin.x - self.horizontalPadding * 2 - self.arrowSize.width);
    }
    if (self.direction == AMPopTipDirectionRight) {
        self.maxWidth = MIN(self.maxWidth, self.containerView.bounds.size.width - self.fromFrame.origin.x - self.fromFrame.size.width - self.horizontalPadding * 2 - self.arrowSize.width);
    }
    
    if (self.text != nil) {
        self.textBounds = [self.text boundingRectWithSize:(CGSize){self.maxWidth, DBL_MAX }
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: self.font}
                                                  context:nil];
    } else if (self.attributedText != nil) {
        self.textBounds = [self.attributedText boundingRectWithSize:(CGSize){self.maxWidth, DBL_MAX }
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                            context:nil];
    }
    
    _textBounds.origin = (CGPoint){self.horizontalPadding, self.verticalPadding};
    
    CGRect frame = CGRectZero;
    if (self.direction == AMPopTipDirectionUp || self.direction == AMPopTipDirectionDown) {
        frame.size = (CGSize){self.textBounds.size.width + self.horizontalPadding * 2.0, self.textBounds.size.height + self.verticalPadding * 2.0 + self.arrowSize.height};
        
        CGFloat x = self.fromFrame.origin.x + self.fromFrame.size.width / 2 - frame.size.width / 2;
        if (x < 0) { x = self.edgeMargin; }
        if (x + frame.size.width > self.containerView.bounds.size.width) { x = self.containerView.bounds.size.width - frame.size.width - self.edgeMargin; }
        if (self.direction == AMPopTipDirectionDown) {
            frame.origin = (CGPoint){ x, self.fromFrame.origin.y + self.fromFrame.size.height };
        } else {
            frame.origin = (CGPoint){ x, self.fromFrame.origin.y - frame.size.height};
        }
    } else {
        frame.size = (CGSize){ self.textBounds.size.width + self.horizontalPadding * 2.0 + self.arrowSize.width, self.textBounds.size.height + self.verticalPadding * 2.0};
        
        CGFloat x = 0;
        if (self.direction == AMPopTipDirectionLeft) {
            x = self.fromFrame.origin.x - frame.size.width;
        }
        if (self.direction == AMPopTipDirectionRight) {
            x = self.fromFrame.origin.x + self.fromFrame.size.width;
        }
        
        CGFloat y = self.fromFrame.origin.y + self.fromFrame.size.height / 2 - frame.size.height / 2;
        
        if (y < 0) { y = self.edgeMargin; }
        if (y + frame.size.height > self.containerView.bounds.size.height) { y = self.containerView.bounds.size.height - frame.size.height - self.edgeMargin; }
        frame.origin = (CGPoint){ x, y };
    }
    
    switch (self.direction) {
        case AMPopTipDirectionDown: {
            self.arrowPosition = (CGPoint){
                self.fromFrame.origin.x + self.fromFrame.size.width / 2 - frame.origin.x,
                self.fromFrame.origin.y + self.fromFrame.size.height - frame.origin.y
            };
            CGFloat anchor = self.arrowPosition.x / frame.size.width;
            _textBounds.origin = (CGPoint){ self.textBounds.origin.x, self.textBounds.origin.y + self.arrowSize.height };
            self.layer.anchorPoint = (CGPoint){ anchor, 0 };
            self.layer.position = (CGPoint){ self.layer.position.x + frame.size.width * anchor, self.layer.position.y - frame.size.height / 2 };
            
            break;
        }
        case AMPopTipDirectionUp: {
            self.arrowPosition = (CGPoint){
                self.fromFrame.origin.x + self.fromFrame.size.width / 2 - frame.origin.x,
                frame.size.height
            };
            CGFloat anchor = self.arrowPosition.x / frame.size.width;
            self.layer.anchorPoint = (CGPoint){ anchor, 1 };
            self.layer.position = (CGPoint){ self.layer.position.x + frame.size.width * anchor, self.layer.position.y + frame.size.height / 2 };
            
            break;
        }
        case AMPopTipDirectionLeft: {
            self.arrowPosition = (CGPoint){
                self.fromFrame.origin.x - frame.origin.x,
                self.fromFrame.origin.y + self.fromFrame.size.height / 2 - frame.origin.y
            };
            CGFloat anchor = self.arrowPosition.y / frame.size.height;
            self.layer.anchorPoint = (CGPoint){ 1, anchor };
            self.layer.position = (CGPoint){ self.layer.position.x - frame.size.width / 2, self.layer.position.y + frame.size.height * anchor };
            
            break;
        }
        case AMPopTipDirectionRight: {
            self.arrowPosition = (CGPoint){
                self.fromFrame.origin.x + self.fromFrame.size.width - frame.origin.x,
                self.fromFrame.origin.y + self.fromFrame.size.height / 2 - frame.origin.y
            };
            _textBounds.origin = (CGPoint){ self.textBounds.origin.x + self.arrowSize.width, self.textBounds.origin.y };
            CGFloat anchor = self.arrowPosition.y / frame.size.height;
            self.layer.anchorPoint = (CGPoint){ 0, anchor };
            self.layer.position = (CGPoint){ self.layer.position.x + frame.size.width / 2, self.layer.position.y + frame.size.height * anchor };
            
            break;
        }
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = frame;
    
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:self.gestureRecognizer];
    
    [self setNeedsDisplay];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (self.shouldDismissOnTap) {
        [self hide];
    }
    if (self.tapHandler) {
        self.tapHandler();
    }
}

- (void)removeGestureHandler
{
    if (self.shouldDismissOnTapOutside) {
        [self hide];
    }
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *arrow = [[UIBezierPath alloc] init];
    
    CGRect baloonFrame;
    // Drawing a round rect and the arrow alone sometime show a white halfpixel line, so here's a fun bit of code...
    switch (self.direction) {
        case AMPopTipDirectionDown: {
            baloonFrame = (CGRect){ (CGPoint) { 0, self.arrowSize.height }, (CGSize){ self.frame.size.width, self.frame.size.height - self.arrowSize.height } };
            
            [arrow moveToPoint:self.arrowPosition];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x + self.arrowSize.width / 2, self.arrowPosition.y + self.arrowSize.height }];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.size.width - self.radius, self.arrowSize.height }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.size.width - self.radius,  self.arrowSize.height + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.size.width, self.arrowSize.height + baloonFrame.size.height - self.radius }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.size.width - self.radius,  self.arrowSize.height + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ self.radius, self.arrowSize.height + baloonFrame.size.height }];
            [arrow addArcWithCenter:(CGPoint){ self.radius,  self.arrowSize.height + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ 0, self.arrowSize.height + self.radius }];
            [arrow addArcWithCenter:(CGPoint){ self.radius, self.arrowSize.height + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x - self.arrowSize.width / 2, self.arrowPosition.y + self.arrowSize.height }];
            
            [self.popoverColor setFill];
            [arrow fill];
            
            break;
        }
        case AMPopTipDirectionUp: {
            baloonFrame = (CGRect){ (CGPoint) { 0, 0 }, (CGSize){ self.frame.size.width, self.frame.size.height - self.arrowSize.height } };
            
            [arrow moveToPoint:self.arrowPosition];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x + self.arrowSize.width / 2, self.arrowPosition.y - self.arrowSize.height }];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.size.width - self.radius, baloonFrame.origin.y + baloonFrame.size.height }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.size.width - self.radius, baloonFrame.origin.y + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(0) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.size.width, baloonFrame.origin.y + self.radius }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.size.width - self.radius, baloonFrame.origin.y + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(270) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ self.radius, baloonFrame.origin.y }];
            [arrow addArcWithCenter:(CGPoint){ self.radius, baloonFrame.origin.y + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(180) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ 0, baloonFrame.origin.y + baloonFrame.size.height - self.radius }];
            [arrow addArcWithCenter:(CGPoint){ self.radius, baloonFrame.origin.y + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(90) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x - self.arrowSize.width / 2, self.arrowPosition.y - self.arrowSize.height }];
            
            [self.popoverColor setFill];
            [arrow fill];
            
            break;
        }
        case AMPopTipDirectionLeft: {
            baloonFrame = (CGRect){ (CGPoint) { 0, 0 }, (CGSize){ self.frame.size.width - self.arrowSize.width, self.frame.size.height } };
            
            [arrow moveToPoint:self.arrowPosition];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x - self.arrowSize.width, self.arrowPosition.y - self.arrowSize.height / 2 }];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.size.width, baloonFrame.origin.y + self.radius }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.size.width - self.radius, baloonFrame.origin.y + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(270) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ self.radius, baloonFrame.origin.y }];
            [arrow addArcWithCenter:(CGPoint){ self.radius, baloonFrame.origin.y + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(180) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ 0, baloonFrame.origin.y + baloonFrame.size.height - self.radius }];
            [arrow addArcWithCenter:(CGPoint){ self.radius, baloonFrame.origin.y + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(90) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.size.width - self.radius, baloonFrame.origin.y + baloonFrame.size.height }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.size.width - self.radius, baloonFrame.origin.y + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(0) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x - self.arrowSize.width, self.arrowPosition.y + self.arrowSize.height / 2 }];
            
            [self.popoverColor setFill];
            [arrow fill];
            
            break;
        }
        case AMPopTipDirectionRight: {
            baloonFrame = (CGRect){ (CGPoint) { self.arrowSize.width, 0 }, (CGSize){ self.frame.size.width - self.arrowSize.width, self.frame.size.height } };
            
            [arrow moveToPoint:self.arrowPosition];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x + self.arrowSize.width, self.arrowPosition.y - self.arrowSize.height / 2 }];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.origin.x, baloonFrame.origin.y + self.radius }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.origin.x + self.radius, baloonFrame.origin.y + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.origin.x + baloonFrame.size.width - self.radius, baloonFrame.origin.y }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.origin.x + baloonFrame.size.width - self.radius, baloonFrame.origin.y + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.origin.x + baloonFrame.size.width, baloonFrame.origin.y + baloonFrame.size.height - self.radius }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.origin.x + baloonFrame.size.width - self.radius, baloonFrame.origin.y + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.origin.x + self.radius, baloonFrame.origin.y + baloonFrame.size.height }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.origin.x + self.radius, baloonFrame.origin.y + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x + self.arrowSize.width, self.arrowPosition.y + self.arrowSize.height / 2 }];
            
            [self.popoverColor setFill];
            [arrow fill];
            
            break;
        }
    }
    
    self.paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary *titleAttributes = @{
                                      NSParagraphStyleAttributeName: self.paragraphStyle,
                                      NSFontAttributeName: self.font,
                                      NSForegroundColorAttributeName: self.textColor
                                      };
    
    if (self.text != nil) {
        [self.text drawInRect:self.textBounds withAttributes:titleAttributes];
    } else if (self.attributedText != nil) {
        [self.attributedText drawInRect:self.textBounds];
    }
}

- (void)show
{
    [self setNeedsLayout];
    
    self.transform = CGAffineTransformMakeScale(0, 0);
    [self.containerView addSubview:self];
    _isVisible = YES;
    
    [UIView animateWithDuration:self.animationIn delay:self.delayIn usingSpringWithDamping:0.5 initialSpringVelocity:3 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL completed){
        if (completed) {
            [self.containerView addGestureRecognizer:self.removeGesture];
            if (self.appearHandler) {
                self.appearHandler();
            }
        }
    }];
}

- (void)showText:(NSString *)text direction:(AMPopTipDirection)direction maxWidth:(CGFloat)maxWidth inView:(UIView *)view fromFrame:(CGRect)frame
{
    self.attributedText = nil;
    self.text = text;
    self.accessibilityLabel = text;
    self.direction = direction;
    self.containerView = view;
    self.maxWidth = maxWidth;
    self.fromFrame = frame;
    
    [self show];
}

- (void)showAttributedText:(NSAttributedString *)text direction:(AMPopTipDirection)direction maxWidth:(CGFloat)maxWidth inView:(UIView *)view fromFrame:(CGRect)frame
{
    self.text = nil;
    self.attributedText = text;
    self.accessibilityLabel = [text string];
    self.direction = direction;
    self.containerView = view;
    self.maxWidth = maxWidth;
    self.fromFrame = frame;
    
    [self show];
}

- (void)showText:(NSString *)text direction:(AMPopTipDirection)direction maxWidth:(CGFloat)maxWidth inView:(UIView *)view fromFrame:(CGRect)frame duration:(NSTimeInterval)interval
{
    [self showText:text direction:direction maxWidth:maxWidth inView:view fromFrame:frame];
    [self.dismissTimer invalidate];
    if (interval > 0) {
        self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                             target:self
                                                           selector:@selector(hide)
                                                           userInfo:nil
                                                            repeats:NO];
    }
}

- (void)showAttributedText:(NSAttributedString *)text direction:(AMPopTipDirection)direction maxWidth:(CGFloat)maxWidth inView:(UIView *)view fromFrame:(CGRect)frame duration:(NSTimeInterval)interval
{
    [self showAttributedText:text direction:direction maxWidth:maxWidth inView:view fromFrame:frame];
    [self.dismissTimer invalidate];
    if(interval > 0){
        self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                             target:self
                                                           selector:@selector(hide)
                                                           userInfo:nil
                                                            repeats:NO];
    }
}

- (void)hide
{
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
    [self.containerView removeGestureRecognizer:self.removeGesture];
    if (self.superview) {
        [UIView animateWithDuration:self.animationOut delay:self.delayOut options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            self.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
                self.transform = CGAffineTransformIdentity;
                self->_isVisible = NO;
                if (self.dismissHandler) {
                    self.dismissHandler();
                }
            }
        }];
    }
}

@end
