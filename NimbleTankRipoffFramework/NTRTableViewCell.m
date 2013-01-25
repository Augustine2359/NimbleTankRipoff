//
//  NTRTableViewCell.m
//  NimbleTankRipoff
//
//  Created by Augustine on 14/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import "NTRTableViewCell.h"
#import "NTRTableView.h"
#import "NTRRoundedRectView.h"

@implementation NTRTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier flipOutSuperview:(id <NTRRoundedRectViewDelegate>)flipOutSuperview
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      self.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);

      CGFloat offset = 10;
      self.roundedRectView = [[NTRRoundedRectView alloc] initWithFrame:CGRectMake(offset,
                                                                                  offset,
                                                                                  CGRectGetHeight(self.contentView.frame) - 2*offset,
                                                                                  CGRectGetWidth(self.contentView.frame) - 2*offset)];
      self.roundedRectView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
      self.roundedRectView.delegate = flipOutSuperview;
      [self.contentView addSubview:self.roundedRectView];
    }

    return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect frame = self.frame;
  frame.size.width = CGRectGetHeight(self.superview.frame);
  self.frame = frame;
}

- (NSString *)word {
  return [self.roundedRectView word];
}

- (void)setWord:(NSString *)zawaado {
  [self.roundedRectView setWord:zawaado];
}

- (BOOL)containsRoundedRectView:(NTRRoundedRectView *)aRoundedRectView {
  return [self.roundedRectView isEqual:aRoundedRectView];
}

- (void)setRoundedRectSize:(CGSize)size andSpacing:(CGFloat)spacing {
  self.roundedRectView.frame = CGRectMake(spacing/2,
                                          (CGRectGetWidth(self.contentView.frame) - size.height)/2,
                                          size.width,
                                          size.height);
  self.roundedRectView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

- (void)setRoundedRectBackgroundColor:(UIColor *)backgroundColor {
  self.roundedRectView.backgroundColor = backgroundColor;
}

@end
