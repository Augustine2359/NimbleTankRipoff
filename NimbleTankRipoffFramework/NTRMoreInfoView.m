//
//  NTRMoreInfoView.m
//  NimbleTankRipoff
//
//  Created by Augustine on 16/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import "NTRMoreInfoView.h"
#import <QuartzCore/QuartzCore.h>

#define VIEW_BEING_ANIMATED @"viewBeingAnimated"
#define IS_ROUNDED_RECT_VIEW_FLIPPING_OUT @"isRoundedRectViewFlippingOut"
#define ROUNDED_RECT_VIEW_FLIP_OUT @"roundedRectFlipOut"
#define ROUNDED_RECT_VIEW_FLIP_IN @"roundedRectFlipIn"

@interface NTRMoreInfoView()

@property (nonatomic, strong) UIView *primaryView;
@property (nonatomic, strong) UIView *secondaryView;
@property (nonatomic) CGFloat primaryViewRatio;
@property (nonatomic, strong) NTRRoundedRectView *middleRoundedRectView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic) enum PrimaryViewOnWhichSide primaryViewOnWhichSide;

@end

@implementation NTRMoreInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.primaryViewRatio = 0.5;
      self.primaryViewOnWhichSide = PrimaryViewOnBottom;

      self.secondaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)/2)];
      self.secondaryView.backgroundColor = [UIColor whiteColor];
      self.secondaryView.alpha = 0;

      [self addSubview:self.secondaryView];
      self.primaryView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)/2, CGRectGetWidth(frame), CGRectGetHeight(frame)/2)];
      self.primaryView.alpha = 0;
      [self addSubview:self.primaryView];
      [self reframeSubviews];

      self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
      self.closeButton.frame = CGRectMake(0, 0, 100, 100);
      self.closeButton.alpha = 0;
      [self.closeButton addTarget:self action:@selector(onCloseButton:) forControlEvents:UIControlEventTouchUpInside];
      [self.primaryView addSubview:self.closeButton];
    }
    return self;
}

- (CGSize)sizeOfPrimaryViewForPrimaryViewRatio:(CGFloat)ratio {
  return CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * ratio);
}

- (CGSize)sizeOfSecondaryViewForPrimaryViewRatio:(CGFloat)ratio {
  return CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * (1 - ratio));
}

- (void)setSettings:(NSDictionary *)settings {
  BOOL containsPrimaryViewRatio = ([settings objectForKey:PRIMARY_VIEW_RATIO] != nil) && ([[settings objectForKey:PRIMARY_VIEW_RATIO] isKindOfClass:[NSNumber class]]);
  if (containsPrimaryViewRatio)
    self.primaryViewRatio = [[settings objectForKey:PRIMARY_VIEW_RATIO] floatValue];

  BOOL containsPrimaryViewOnWhichSide = ([settings objectForKey:PRIMARY_VIEW_ON_WHICH_SIDE] != nil) && ([[settings objectForKey:PRIMARY_VIEW_ON_WHICH_SIDE] isKindOfClass:[NSNumber class]]);
  if (containsPrimaryViewOnWhichSide)
    self.primaryViewOnWhichSide = [[settings objectForKey:PRIMARY_VIEW_ON_WHICH_SIDE] intValue];

  BOOL containsPrimaryView = ([settings objectForKey:PRIMARY_VIEW] != nil) && ([[settings objectForKey:PRIMARY_VIEW] isKindOfClass:[UIView class]]);
  if (containsPrimaryView) {
    for (UIView *subview in self.primaryView.subviews)
      [subview removeFromSuperview];
    UIView *subview = [settings objectForKey:PRIMARY_VIEW];
    subview.alpha = 0;
    [self.primaryView addSubview:[settings objectForKey:PRIMARY_VIEW]];
    [self.primaryView addSubview:self.closeButton];
  }

  BOOL containsSecondaryView = ([settings objectForKey:SECONDARY_VIEW] != nil) && ([[settings objectForKey:SECONDARY_VIEW] isKindOfClass:[UIView class]]);
  if (containsSecondaryView ) {
    for (UIView *subview in self.secondaryView.subviews)
      [subview removeFromSuperview];
    UIView *subview = [settings objectForKey:SECONDARY_VIEW];
    subview.alpha = 0;
    [self.secondaryView addSubview:[settings objectForKey:SECONDARY_VIEW]];
  }

  [self reframeSubviews];
}

- (void)reframeSubviews {
  CGRect primaryViewFrame = CGRectZero;
  CGRect secondaryViewFrame = CGRectZero;

  primaryViewFrame.size = self.frame.size;
  secondaryViewFrame.size = self.frame.size;

  if ((self.primaryViewOnWhichSide == PrimaryViewOnLeft) || (self.primaryViewOnWhichSide == PrimaryViewOnRight)) {
    primaryViewFrame.size.width *= self.primaryViewRatio;
    secondaryViewFrame.size.width *= (1 - self.primaryViewRatio);
  }
  else {
    primaryViewFrame.size.height *= self.primaryViewRatio;
    secondaryViewFrame.size.height *= (1 - self.primaryViewRatio);
  }

  switch (self.primaryViewOnWhichSide) {
    case PrimaryViewOnBottom:
      primaryViewFrame.origin.y = CGRectGetMaxY(secondaryViewFrame);
      break;
    case PrimaryViewOnTop:
      secondaryViewFrame.origin.y = CGRectGetMaxY(primaryViewFrame);
      break;
    case PrimaryViewOnLeft:
      secondaryViewFrame.origin.x = CGRectGetMaxX(primaryViewFrame);
      break;
    case PrimaryViewOnRight:
      primaryViewFrame.origin.x = CGRectGetMaxX(secondaryViewFrame);
      break;
    default: //default is bottom
      primaryViewFrame.origin.y = CGRectGetMaxY(secondaryViewFrame);
      break;
  }

  self.secondaryView.frame = secondaryViewFrame;
  self.primaryView.frame = primaryViewFrame;
}

- (void)slideOutExtraRoundedRectViews {
  for (NTRRoundedRectView *roundedRectView in self.subviews) {
    if ([roundedRectView isKindOfClass:[NTRRoundedRectView class]] == NO)
      continue;
    BOOL rectContainsMiddle = ((CGRectGetMinX(roundedRectView.frame) < self.center.x) && (CGRectGetMaxX(roundedRectView.frame) > self.center.x));
    if (rectContainsMiddle) {
      self.middleRoundedRectView = roundedRectView;
      continue;
    }
    CGRect targetRect;
    if (CGRectGetMinX(roundedRectView.frame) < self.center.x)
      targetRect = CGRectOffset(roundedRectView.frame, -CGRectGetWidth(self.frame), 0);
    else
      targetRect = CGRectOffset(roundedRectView.frame, CGRectGetWidth(self.frame), 0);
    [UIView animateWithDuration:5 delay:0 options:UIViewAnimationCurveEaseOut animations:^ {
      roundedRectView.alpha = 0;
      roundedRectView.frame = targetRect;
    } completion:^(BOOL finished) {
      if (finished)
        [roundedRectView removeFromSuperview];
    }];
  }
  
  [self flipOutRoundedRectView:self.middleRoundedRectView];
}

- (void)flipOutRoundedRectView:(NTRRoundedRectView *)roundedRectView {
//  [roundedRectView flipOutToView:self.primaryView];
  
  self.primaryView.backgroundColor = roundedRectView.backgroundColor;
  
  CGFloat animationDuration = 2;

  CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
  translateAnimation.fromValue = [NSValue valueWithCGPoint:roundedRectView.layer.position];
  translateAnimation.toValue = [NSValue valueWithCGPoint:self.primaryView.layer.position];
  roundedRectView.layer.position = self.primaryView.layer.position;
  
  CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
  resizeAnimation.fromValue = [NSValue valueWithCGRect:roundedRectView.layer.bounds];
  CGRect newBounds = self.primaryView.layer.bounds;
  CGFloat newWidth = newBounds.size.width;
  newBounds.size.width = newBounds.size.height;
  newBounds.size.height = newWidth;
  resizeAnimation.toValue = [NSValue valueWithCGRect:newBounds];
  roundedRectView.layer.bounds = newBounds;
  
  CABasicAnimation *cornerRadiusRemovalAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
  cornerRadiusRemovalAnimation.fromValue = [NSNumber numberWithFloat:roundedRectView.layer.cornerRadius];
  cornerRadiusRemovalAnimation.toValue = [NSNumber numberWithFloat:0];
  roundedRectView.layer.cornerRadius = 0;
  
  CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
  flipAnimation.fromValue = [NSValue valueWithCATransform3D:roundedRectView.layer.transform];
  CATransform3D flipTransform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
  flipTransform = CATransform3DRotate(flipTransform, M_PI_2, 0, 0, 1);
  flipAnimation.toValue = [NSValue valueWithCATransform3D:flipTransform];
  roundedRectView.layer.transform = flipTransform;
  
  CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
  animationGroup.animations = [NSArray arrayWithObjects:translateAnimation, flipAnimation, resizeAnimation, cornerRadiusRemovalAnimation, nil];
  animationGroup.duration = animationDuration;
  animationGroup.fillMode = kCAFillModeForwards;
  animationGroup.removedOnCompletion = NO;
  animationGroup.delegate = self;
  [animationGroup setValue:roundedRectView forKey:VIEW_BEING_ANIMATED];
  [animationGroup setValue:[NSNumber numberWithInt:YES] forKey:IS_ROUNDED_RECT_VIEW_FLIPPING_OUT];
  [roundedRectView.layer addAnimation:animationGroup forKey:ROUNDED_RECT_VIEW_FLIP_OUT];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, animationDuration/2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [roundedRectView hideWordButton:YES];
  });
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  NTRRoundedRectView *roundedRectView = [anim valueForKey:VIEW_BEING_ANIMATED];

  if ([[anim valueForKey:IS_ROUNDED_RECT_VIEW_FLIPPING_OUT] boolValue]) {
    if ([roundedRectView isEqual:self.middleRoundedRectView]) {
      roundedRectView.hidden = YES;
    }

    [self fadeSubviews];
    return;
  }

  [roundedRectView removeFromSuperview];
  [self.delegate dismissMoreInfoView:self];
}

- (void)fadeSubviews {
  self.secondaryView.alpha = 1;
  self.primaryView.alpha = 1;

  CGFloat fadeDuration = 0.5;
  [UIView animateWithDuration:fadeDuration animations:^ {
    self.closeButton.alpha = 1;
    for (UIView *subview in self.primaryView.subviews)
      subview.alpha = 1;
    for (UIView *subview in self.secondaryView.subviews)
      subview.alpha = 1;
  }];
}

- (void)onCloseButton:(UIButton *)button {
  [self.delegate prepareToDismissMoreInfoView:self];
  self.secondaryView.hidden = YES;
  self.primaryView.hidden = YES;
//  [self flipInRoundedRectView];
}

- (void)slideInExtraRoundedRectViews {
  CGRect targetRect;

  NTRRoundedRectView *newMiddleRoundedRectView;
  
  for (NTRRoundedRectView *roundedRectView in self.subviews) {
    if ([roundedRectView isKindOfClass:[NTRRoundedRectView class]] == NO)
      continue;
    BOOL rectContainsMiddle = ((CGRectGetMinX(roundedRectView.frame) < self.center.x) && (CGRectGetMaxX(roundedRectView.frame) > self.center.x));
    if (rectContainsMiddle) {
      if ([roundedRectView isEqual:self.middleRoundedRectView])
        continue;
      else
        newMiddleRoundedRectView = roundedRectView;
      continue;
    }
    targetRect = roundedRectView.frame;
    if (CGRectGetMinX(roundedRectView.frame) < self.center.x)
      roundedRectView.frame = CGRectOffset(roundedRectView.frame, -CGRectGetWidth(self.frame), 0);
    else
      roundedRectView.frame = CGRectOffset(roundedRectView.frame, CGRectGetWidth(self.frame), 0);
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseIn animations:^ {
      roundedRectView.alpha = 1;
      roundedRectView.frame = targetRect;
    } completion:^(BOOL finished) {
      if (finished)
        ;//        [roundedRectView removeFromSuperview];
    }];
  }
  
  [self flipInRoundedRectView:newMiddleRoundedRectView];
}

- (void)flipInRoundedRectView:(NTRRoundedRectView *)newMiddleRoundedRectView {
  newMiddleRoundedRectView.hidden = YES;
  self.middleRoundedRectView.hidden = NO;
  
  CGFloat animationDuration = 2;
  
  CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
  translateAnimation.fromValue = [NSValue valueWithCGPoint:self.middleRoundedRectView.layer.position];
  translateAnimation.toValue = [NSValue valueWithCGPoint:newMiddleRoundedRectView.layer.position];
  
  CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
  CGRect oldBounds = self.primaryView.layer.bounds;
  CGFloat oldWidth = CGRectGetWidth(oldBounds);
  oldBounds.size.width = oldBounds.size.height;
  oldBounds.size.height = oldWidth;
  resizeAnimation.fromValue = [NSValue valueWithCGRect:oldBounds];
  CGRect newBounds = newMiddleRoundedRectView.layer.bounds;
  resizeAnimation.toValue = [NSValue valueWithCGRect:newBounds];
  
  CABasicAnimation *cornerRadiusRemovalAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
  cornerRadiusRemovalAnimation.fromValue = [NSNumber numberWithFloat:self.middleRoundedRectView.layer.cornerRadius];
  cornerRadiusRemovalAnimation.toValue = [NSNumber numberWithFloat:10];
  
  CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
  flipAnimation.fromValue = [NSValue valueWithCATransform3D:self.middleRoundedRectView.layer.transform];
  flipAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
  
  CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
  animationGroup.animations = [NSArray arrayWithObjects:translateAnimation, resizeAnimation, flipAnimation, cornerRadiusRemovalAnimation, nil];
  animationGroup.duration = animationDuration;
  animationGroup.fillMode = kCAFillModeForwards;
  animationGroup.removedOnCompletion = NO;
  animationGroup.delegate = self;
  [animationGroup setValue:self.middleRoundedRectView forKey:VIEW_BEING_ANIMATED];
  [animationGroup setValue:[NSNumber numberWithInt:NO] forKey:IS_ROUNDED_RECT_VIEW_FLIPPING_OUT];
  [self.middleRoundedRectView.layer addAnimation:animationGroup forKey:ROUNDED_RECT_VIEW_FLIP_IN];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, animationDuration/2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self.middleRoundedRectView hideWordButton:NO];
  });
}

@end
