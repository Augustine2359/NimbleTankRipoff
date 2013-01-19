//
//  NTRMoreInfoViewLowerHalf.m
//  NimbleTankRipoff
//
//  Created by Augustine on 16/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import "NTRMoreInfoViewLowerHalf.h"

@interface NTRMoreInfoViewLowerHalf()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *loremIpsumLabel;

@end

@implementation NTRMoreInfoViewLowerHalf

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
      self.closeButton.frame = CGRectMake(0, 0, 100, 100);
      self.closeButton.alpha = 0;
      [self addSubview:self.closeButton];
      
      self.loremIpsumLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 100)];
      self.loremIpsumLabel.text = @"Lorem Ipsum";
      self.loremIpsumLabel.alpha = 0;
      [self addSubview:self.loremIpsumLabel];
    }
    return self;
}

- (void)fadeAlphaTo:(CGFloat)alpha completion:(void (^)(BOOL))completion {
  CGFloat fadeDuration = 0.1;
  
  [UIView animateWithDuration:fadeDuration animations:^ {
    self.closeButton.alpha = alpha;
    self.loremIpsumLabel.alpha = alpha;
  } completion:^(BOOL finished) {
    completion(finished);
  }];
}

- (void)setCloseButtonTarget:(UIView *)target {
  [self.closeButton addTarget:target action:@selector(onCloseButton:) forControlEvents:UIControlEventTouchDown];
}

@end
