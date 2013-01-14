//
//  NTRTableView.m
//  NimbleTankRipoff
//
//  Created by Augustine on 14/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import "NTRTableView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NTRTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
      self.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
      self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
