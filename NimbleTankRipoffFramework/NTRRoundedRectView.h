//
//  NTRRoundedRect.h
//  NimbleTankRipoff
//
//  Created by Augustine on 14/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROUNDED_RECT_SMALL_SIZE CGSizeMake(100,200)

@class NTRRoundedRectView;

@protocol NTRRoundedRectViewDelegate <NSObject>

- (void)selectRoundedRectToFlipOut:(NTRRoundedRectView *)roundedRectView;

@end

@interface NTRRoundedRectView : UIView

@property (nonatomic, strong) id <NTRRoundedRectViewDelegate> delegate;
@property (nonatomic, strong) UIButton *moreInfoButton;

- (NSString *)word;
- (UIView *)buttonSubview;
- (void)setButtonSubview:(UIView *)subview;
- (void)fadeMoreInfoButton:(CGFloat)alpha;
//- (void)flipOutToView:(UIView *)view;

@end