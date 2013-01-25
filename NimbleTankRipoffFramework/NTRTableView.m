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
      self.transform = CGAffineTransformMakeRotation(-M_PI_2);
      self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      self.showsHorizontalScrollIndicator = NO;
      self.showsVerticalScrollIndicator = NO;
      self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (BOOL)scrollToCellWithRoundedRectView:(NTRRoundedRectView *)roundedRectView animated:(BOOL)animated {
  NSIndexPath *indexPathToScrollTo;
  for (NTRTableViewCell *cell in [self visibleCells]) {
    if ([cell containsRoundedRectView:roundedRectView]) {
      indexPathToScrollTo = [self indexPathForCell:cell];
      CGPoint contentOffset = [self convertPoint:cell.bounds.origin fromView:cell];
      contentOffset.y -= (CGRectGetHeight(self.bounds) - CGRectGetHeight(cell.bounds))/2;

      if (CGPointEqualToPoint(contentOffset, self.contentOffset)) {
        return NO;
      }
      [self setContentOffset:contentOffset animated:animated];
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
