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
@class NTRMainView;

@protocol NTRMainViewDelegate <NSObject>

- (NSString *)wordForIndexPath:(NSIndexPath *)indexPath;
- (NSDictionary *)settingsForMoreInfoViewForIndexPath:(NSIndexPath *)indexPath;

@end

@interface NTRMainView : UIView <NTRRoundedRectViewDelegate>

@property (nonatomic) CGSize sizeOfRoundedRects;          //used to calculate height of tableViewCells
@property (nonatomic) CGFloat spacingBetweenRoundedRects; //used to calculate height of tableViewCells
@property (nonatomic, strong) id<NTRMainViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andTableViewDataSource:(id<UITableViewDataSource>)dataSource;
- (void)setNTRTableViewDataSource:(id<UITableViewDataSource>)dataSource;

@end
