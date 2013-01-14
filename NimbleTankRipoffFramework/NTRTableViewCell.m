//
//  NTRTableViewCell.m
//  NimbleTankRipoff
//
//  Created by Augustine on 14/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import "NTRTableViewCell.h"
#import "NTRRoundedRectView.h"

@interface NTRTableViewCell()

@property (nonatomic, strong) NTRRoundedRectView *roundedRectView;

@end

@implementation NTRTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;

      CGFloat offset = 10;

      self.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
      
      self.roundedRectView = [[NTRRoundedRectView alloc] initWithFrame:CGRectMake(offset,
                                                                                  (CGRectGetWidth(self.contentView.bounds) - ROUNDED_RECT_SMALL_SIZE.width)/2,
                                                                                  ROUNDED_RECT_SMALL_SIZE.width,
                                                                                  ROUNDED_RECT_SMALL_SIZE.height)
                                                               andWord:@"test"];
      [self.contentView addSubview:self.roundedRectView];

    }
    return self;
}

@end
