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

@property (nonatomic, strong) NTRMoreInfoViewUpperHalf *upperHalf;
@property (nonatomic, strong) NTRMoreInfoViewLowerHalf *lowerHalf;
@property (nonatomic, strong) NTRRoundedRectView *middleRoundedRectView;

@end

@implementation NTRMoreInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.upperHalf = [[NTRMoreInfoViewUpperHalf alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)/2)];
      self.upperHalf.backgroundColor = [UIColor whiteColor];
      self.upperHalf.alpha = 0;
      [self addSubview:self.upperHalf];
      self.lowerHalf = [[NTRMoreInfoViewLowerHalf alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)/2, CGRectGetWidth(frame), CGRectGetHeight(frame)/2)];
      self.lowerHalf.alpha = 0;
      [self addSubview:self.lowerHalf];
    }
    return self;
}

- (void)slideOutExtraRoundedRectViews {
  for (NTRRoundedRectView *roundedRectView in self.subviews) {
    if ([roundedRectView isKindOfClass:[NTRRoundedRectView class]] == NO)
      continue;
    if (CGRectContainsPoint(roundedRectView.frame, self.center)) {
      self.middleRoundedRectView = roundedRectView;
      continue;
    }
    CGRect targetRect;
    if (CGRectGetMinX(roundedRectView.frame) < self.center.x)
      targetRect = CGRectOffset(roundedRectView.frame, -CGRectGetWidth(self.frame), 0);
    else
      targetRect = CGRectOffset(roundedRectView.frame, CGRectGetWidth(self.frame), 0);
    [UIView animateWithDuration:5 animations:^ {
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
//  [roundedRectView flipOutToView:self.lowerHalf];
  
  self.lowerHalf.backgroundColor = roundedRectView.backgroundColor;
  
  CGFloat animationDuration = 2;

  CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
  translateAnimation.fromValue = [NSValue valueWithCGPoint:roundedRectView.layer.position];
  translateAnimation.toValue = [NSValue valueWithCGPoint:self.lowerHalf.layer.position];
  roundedRectView.layer.position = self.lowerHalf.layer.position;
  
  CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
  resizeAnimation.fromValue = [NSValue valueWithCGRect:roundedRectView.layer.bounds];
  CGRect newBounds = self.lowerHalf.layer.bounds;
  CGFloat width = newBounds.size.width;
  newBounds.size.width = newBounds.size.height;
  newBounds.size.height = width;
  resizeAnimation.toValue = [NSValue valueWithCGRect:newBounds];
  DLog(@"%@ %@", NSStringFromCGRect(self.lowerHalf.layer.bounds), NSStringFromCGRect(self.lowerHalf.layer.frame));
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
    
    self.lowerHalf.alpha = 1;
    [self.lowerHalf fadeAlphaTo:1 completion:^(BOOL success) {
      if (success) {
        [self.lowerHalf setCloseButtonTarget:self];
      }
    }];
    return;
  }
  
  [roundedRectView removeFromSuperview];
  [self.delegate dismissMoreInfoView:self];
}

- (void)onCloseButton:(UIButton *)button {
  [self.delegate prepareToDismissMoreInfoView:self];
  self.upperHalf.hidden = YES;
  self.lowerHalf.hidden = YES;
//  [self flipInRoundedRectView];
}

- (void)slideInExtraRoundedRectViews {
  CGRect targetRect;

  NTRRoundedRectView *newMiddleRoundedRectView;
  
  for (NTRRoundedRectView *roundedRectView in self.subviews) {
    if ([roundedRectView isKindOfClass:[NTRRoundedRectView class]] == NO)
      continue;
    if (CGRectContainsPoint(roundedRectView.frame, self.center)) {
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
    [UIView animateWithDuration:1 animations:^ {
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
  DLog(@"%@", NSStringFromCGPoint(self.middleRoundedRectView.layer.position));
  translateAnimation.fromValue = [NSValue valueWithCGPoint:self.middleRoundedRectView.layer.position];
  translateAnimation.toValue = [NSValue valueWithCGPoint:newMiddleRoundedRectView.layer.position];
  DLog(@"%@", NSStringFromCGPoint(newMiddleRoundedRectView.layer.position));
  
  CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
  resizeAnimation.fromValue = [NSValue valueWithCGRect:self.middleRoundedRectView.layer.bounds];
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
