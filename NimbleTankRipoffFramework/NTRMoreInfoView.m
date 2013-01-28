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
      self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

      self.primaryView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)/2, CGRectGetWidth(frame), CGRectGetHeight(frame)/2)];
      self.primaryView.alpha = 0;
      self.primaryView.clipsToBounds = YES;
      [self addSubview:self.primaryView];

      self.secondaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)/2)];
      self.secondaryView.backgroundColor = [UIColor whiteColor];
      self.secondaryView.alpha = 0;
      self.secondaryView.clipsToBounds = YES;
      [self addSubview:self.secondaryView];

      [self reframeSubviews];
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

  BOOL containsCloseButton = ([settings objectForKey:CLOSE_BUTTON] != nil) && ([[settings objectForKey:CLOSE_BUTTON] isKindOfClass:[UIButton class]]);
  [self.closeButton removeFromSuperview];
  if (containsCloseButton) {
    self.closeButton = [settings objectForKey:CLOSE_BUTTON];
    [self.closeButton addTarget:self action:nil forControlEvents:UIControlEventAllEvents];
    [self.primaryView addSubview:self.closeButton];
  }
  //create a default close button if none was provided
  else {
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
    CGRect closeButtonRect = CGRectZero;
    BOOL isSelfVerticallyOriented = (self.primaryViewOnWhichSide == PrimaryViewOnBottom) || (self.primaryViewOnWhichSide == PrimaryViewOnTop);
    if (isSelfVerticallyOriented) {
      closeButtonRect.size = CGSizeMake(100, CGRectGetHeight(self.primaryView.bounds));
      self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    else {
      closeButtonRect.size = CGSizeMake(CGRectGetWidth(self.primaryView.bounds), 100);
      self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    self.closeButton.frame = closeButtonRect;

    self.closeButton.alpha = 0;
    [self.closeButton addTarget:self action:@selector(onCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.primaryView addSubview:self.closeButton];
  }
  [self.closeButton addTarget:self action:@selector(onCloseButton:) forControlEvents:UIControlEventTouchUpInside];

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
    case PrimaryViewOnTop:
      secondaryViewFrame.origin.y = CGRectGetMaxY(primaryViewFrame);
      self.primaryView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      self.secondaryView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      break;
    case PrimaryViewOnLeft:
      secondaryViewFrame.origin.x = CGRectGetMaxX(primaryViewFrame);
      self.primaryView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
      self.secondaryView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
      break;
    case PrimaryViewOnRight:
      primaryViewFrame.origin.x = CGRectGetMaxX(secondaryViewFrame);
      self.primaryView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
      self.secondaryView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
      break;
    default: //default is bottom
      primaryViewFrame.origin.y = CGRectGetMaxY(secondaryViewFrame);
      self.primaryView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      self.secondaryView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      break;
  }

  self.secondaryView.frame = secondaryViewFrame;
  self.primaryView.frame = primaryViewFrame;
}

#pragma mark - Sliding out animation

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
    [UIView animateWithDuration:SLIDE_DURATION delay:0 options:UIViewAnimationCurveEaseOut animations:^ {
      roundedRectView.alpha = 0;
      roundedRectView.frame = targetRect;
    } completion:^(BOOL finished) {
      if (finished)
        [roundedRectView removeFromSuperview];
    }];
  }

  [UIView animateWithDuration:FADE_DURATION animations:^ {
    [self.middleRoundedRectView fadeMoreInfoButton:0];
  } completion:^ (BOOL finished) {
    if (finished)
      [self flipOutRoundedRectView:self.middleRoundedRectView];
  }];
}

- (void)flipOutRoundedRectView:(NTRRoundedRectView *)roundedRectView {
  self.primaryView.backgroundColor = self.middleRoundedRectView.backgroundColor;
  
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

  CAKeyframeAnimation *flipAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
  flipAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:1], nil];
  NSMutableArray *flipValues = [NSMutableArray array];
  CATransform3D flipValue = roundedRectView.layer.transform;
  [flipValues addObject:[NSValue valueWithCATransform3D:flipValue]];

  flipValue = CATransform3DRotate(flipValue, M_PI_2, 1, 0, 0);
  flipValue = CATransform3DRotate(flipValue, M_PI_4, 0, 0, 1);
  flipValue = CATransform3DScale(flipValue, 0.5, 0.5, 1);
  [flipValues addObject:[NSValue valueWithCATransform3D:flipValue]];
  
  flipValue = roundedRectView.layer.transform;
  flipValue = CATransform3DRotate(flipValue, M_PI, 1, 0, 0);
  flipValue = CATransform3DRotate(flipValue, M_PI_2, 0, 0, 1);
  [flipValues addObject:[NSValue valueWithCATransform3D:flipValue]];

  roundedRectView.layer.transform = flipValue;
  flipAnimation.values = flipValues;
  
  CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
  animationGroup.animations = [NSArray arrayWithObjects:translateAnimation, flipAnimation, resizeAnimation, cornerRadiusRemovalAnimation, nil];
  animationGroup.duration = FLIP_DURATION;
  animationGroup.fillMode = kCAFillModeForwards;
  animationGroup.removedOnCompletion = NO;
  animationGroup.delegate = self;
  [animationGroup setValue:roundedRectView forKey:VIEW_BEING_ANIMATED];
  [animationGroup setValue:[NSNumber numberWithInt:YES] forKey:IS_ROUNDED_RECT_VIEW_FLIPPING_OUT];
  [roundedRectView.layer addAnimation:animationGroup forKey:ROUNDED_RECT_VIEW_FLIP_OUT];
}

#pragma mark - Sliding in animation

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
    [UIView animateWithDuration:SLIDE_DURATION delay:0 options:UIViewAnimationCurveEaseIn animations:^ {
      roundedRectView.alpha = 1;
      roundedRectView.frame = targetRect;
    } completion:nil];
  }

  [self flipInRoundedRectView:newMiddleRoundedRectView];
}

- (void)flipInRoundedRectView:(NTRRoundedRectView *)newMiddleRoundedRectView {
  newMiddleRoundedRectView.alpha = 0;
  self.middleRoundedRectView.alpha = 1;

  CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
  translateAnimation.fromValue = [NSValue valueWithCGPoint:self.primaryView.layer.position];
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

  CAKeyframeAnimation *flipAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
  flipAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:1], nil];
  NSMutableArray *flipValues = [NSMutableArray array];
  CATransform3D flipValue = self.middleRoundedRectView.layer.transform;
  [flipValues addObject:[NSValue valueWithCATransform3D:flipValue]];

  flipValue = CATransform3DRotate(flipValue, M_PI_2, 1, 0, 0);
  flipValue = CATransform3DRotate(flipValue, M_PI_4, 0, 0, 1);
  flipValue = CATransform3DScale(flipValue, 0.5, 0.5, 1);
  [flipValues addObject:[NSValue valueWithCATransform3D:flipValue]];

  flipValue = CATransform3DIdentity;
  [flipValues addObject:[NSValue valueWithCATransform3D:flipValue]];

  self.middleRoundedRectView.layer.transform = flipValue;
  flipAnimation.values = flipValues;

  CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
  animationGroup.animations = [NSArray arrayWithObjects:translateAnimation, resizeAnimation, flipAnimation, cornerRadiusRemovalAnimation, nil];
  animationGroup.duration = FLIP_DURATION;
  animationGroup.fillMode = kCAFillModeForwards;
  animationGroup.removedOnCompletion = NO;
  animationGroup.delegate = self;
  [animationGroup setValue:self.middleRoundedRectView forKey:VIEW_BEING_ANIMATED];
  [animationGroup setValue:[NSNumber numberWithInt:NO] forKey:IS_ROUNDED_RECT_VIEW_FLIPPING_OUT];
  [self.middleRoundedRectView.layer addAnimation:animationGroup forKey:ROUNDED_RECT_VIEW_FLIP_IN];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  NTRRoundedRectView *roundedRectView = [anim valueForKey:VIEW_BEING_ANIMATED];

  if ([[anim valueForKey:IS_ROUNDED_RECT_VIEW_FLIPPING_OUT] boolValue]) {
    if ([roundedRectView isEqual:self.middleRoundedRectView]) {
      roundedRectView.alpha = 0;
    }

    [self fadeSubviews];
    return;
  }

  [self.delegate dismissMoreInfoView:self];
}

- (void)fadeSubviews {
  self.primaryView.alpha = 1;

  [UIView animateWithDuration:FADE_DURATION animations:^ {
    self.secondaryView.alpha = 1;
    self.closeButton.alpha = 1;
    for (UIView *subview in self.primaryView.subviews)
      subview.alpha = 1;
    for (UIView *subview in self.secondaryView.subviews)
      subview.alpha = 1;
  }];
}

- (void)onCloseButton:(UIButton *)button {
  [UIView animateWithDuration:FADE_DURATION animations:^ {
    self.closeButton.alpha = 0;
    self.secondaryView.alpha = 0;
    for (UIView *subview in self.primaryView.subviews)
      subview.alpha = 0;
  } completion:^ (BOOL finished){
    if (finished) {
      self.primaryView.alpha = 0;
      self.middleRoundedRectView.alpha = 1;
      [self.delegate prepareToDismissMoreInfoView:self];
    }
  }];
}

@end
