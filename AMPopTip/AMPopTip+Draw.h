//
//  AMPopTip+Draw.h
//  AMPopTip
//
//  Created by Andrea Mazzini on 10/06/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

#import "AMPopTip.h"

@interface AMPopTip (Draw)

- (UIBezierPath *)pathWithRect:(CGRect)rect direction:(AMPopTipDirection)direction;

@end
