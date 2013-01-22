//
//  NTRMoreInfoView.h
//  NimbleTankRipoff
//
//  Created by Augustine on 16/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>

//Keys for settings that can be put in the settings dictionary
#define PRIMARY_VIEW_RATIO @"primaryViewRatio"
#define PRIMARY_VIEW_ON_WHICH_SIDE @"primaryViewOnWhichSide"
#define IS_VERTICALLY_ORIENTED @"isVerticallyOriented"
#define PRIMARY_VIEW @"primaryView"
#define SECONDARY_VIEW @"secondaryView"

@class NTRMoreInfoView;

enum PrimaryViewOnWhichSide {
  PrimaryViewOnBottom = 0,
  PrimaryViewOnTop = 1,
  PrimaryViewOnLeft = 2,
  PrimaryViewOnRight = 3
  };

@protocol NTRMoreInfoViewDelegate <NSObject>

@optional
- (void)prepareToDismissMoreInfoView:(NTRMoreInfoView *)moreInfoView;
- (void)dismissMoreInfoView:(NTRMoreInfoView *)moreInfoView;

@end

@interface NTRMoreInfoView : UIView

@property (nonatomic, strong) id<NTRMoreInfoViewDelegate> delegate;

- (void)slideOutExtraRoundedRectViews;
- (void)slideInExtraRoundedRectViews;
- (void)setSettings:(NSDictionary *)settings;
- (CGSize)sizeOfPrimaryViewForPrimaryViewRatio:(CGFloat)ratio;
- (CGSize)sizeOfSecondaryViewForPrimaryViewRatio:(CGFloat)ratio;

@end
