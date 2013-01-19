//
//  NTRTableView.h
//  NimbleTankRipoff
//
//  Created by Augustine on 14/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NTRRoundedRectView.h"

@interface NTRTableView : UITableView

- (BOOL)scrollToCellWithRoundedRectView:(NTRRoundedRectView *)roundedRectView;

@end
