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

@property (nonatomic, strong) NSString *word;

@end

@implementation NTRRoundedRectView

- (id)initWithFrame:(CGRect)frame andWord:(NSString *)zawaado
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor orangeColor];

      self.layer.cornerRadius = 10;
      
      self.word = zawaado;
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
      label.textAlignment = NSTextAlignmentCenter;
      label.backgroundColor = [UIColor clearColor];
      label.text = self.word;
      [self addSubview:label];
    }
    return self;
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
