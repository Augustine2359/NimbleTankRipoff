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

- (NSString *)word;
- (void)setWord:(NSString *)zawaado;
- (void)hideWordButton:(BOOL)hidden;
//- (void)flipOutToView:(UIView *)view;

@end