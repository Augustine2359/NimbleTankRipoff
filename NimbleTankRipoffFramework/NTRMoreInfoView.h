//
//  NTRMoreInfoView.h
//  NimbleTankRipoff
//
//  Created by Augustine on 16/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NTRMoreInfoViewUpperHalf.h"
#import "NTRMoreInfoViewLowerHalf.h"

//Keys for settings that can be put in the settings dictionary
#define LOWER_HALF_RATIO @"lowerHalfRatio"
#define SHOULD_FLIP_TO_LOWER_HALF @"shouldFlipToLowerHalf"
#define IS_VERTICALLY_ORIENTED @"isVerticallyOriented"
#define LOWER_HALF_VIEW @"lowerHalfView"
#define UPPER_HALF_VIEW @"upperHalfView"

@class NTRMoreInfoView;

@protocol NTRMoreInfoViewDelegate <NSObject>

@optional
- (void)prepareToDismissMoreInfoView:(NTRMoreInfoView *)moreInfoView;
- (void)dismissMoreInfoView:(NTRMoreInfoView *)moreInfoView;

@end

@interface NTRMoreInfoView : UIView

@property (nonatomic, strong) id<NTRMoreInfoViewDelegate> delegate;

- (void)slideOutExtraRoundedRectViews;
- (void)slideInExtraRoundedRectViews;
- (void)setUpperHalfText:(NSString *)text;

- (void)setSettings:(NSDictionary *)settings;

@end
