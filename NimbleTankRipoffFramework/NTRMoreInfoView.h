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

@end
