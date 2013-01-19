//
//  NTRMoreInfoViewLowerHalf.h
//  NimbleTankRipoff
//
//  Created by Augustine on 16/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTRMoreInfoViewLowerHalf : UIView

- (void)fadeAlphaTo:(CGFloat)alpha completion:(void (^)(BOOL success))completion;
- (void)setCloseButtonTarget:(UIView *)target;

@end
