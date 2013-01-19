//
//  NTRMoreInfoViewUpperHalf.m
//  NimbleTankRipoff
//
//  Created by Augustine on 16/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import "NTRMoreInfoViewUpperHalf.h"

@interface NTRMoreInfoViewUpperHalf()

@property (nonatomic, strong) UILabel *label;

@end

@implementation NTRMoreInfoViewUpperHalf

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.label = [[UILabel alloc] init];
      self.label.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
      self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [self addSubview:self.label];
    }
    return self;
}

- (void)setText:(NSString *)text {
  self.label.text = text;
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
