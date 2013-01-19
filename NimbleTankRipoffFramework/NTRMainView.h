//
//  NTRMainView.h
//  NimbleTankRipoff
//
//  Created by Augustine on 16/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NTRRoundedRectView.h"

@class NTRRoundedRectView;

@interface NTRMainView : UIView <NTRRoundedRectViewDelegate>

- (id)initWithFrame:(CGRect)frame andTableViewDataSource:(id<UITableViewDataSource>)dataSource;
- (void)setNTRTableViewDataSource:(id<UITableViewDataSource>)dataSource;

@end
