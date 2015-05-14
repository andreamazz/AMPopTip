//
//  AMPopTip.h
//  AMPopTip
//
//  Created by Andrea Mazzini on 11/07/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSInteger, AMPopTipDirection) {
    AMPopTipDirectionUp,
    AMPopTipDirectionDown,
    AMPopTipDirectionLeft,
    AMPopTipDirectionRight,
    AMPopTipDirectionNone
};

typedef NS_ENUM(NSInteger, AMPopTipEntranceAnimation) {
    AMPopTipEntranceAnimationScale,
    AMPopTipEntranceAnimationTransition,
    AMPopTipEntranceAnimationNone,
    AMPopTipEntranceAnimationCustom
};

typedef NS_ENUM(NSInteger, AMPopTipActionAnimation) {
    AMPopTipActionAnimationBounce,
    AMPopTipActionAnimationFloat,
    AMPopTipActionAnimationPulse,
    AMPopTipActionAnimationNone
};

@interface AMPopTip : UIView

/**-----------------------------------------------------------------------------
 * @name AMPopTip
 * -----------------------------------------------------------------------------
 */

/** Create a popotip
 *
 * Create a new popotip object
 */
+ (instancetype)popTip;

/** Show the popover
 *
 * Shows an animated popover in a given view, from a given rectangle.
 * The property isVisible will be set as YES as soon as the popover is added to the given view.
 *
 * @param text The text displayed.
 * @param direction The direction of the popover.
 * @param maxWidth The maximum width of the popover. If the popover won't fit in the given space, this will be overridden.
 * @param view The view that will hold the popover.
 * @param frame The originating frame. The popover's arrow will point to the center of this frame.
 */
- (void)showText:(NSString *)text direction:(AMPopTipDirection)direction maxWidth:(CGFloat)maxWidth inView:(UIView *)view fromFrame:(CGRect)frame;

/** Show the popover
 *
 * Shows an animated popover in a given view, from a given rectangle.
 * The property isVisible will be set as YES as soon as the popover is added to the given view.
 *
 * @param text The attributed text displayed.
 * @param direction The direction of the popover.
 * @param maxWidth The maximum width of the popover. If the popover won't fit in the given space, this will be overridden.
 * @param view The view that will hold the popover.
 * @param frame The originating frame. The popover's arrow will point to the center of this frame.
 */
- (void)showAttributedText:(NSAttributedString *)text direction:(AMPopTipDirection)direction maxWidth:(CGFloat)maxWidth inView:(UIView *)view fromFrame:(CGRect)frame;


/** Show the popover
 *
 * Shows an animated popover in a given view, from a given rectangle.
 * The property isVisible will be set as YES as soon as the popover is added to the given view.
 *
 * @param text The text displayed.
 * @param direction The direction of the popover.
 * @param maxWidth The maximum width of the popover. If the popover won't fit in the given space, this will be overridden.
 * @param view The view that will hold the popover.
 * @param frame The originating frame. The popover's arrow will point to the center of this frame.
 * @param interval The time interval that determines when the poptip will self-dismiss
 */
- (void)showText:(NSString *)text direction:(AMPopTipDirection)direction maxWidth:(CGFloat)maxWidth inView:(UIView *)view fromFrame:(CGRect)frame duration:(NSTimeInterval)interval;

/** Show the popover
 *
 * Shows an animated popover in a given view, from a given rectangle.
 * The property isVisible will be set as YES as soon as the popover is added to the given view.
 *
 * @param text The attributed text displayed.
 * @param direction The direction of the popover.
 * @param maxWidth The maximum width of the popover. If the popover won't fit in the given space, this will be overridden.
 * @param view The view that will hold the popover.
 * @param frame The originating frame. The popover's arrow will point to the center of this frame.
 * @param interval The time interval that determines when the poptip will self-dismiss
 */
- (void)showAttributedText:(NSAttributedString *)text direction:(AMPopTipDirection)direction maxWidth:(CGFloat)maxWidth inView:(UIView *)view fromFrame:(CGRect)frame duration:(NSTimeInterval)interval;

/** Hide the popover
 *
 * Hides the popover and removes it from the view.
 * The property isVisible will be set to NO when the animation is complete and the popover is removed from the parent view.
 */
- (void)hide;

/** Update the text
 *
 * Set the new text shown in the poptip
 * @param text The new text
 */
- (void)updateText:(NSString *)text;

/** Makes the popover perform the action animation
 *
 * Makes the popover perform the action indefinitely. The action animation calls for the user's attention after the popover is shown
 */
- (void)startActionAnimation;

/** Stops the popover action animation
 *
 * Stops the popover action animation. Does nothing if the popover wasn't animating in the first place.
 */
- (void)stopActionAnimation;

/**-----------------------------------------------------------------------------
* @name AMPopTip Properties
* -----------------------------------------------------------------------------
*/

/** Font
 *
 * Holds the UIFont used in the popover
 */
@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;

/** Text Color
 *
 * Holds the UIColor of the text
 */
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;

/** Text Alignment
 *  Holds the NSTextAlignment of the text
 */
@property (nonatomic, assign) NSTextAlignment textAlignment UI_APPEARANCE_SELECTOR;

/** Popover Background Color
 *
 * Holds the UIColor for the popover's background
 */
@property (nonatomic, strong) UIColor *popoverColor UI_APPEARANCE_SELECTOR;

/** Popover Border Color
 *
 * Holds the UIColor for the popover's bordedr
 */
@property (nonatomic, strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;

/** Popover Border Width
 *
 * Holds the width for the popover's border
 */
@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;

/** Popover border radius
 *
 * Holds the CGFloat with the popover's border radius
 */
@property (nonatomic, assign) CGFloat radius UI_APPEARANCE_SELECTOR;

/** Rounded popover
 *
 * Holds the BOOL that determines wether the popover is rounded. If set to YES the radius will equal frame.height / 2
 */
@property (nonatomic, assign, getter=isRounded) BOOL rounded UI_APPEARANCE_SELECTOR;

/** Offset from the origin
 *
 * Holds the offset between the popover and origin
 */
@property (nonatomic, assign) CGFloat offset UI_APPEARANCE_SELECTOR;

/** Text Padding
 *
 * Holds the CGFloat with the padding used for the inner text
 */
@property (nonatomic, assign) CGFloat padding UI_APPEARANCE_SELECTOR;

/** Text EdgeInsets
 *
 * Holds the insets setting for padding different direction
 */
@property (nonatomic, assign) UIEdgeInsets edgeInsets UI_APPEARANCE_SELECTOR;

/** Arrow size
 *
 * Holds the CGSize with the width and height of the arrow
 */
@property (nonatomic, assign) CGSize arrowSize UI_APPEARANCE_SELECTOR;

/** Revealing Animation time
 *
 * Holds the NSTimeInterval with the duration of the revealing animation
 */
@property (nonatomic, assign) NSTimeInterval animationIn UI_APPEARANCE_SELECTOR;

/** Disappearing Animation time
 *
 * Holds the NSTimeInterval with the duration of the disappearing animation
 */
@property (nonatomic, assign) NSTimeInterval animationOut UI_APPEARANCE_SELECTOR;

/** Revealing Animation delay
 *
 * Holds the NSTimeInterval with the delay of the revealing animation
 */
@property (nonatomic, assign) NSTimeInterval delayIn UI_APPEARANCE_SELECTOR;

/** Disappearing Animation delay
 *
 * Holds the NSTimeInterval with the delay of the disappearing animation
 */
@property (nonatomic, assign) NSTimeInterval delayOut UI_APPEARANCE_SELECTOR;

/** Entrance animation type
 *
 * Holds the enum with the type of entrance animation (triggered once the popover is shown)
 */
@property (nonatomic, assign) AMPopTipEntranceAnimation entranceAnimation UI_APPEARANCE_SELECTOR;

/** Action animation type
 *
 * Holds the enum with the type of action animation (triggered once the popover is shown)
 */
@property (nonatomic, assign) AMPopTipActionAnimation actionAnimation UI_APPEARANCE_SELECTOR;

/** Offset for the float action animation
 *
 * Holds the offset between the popover initial and ending state during the float action animation
 */
@property (nonatomic, assign) CGFloat actionFloatOffset UI_APPEARANCE_SELECTOR;

/** Offset for the float action animation
 *
 * Holds the offset between the popover initial and ending state during the float action animation
 */
@property (nonatomic, assign) CGFloat actionBounceOffset UI_APPEARANCE_SELECTOR;

/** Offset for the pulse action animation
 *
 * Holds the offset in the popover size during the  pulse action animation
 */
@property (nonatomic, assign) CGFloat actionPulseOffset UI_APPEARANCE_SELECTOR;

/** Action Animation time
 *
 * Holds the NSTimeInterval with the duration of the action animation
 */
@property (nonatomic, assign) NSTimeInterval actionAnimationIn UI_APPEARANCE_SELECTOR;

/** Action Animation stop time
 *
 * Holds the NSTimeInterval with the duration of the action stop animation
 */
@property (nonatomic, assign) NSTimeInterval actionAnimationOut UI_APPEARANCE_SELECTOR;

/** Action Animation delay
 *
 * Holds the NSTimeInterval with the delay of the action animation
 */
@property (nonatomic, assign) NSTimeInterval actionDelayIn UI_APPEARANCE_SELECTOR;

/** Action Animation stop delay
 *
 * Holds the NSTimeInterval with the delay of the action animation stop
 */
@property (nonatomic, assign) NSTimeInterval actionDelayOut UI_APPEARANCE_SELECTOR;

/** Margin from the left efge
 *
 * CGfloat value that determines the leftmost margin from the screen
 */
@property (nonatomic, assign) CGFloat edgeMargin UI_APPEARANCE_SELECTOR;

/** The frame the poptip is pointing to
 *
 * Holds the CGrect with the rect the tip is pointing to
 */
@property (nonatomic, assign) CGRect fromFrame;

/** Visibility
 *
 * Holds the readonly BOOL with the popover visiblity. The popover is considered visible as soon as
 * it's added as a subview, and invisible when the subview is removed from its parent.
 */
@property (nonatomic, assign, readonly) BOOL isVisible;

/** Dismiss on tap
 *
 * A boolean value that determines whether the poptip is dismissed on tap.
 */
@property (nonatomic, assign) BOOL shouldDismissOnTap;

/** Dismiss on tap outside
 *
 * A boolean value that determines whether to dismiss when tapping outside the popover.
 */
@property (nonatomic, assign) BOOL shouldDismissOnTapOutside;

/** Tap handler
 *
 * A block that will be fired when the user taps the popover.
 */
@property (nonatomic, copy) void (^tapHandler)();

/** Dismiss handler
 *
 * A block that will be fired when the popover appears.
 */
@property (nonatomic, copy) void (^appearHandler)();

/** Dismiss handler
 *
 * A block that will be fired when the popover is dismissed.
 */
@property (nonatomic, copy) void (^dismissHandler)();

/** Entrnce animation
 *
 * A block block that handles the entrance animation of the poptip. Should be provided
 * when using a AMPopTipActionAnimationCustom entrance animation type.
 * Please note that the poptip will be automatically added as a subview before firing the block
 * Remember to call the completion block provided
 */
@property (nonatomic, copy) void (^entranceAnimationHandler)(void (^completion)(void));

@end
