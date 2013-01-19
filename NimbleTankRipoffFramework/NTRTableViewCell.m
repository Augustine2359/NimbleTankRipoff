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

@interface NTRTableViewCell()


@end

@implementation NTRTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier flipOutSuperview:(id <NTRRoundedRectViewDelegate>)flipOutSuperview
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;

      self.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
      
      CGFloat offset = 10;
      self.roundedRectView = [[NTRRoundedRectView alloc] initWithFrame:CGRectMake(offset,
                                                                                  (CGRectGetWidth(self.contentView.bounds) - ROUNDED_RECT_SMALL_SIZE.width)/2,
                                                                                  ROUNDED_RECT_SMALL_SIZE.width,
                                                                                  ROUNDED_RECT_SMALL_SIZE.height)];
      self.roundedRectView.delegate = flipOutSuperview;
      [self.contentView addSubview:self.roundedRectView];
    }

    return self;
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

@end
