//
//  NTRRoundedRect.m
//  NimbleTankRipoff
//
//  Created by Augustine on 14/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import "NTRRoundedRectView.h"
#import <QuartzCore/QuartzCore.h>

@interface NTRRoundedRectView()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) CATransformLayer *transformLayer;

@end

@implementation NTRRoundedRectView

- (id)initWithFrame:(CGRect)frame { 
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor orangeColor];
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    
//    CGRect backgroundViewFrame = frame;
//    backgroundViewFrame.origin = CGPointZero;
//    self.backgroundView = [[UIView alloc] initWithFrame:backgroundViewFrame];
//    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.backgroundView.backgroundColor = [UIColor orangeColor];
//    self.backgroundView.layer.cornerRadius = 10;
//    self.backgroundView.layer.position = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
//    [self addSubview:self.backgroundView];

    self.moreInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreInfoButton.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    self.moreInfoButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.moreInfoButton.backgroundColor = [UIColor clearColor];
    [self.moreInfoButton addTarget:self action:@selector(onMoreInfoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreInfoButton];

//    self.transformLayer = [CATransformLayer layer];
//    self.transformLayer.position = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
//    self.transformLayer.bounds = backgroundViewFrame;
//    [self.transformLayer addSublayer:self.backgroundView.layer];
//    [self.transformLayer addSublayer:self.wordButton.layer];
//    [self.layer addSublayer:self.transformLayer];
  }
  
  return self;
}

- (NSString *)word {
  return [self.moreInfoButton titleForState:UIControlStateNormal];
}

- (void)setWord:(NSString *)zawaado {
  [self.moreInfoButton setTitle:zawaado forState:UIControlStateNormal];
}

- (void)onMoreInfoButtonPressed:(UIButton *)button {
  if ([self.delegate respondsToSelector:@selector(selectRoundedRectToFlipOut:)]) {
    [self.delegate selectRoundedRectToFlipOut:self];
  }
}

//- (void)flipOutToView:(UIView *)view {
////  self.transformLayer.bounds = self.layer.bounds;
//  CGFloat animationDuration = 2;
//
////  for (CALayer *transformLayerSublayer in self.transformLayer.sublayers) {
////    CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
////    resizeAnimation.fromValue = [NSValue valueWithCGRect:transformLayerSublayer.bounds];
////    CGRect newBounds = view.layer.bounds;
//////    resizeAnimation.duration = animationDuration;
////    resizeAnimation.toValue = [NSValue valueWithCGRect:newBounds];
////
////    CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
////    translateAnimation.fromValue = [NSValue valueWithCGPoint:transformLayerSublayer.position];
////    translateAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(newBounds)/2, CGRectGetHeight(newBounds)/2)];
////
////    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
////    //  animationGroup.animations = [NSArray arrayWithObjects:translateAnimation, flipAnimation, resizeAnimation, cornerRadiusRemovalAnimation, nil];
////    animationGroup.animations = [NSArray arrayWithObjects:resizeAnimation, nil];
////    animationGroup.duration = animationDuration;
////    animationGroup.fillMode = kCAFillModeForwards;
////    animationGroup.removedOnCompletion = NO;
//////    [transformLayerSublayer addAnimation:animationGroup forKey:@"now"];
////  }
//  
//  CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//  translateAnimation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
//  translateAnimation.toValue = [NSValue valueWithCGPoint:view.layer.position];
//  translateAnimation.duration = animationDuration;
//
//  CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
//  resizeAnimation.fromValue = [NSValue valueWithCGRect:self.layer.bounds];
//  CGRect newBounds = view.layer.bounds;
//  resizeAnimation.duration = animationDuration;
//  resizeAnimation.toValue = [NSValue valueWithCGRect:newBounds];
//
////  CABasicAnimation *cornerRadiusRemovalAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
////  cornerRadiusRemovalAnimation.fromValue = [NSNumber numberWithFloat:view.layer.cornerRadius];
////  cornerRadiusRemovalAnimation.toValue = [NSNumber numberWithFloat:0];
////
//  CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform"];
//  flipAnimation.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
//  CATransform3D flipTransform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
//  flipTransform = CATransform3DRotate(flipTransform, M_PI_2, 0, 0, 1);
//  flipAnimation.toValue = [NSValue valueWithCATransform3D:flipTransform];
//
//  CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
//  animationGroup.animations = [NSArray arrayWithObjects:translateAnimation, resizeAnimation, flipAnimation, nil];
//  animationGroup.duration = animationDuration;
//  animationGroup.fillMode = kCAFillModeForwards;
//  animationGroup.removedOnCompletion = NO;
//  [self.layer addAnimation:animationGroup forKey:@"now"];
//}

- (void)fadeMoreInfoButton:(CGFloat)alpha {
  self.moreInfoButton.alpha = alpha;
}

//- (void)hideWordButtonInTime:(CGFloat)time {
//  [UIView animateWithDuration:time animations:^ {
//    self.wordButton.alpha = 0;
//  }];
//  CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//  fadeAnimation.fromValue = [NSNumber numberWithFloat:self.wordButton.layer.opacity];
//  fadeAnimation.toValue = [NSNumber numberWithFloat:0];
//  fadeAnimation.duration = time;
//  [self.wordButton.layer addAnimation:fadeAnimation forKey:@"now"];
//}

@end
