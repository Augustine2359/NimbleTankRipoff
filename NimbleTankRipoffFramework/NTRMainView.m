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

#define ANIMATION_TYPE @"animationType"

#define DURATION_OF_ENTIRE_ANIMATION 3 //this has to be more than DURATION_OF_CURVED_TRANSLATION_ANIMATION and DURATION_OF_EXPAND_AND_SCROLL_ANIMATION combined
#define DURATION_OF_CURVED_TRANSLATION_ANIMATION 1
#define DURATION_OF_EXPAND_AND_SCROLL_ANIMATION 1

enum AnimationType {
  AnimationTypeCurvedTranslation = 0,
  AnimationTypeExpandAndScroll
  };

@interface NTRMainView() <UITableViewDelegate, NTRMoreInfoViewDelegate>

@property (nonatomic, strong) NTRTableView *ntrTableView;
@property (nonatomic, strong) NTRRoundedRectView *selectedRoundedRectView;
@property (nonatomic) NSInteger lastRoundedRectTag;

@end

@implementation NTRMainView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.sizeOfRoundedRects = CGSizeMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds));
    self.spacingBetweenRoundedRects = 20;

    self.ntrTableView = [[NTRTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.ntrTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.ntrTableView.delegate = self;
    [self addSubview:self.ntrTableView];
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
  BOOL willNTRTableViewScroll = [self.ntrTableView scrollToCellWithRoundedRectView:roundedRectView animated:YES];

  if (willNTRTableViewScroll == NO) {
    self.ntrTableView.alpha = 0;
    [self createAndShowMoreInfoView];
  }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  self.ntrTableView.alpha = 0;
  [self createAndShowMoreInfoView];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.sizeOfRoundedRects.width + self.spacingBetweenRoundedRects;
}

#pragma mark - Animations and graphics

- (void)startingAnimation {
  self.ntrTableView.hidden = YES;

  //give some time for the screen to rotate if it doesn't start in portrait
  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(beginStartingAnimation) userInfo:nil repeats:NO];
}

- (void)beginStartingAnimation {
  CGSize roundedRectViewSize = self.sizeOfRoundedRects;
  NSInteger numberOfRoundedRects = 0;

  for (NSInteger section = 0; section < [self.ntrTableView numberOfSections]; section++) {
    numberOfRoundedRects += [self.ntrTableView numberOfRowsInSection:section];
  }

  self.lastRoundedRectTag = numberOfRoundedRects;
  CGFloat timePerRoundedRect = (DURATION_OF_ENTIRE_ANIMATION - DURATION_OF_CURVED_TRANSLATION_ANIMATION - DURATION_OF_EXPAND_AND_SCROLL_ANIMATION) / numberOfRoundedRects;

  for (NSInteger section = 0; section < [self.ntrTableView numberOfSections]; section++) {
    for (NSInteger row = 0; row < [self.ntrTableView numberOfRowsInSection:section]; row++) {
      NTRRoundedRectView *roundedRectView = [[NTRRoundedRectView alloc] initWithFrame:CGRectMake(0,
                                                                                                 CGRectGetHeight(self.bounds),
                                                                                                 roundedRectViewSize.width,
                                                                                                 roundedRectViewSize.height)];
      NTRTableViewCell *cell = (NTRTableViewCell *)[self.ntrTableView.dataSource tableView:self.ntrTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
      [roundedRectView setButtonSubview:[cell buttonSubview]];
      roundedRectView.backgroundColor = cell.roundedRectView.backgroundColor;
      numberOfRoundedRects--;
      roundedRectView.tag = numberOfRoundedRects;
      [self performSelector:@selector(addCurvedTranslationAnimationToRoundedRectView:)
                 withObject:roundedRectView
                 afterDelay:(timePerRoundedRect) * (self.lastRoundedRectTag - numberOfRoundedRects)];
    }
  }
}

- (void)addCurvedTranslationAnimationToRoundedRectView:(NTRRoundedRectView *)roundedRectView {
  [self addSubview:roundedRectView];
  CGPoint curvedTranslationTarget = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);

  CAKeyframeAnimation *curvedTranslationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  curvedTranslationAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                                                                  [NSNumber numberWithFloat:0.8],
                                                                  [NSNumber numberWithFloat:1], nil];
  curvedTranslationAnimation.calculationMode = kCAAnimationPaced;
  curvedTranslationAnimation.fillMode = kCAFillModeForwards;
  curvedTranslationAnimation.removedOnCompletion = NO;

  CGMutablePathRef curvedPath = CGPathCreateMutable();
  CGPathMoveToPoint(curvedPath, NULL, roundedRectView.layer.position.x, roundedRectView.layer.position.y);
  CGPathAddQuadCurveToPoint(curvedPath, NULL,
                            CGRectGetWidth(self.bounds),
                            CGRectGetHeight(self.bounds) * 3/4,
                            curvedTranslationTarget.x,
                            curvedTranslationTarget.y);

  CGPoint linearTranslationTarget = CGPointMake(curvedTranslationTarget.x - ((CGRectGetWidth(roundedRectView.bounds) + self.spacingBetweenRoundedRects) * roundedRectView.tag),
                                                curvedTranslationTarget.y);
  CGPathAddLineToPoint(curvedPath, NULL,
                       linearTranslationTarget.x,
                       linearTranslationTarget.y);

  curvedTranslationAnimation.path = curvedPath;
  CGPathRelease(curvedPath);
  curvedTranslationAnimation.duration = DURATION_OF_CURVED_TRANSLATION_ANIMATION;
  curvedTranslationAnimation.delegate = self;
  [curvedTranslationAnimation setValue:roundedRectView forKey:VIEW_BEING_ANIMATED];
  [curvedTranslationAnimation setValue:[NSNumber numberWithInt:AnimationTypeCurvedTranslation] forKey:ANIMATION_TYPE];

  roundedRectView.frame = CGRectMake(linearTranslationTarget.x,
                                     linearTranslationTarget.y,
                                     CGRectGetWidth(roundedRectView.bounds),
                                     CGRectGetHeight(roundedRectView.bounds));
  roundedRectView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);

  [roundedRectView.layer addAnimation:curvedTranslationAnimation forKey:@"curvedTranslationAndLeave"];
}

- (void)expandAndScrollRoundedRects {
  CGSize roundedRectViewSize = self.sizeOfRoundedRects;
  NSInteger numberOfRoundedRects = self.lastRoundedRectTag - 1; //-1 because you don't count the one in the middle

  CGPoint curvedTranslationTarget = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);

  NSInteger numberOfRemovedRoundedRects = 0;
  for (NTRRoundedRectView *subview in self.subviews) {
    if ([subview isKindOfClass:[NTRRoundedRectView class]]) {
      [subview removeFromSuperview];
      numberOfRemovedRoundedRects++;
    }
  }

  CGFloat xOfFurthestLeftRoundedRectView = CGRectGetWidth(self.bounds)/2 - (roundedRectViewSize.width + self.spacingBetweenRoundedRects) * numberOfRoundedRects - (roundedRectViewSize.width)/2;
  CGFloat scrollByAmount = self.spacingBetweenRoundedRects/2 - xOfFurthestLeftRoundedRectView;

  for (NSInteger section = 0; section < [self.ntrTableView numberOfSections]; section++) {
    for (NSInteger row = 0; row < [self.ntrTableView numberOfRowsInSection:section]; row++) {
      NTRRoundedRectView *roundedRectView = [[NTRRoundedRectView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)/2 - (roundedRectViewSize.width + self.spacingBetweenRoundedRects) * numberOfRoundedRects - (roundedRectViewSize.width/2),
                                                                                                 curvedTranslationTarget.y,
                                                                                                 roundedRectViewSize.width,
                                                                                                 roundedRectViewSize.height)];
      NTRTableViewCell *cell = (NTRTableViewCell *)[self.ntrTableView.dataSource tableView:self.ntrTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
      [roundedRectView setButtonSubview:[cell buttonSubview]];
      roundedRectView.backgroundColor = cell.roundedRectView.backgroundColor;
      [self performSelector:@selector(expandAndScrollRoundedRect:byAmount:) withObject:roundedRectView withObject:[NSNumber numberWithFloat:scrollByAmount]];
      numberOfRoundedRects--;
      roundedRectView.tag = numberOfRoundedRects;
    }
  }
}

- (void)expandAndScrollRoundedRect:(NTRRoundedRectView *)roundedRectView byAmount:(NSNumber *)scrollAmount {
  [self addSubview:roundedRectView];
  CGFloat animationDuration = DURATION_OF_EXPAND_AND_SCROLL_ANIMATION;
  CGFloat speedOfTranslation = [scrollAmount floatValue] / animationDuration;
  CGFloat timeBeforeRoundedRectEntersScreen = (0 - roundedRectView.layer.position.x) / speedOfTranslation;
  if (timeBeforeRoundedRectEntersScreen < 0)
    timeBeforeRoundedRectEntersScreen = 0;
  CGFloat timeBeforeRoundedRectExitsScreen = (CGRectGetWidth(self.bounds) - roundedRectView.layer.position.x) / speedOfTranslation;
  if (timeBeforeRoundedRectExitsScreen > animationDuration)
    timeBeforeRoundedRectExitsScreen = animationDuration;

  CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
  CGPoint targetPosition = roundedRectView.layer.position;
  targetPosition.y = CGRectGetHeight(self.bounds)/2;
  translateAnimation.fromValue = [NSValue valueWithCGPoint:targetPosition];
  targetPosition.x += [scrollAmount floatValue];
  translateAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(targetPosition.x, targetPosition.y)];

  CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
  scaleAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                                                      [NSNumber numberWithFloat:(timeBeforeRoundedRectEntersScreen / animationDuration)],
                                                      [NSNumber numberWithFloat:(timeBeforeRoundedRectExitsScreen / animationDuration)],
                                                      [NSNumber numberWithFloat:1], nil];
  scaleAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)],
                                                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)],
                                                    [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                                    [NSValue valueWithCATransform3D:CATransform3DIdentity], nil];

  CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
  animationGroup.animations = [NSArray arrayWithObjects:translateAnimation, scaleAnimation, nil];
  animationGroup.duration = animationDuration;
  animationGroup.fillMode = kCAFillModeForwards;
  animationGroup.removedOnCompletion = NO;
  animationGroup.delegate = self;
  [animationGroup setValue:roundedRectView forKey:VIEW_BEING_ANIMATED];
  [animationGroup setValue:[NSNumber numberWithInt:AnimationTypeExpandAndScroll] forKey:ANIMATION_TYPE];

  roundedRectView.frame = CGRectMake(targetPosition.x,
                                     targetPosition.y,
                                     CGRectGetWidth(roundedRectView.bounds),
                                     CGRectGetHeight(roundedRectView.bounds));
  DLog(@"%@", NSStringFromCGRect(roundedRectView.frame));

  [roundedRectView.layer addAnimation:animationGroup forKey:@"curvedTranslationAndLeave"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  NTRRoundedRectView *roundedRectView = [anim valueForKey:VIEW_BEING_ANIMATED];
  if (CGRectIntersectsRect(self.frame, roundedRectView.frame) == NO)
    [roundedRectView removeFromSuperview];

  if ((roundedRectView.tag == 0) && [[anim valueForKey:ANIMATION_TYPE] intValue] == AnimationTypeCurvedTranslation) {
    [self expandAndScrollRoundedRects];
  }

  if ((roundedRectView.tag == 0) && [[anim valueForKey:ANIMATION_TYPE] intValue] == AnimationTypeExpandAndScroll) {
    for (NTRRoundedRectView *subview in self.subviews)
      if ([subview isKindOfClass:[NTRRoundedRectView class]])
        [subview removeFromSuperview];

    self.ntrTableView.hidden = NO;
  }
}

- (void)createAndShowMoreInfoView {
  NTRMoreInfoView *moreInfoView = [[NTRMoreInfoView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
  moreInfoView.delegate = self;
  NSIndexPath *indexPath = [self.ntrTableView indexPathOfCellWithRoundedRectView:self.selectedRoundedRectView];
  NSDictionary *settings = [self.delegate settingsForMoreInfoViewForIndexPath:indexPath];
  [moreInfoView setSettings:settings];
  [self addSubview:moreInfoView];
  
  NSArray *fakeRoundedRectViews = [self createFakeRoundedRectViews];
  for (NTRRoundedRectView *roundedRectView in fakeRoundedRectViews)
    [moreInfoView addSubview:roundedRectView];

  [moreInfoView slideOutExtraRoundedRectViews];
}

- (NSArray *)createFakeRoundedRectViews {
  NSMutableArray *fakeRoundedRectViews = [NSMutableArray array];

  for (NTRTableViewCell *cell in [self.ntrTableView visibleCells]) {
    CGRect rect = [self convertRect:cell.roundedRectView.bounds fromView:cell.roundedRectView];
    NTRRoundedRectView *fakeRoundedRectView = [[NTRRoundedRectView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    fakeRoundedRectView.frame = rect;
    fakeRoundedRectView.backgroundColor = cell.roundedRectView.backgroundColor;

    //steals the subview from the cell and put it in the fakeRoundedRect
    UIView *subview = [cell buttonSubview];
    [subview removeFromSuperview];
    [fakeRoundedRectView setButtonSubview:subview];
    [fakeRoundedRectViews addObject:fakeRoundedRectView];
  }

  //puts the subviews back
  [self.ntrTableView reloadData];
  return fakeRoundedRectViews;
}

- (void)prepareToDismissMoreInfoView:(NTRMoreInfoView *)moreInfoView {
  [self.ntrTableView scrollToCellWithRoundedRectView:self.selectedRoundedRectView animated:NO];
  NSArray *fakeRoundedRectViews = [self createFakeRoundedRectViews];
  for (NTRRoundedRectView *roundedRectView in fakeRoundedRectViews) {
    [moreInfoView addSubview:roundedRectView];
  }
  
  [moreInfoView slideInExtraRoundedRectViews];
}

- (void)dismissMoreInfoView:(NTRMoreInfoView *)moreInfoView {
  [self.ntrTableView reloadData];
  self.ntrTableView.alpha = 1;
  [UIView animateWithDuration:FADE_DURATION animations:^ {
    moreInfoView.alpha = 0;
  } completion:^(BOOL finished) {
    if (finished)
      [moreInfoView removeFromSuperview];
  }];
}

@end
