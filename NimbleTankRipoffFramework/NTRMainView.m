//
//  NTRMainView.m
//  NimbleTankRipoff
//
//  Created by Augustine on 16/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import "NTRMainView.h"
#import "NTRMoreInfoView.h"
#import <QuartzCore/QuartzCore.h>

@interface NTRMainView() <UITableViewDelegate, NTRMoreInfoViewDelegate>

@property (nonatomic, strong) NTRTableView *ntrTableView;
@property (nonatomic, strong) NTRRoundedRectView *selectedRoundedRectView;

@end

@implementation NTRMainView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.ntrTableView = [[NTRTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.ntrTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.ntrTableView.delegate = self;
    [self addSubview:self.ntrTableView];

    self.sizeOfRoundedRects = CGSizeMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds));
    self.spacingBetweenRoundedRects = 20;
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame andTableViewDataSource:(id<UITableViewDataSource>)dataSource
{
    self = [self initWithFrame:frame];
    if (self) {
      self.ntrTableView.dataSource = dataSource;
    }
    return self;
}

- (void)setNTRTableViewDataSource:(id<UITableViewDataSource>)dataSource {
  self.ntrTableView.dataSource = dataSource;
  [self.ntrTableView reloadData];
}

#pragma mark - NTRRoundedRectViewDelegate

- (void)selectRoundedRectToFlipOut:(NTRRoundedRectView *)roundedRectView {
  self.selectedRoundedRectView = roundedRectView;
  BOOL willNTRTableViewScroll = [self.ntrTableView scrollToCellWithRoundedRectView:roundedRectView];
  if (willNTRTableViewScroll == NO) {
    self.ntrTableView.alpha = 0;
    [self createAndShowMoreInfoView];
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.sizeOfRoundedRects.width + self.spacingBetweenRoundedRects;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  self.ntrTableView.alpha = 0;
  [self createAndShowMoreInfoView];
}

#pragma mark - Animations

- (void)createAndShowMoreInfoView {
  NTRMoreInfoView *moreInfoView = [[NTRMoreInfoView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
  moreInfoView.delegate = self;
  NSIndexPath *indexPath = [self.ntrTableView indexPathOfCellWithRoundedRectView:self.selectedRoundedRectView];
  NSDictionary *settings = [self.delegate settingsForMoreInfoViewForIndexPath:indexPath];
  [moreInfoView setSettings:settings];
  [self addSubview:moreInfoView];
  
  NSArray *fakeRoundedRectViews = [self createFakeRoundedRectViews];
  for (NTRRoundedRectView *roundedRectView in fakeRoundedRectViews) {
    [moreInfoView addSubview:roundedRectView];
  }

  [moreInfoView slideOutExtraRoundedRectViews];
}

- (NSArray *)createFakeRoundedRectViews {

  NSMutableArray *fakeRoundedRectViews = [NSMutableArray array];
  
  for (NTRTableViewCell *cell in [self.ntrTableView visibleCells]) {
    CGRect rect = [self convertRect:cell.roundedRectView.bounds fromView:cell.roundedRectView];
    NTRRoundedRectView *fakeRoundedRectView = [[NTRRoundedRectView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    fakeRoundedRectView.frame = rect;
    [fakeRoundedRectViews addObject:fakeRoundedRectView];
    fakeRoundedRectView.word = [cell word];
  }
  
  return fakeRoundedRectViews;
}

- (void)prepareToDismissMoreInfoView:(NTRMoreInfoView *)moreInfoView {
  NSArray *fakeRoundedRectViews = [self createFakeRoundedRectViews];
  for (NTRRoundedRectView *roundedRectView in fakeRoundedRectViews) {
    [moreInfoView addSubview:roundedRectView];
  }
  
  [moreInfoView slideInExtraRoundedRectViews];
}

- (void)dismissMoreInfoView:(NTRMoreInfoView *)moreInfoView {
  [moreInfoView removeFromSuperview];
  [self.ntrTableView reloadData];
  self.ntrTableView.alpha = 1;

}

//- (void)slideOutExtraRoundedRectViews:(NSArray *)roundedRectViews {
//}
//
//- (void)flipOutRoundedRectView:(NTRRoundedRectView *)roundedRectView {
//  CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//  translateAnimation.fromValue = [NSValue valueWithCGPoint:roundedRectView.layer.position];
//  translateAnimation.toValue = [NSValue valueWithCGPoint:CGPointZero];
//  translateAnimation.duration = 5;
//  [roundedRectView.layer addAnimation:translateAnimation forKey:@"now"];
//}

@end
