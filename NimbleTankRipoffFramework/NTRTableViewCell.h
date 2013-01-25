//
//  NTRTableViewCell.h
//  NimbleTankRipoff
//
//  Created by Augustine on 14/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NTRRoundedRectView.h"

@interface NTRTableViewCell : UITableViewCell
@property (nonatomic, strong) NTRRoundedRectView *roundedRectView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier flipOutSuperview:(id <NTRRoundedRectViewDelegate>)flipOutSuperview;
- (NSString *)word;
- (void)setWord:(NSString *)zawaado;
- (BOOL)containsRoundedRectView:(NTRRoundedRectView *)aRoundedRectView;
- (void)setRoundedRectSize:(CGSize)size andSpacing:(CGFloat)spacing;
- (void)setRoundedRectBackgroundColor:(UIColor *)backgroundColor;

@end
