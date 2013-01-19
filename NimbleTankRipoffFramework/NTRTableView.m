//
//  NTRTableView.m
//  NimbleTankRipoff
//
//  Created by Augustine on 14/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import "NTRTableView.h"
#import "NTRTableViewCell.h"
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

- (BOOL)scrollToCellWithRoundedRectView:(NTRRoundedRectView *)roundedRectView {
  NSIndexPath *indexPathToScrollTo;
  for (NTRTableViewCell *cell in [self visibleCells]) {
    if ([cell containsRoundedRectView:roundedRectView]) {
      indexPathToScrollTo = [self indexPathForCell:cell];
      CGPoint contentOffset = [self convertPoint:cell.bounds.origin fromView:cell];
      contentOffset.y -= (CGRectGetHeight(self.bounds) - CGRectGetHeight(cell.bounds))/2;

      if (CGPointEqualToPoint(contentOffset, self.contentOffset)) {
        return NO;
      }
      [self setContentOffset:contentOffset animated:YES];
      return YES;
    }
  }
  return NO;
}

- (NSIndexPath *)indexPathOfCellWithRoundedRectView:(NTRRoundedRectView *)roundedRectView {
  for (NTRTableViewCell *cell in [self visibleCells]) {
    if ([cell containsRoundedRectView:roundedRectView])
      return [self indexPathForCell:cell];
  }
  return nil;
}

@end
