//
//  NTRMainViewController.m
//  NimbleTankRipoff
//
//  Created by Augustine on 14/1/13.
//  Copyright (c) 2013 Augustine. All rights reserved.
//

#import "NTRMainViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "NTREverythingHeader.h"

#define VIEW_OF_LAYER_BEING_ANIMATED @"animatingLayerOfThisView"

#define NTR_CELL_IDENTIFIER @"NTRCELL_IDENTIFIER"

@interface NTRMainViewController () <UITableViewDataSource, NTRMainViewDelegate>

@property (nonatomic, strong) NTRMainView *ntrMainView;
@property (nonatomic, strong) NTRTableView *ntrTableView;
@property (nonatomic, strong) NSMutableArray *wordsArray;

@end

@implementation NTRMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

  self.wordsArray = [NSMutableArray array];
  for (NSInteger index = 0; index < 20; index++) {
    NSString *word = [NSString stringWithFormat:@"Word %d", index];
    [self.wordsArray addObject:word];
  }

  self.ntrMainView = [[NTRMainView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) andTableViewDataSource:self];
  self.ntrMainView.delegate = self;
  [self.view addSubview:self.ntrMainView];

  self.ntrMainView.sizeOfRoundedRects = CGSizeMake(100, 200);
  self.ntrMainView.spacingBetweenRoundedRects = 10;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.ntrMainView startingAnimation];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.wordsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 if ([tableView isKindOfClass:[NTRTableView class]] == NO)
   return nil;
  NTRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NTR_CELL_IDENTIFIER];
  if (cell == nil)
    cell = [[NTRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NTR_CELL_IDENTIFIER flipOutSuperview:self.ntrMainView];

  [cell setRoundedRectSize:[self.ntrMainView sizeOfRoundedRects] andSpacing:self.ntrMainView.spacingBetweenRoundedRects];

  switch (indexPath.row % 3) {
    case 0:
      [cell setRoundedRectBackgroundColor:[UIColor redColor]];
      break;
    case 1:
      [cell setRoundedRectBackgroundColor:[UIColor greenColor]];
      break;
    case 2:
      [cell setRoundedRectBackgroundColor:[UIColor blueColor]];
    default:
      break;
  }

  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self.ntrMainView sizeOfRoundedRects].width, [self.ntrMainView sizeOfRoundedRects].height)];
  label.text = [self.wordsArray objectAtIndex:indexPath.row];
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor whiteColor];
  label.backgroundColor = [UIColor clearColor];
  [cell setButtonSubview:label];

  return cell;
}

- (NSDictionary *)settingsForMoreInfoViewForIndexPath:(NSIndexPath *)indexPath {
  NSInteger amount = indexPath.row % 10;
  if (amount < 1)
    amount = 1;
  CGFloat floatAmount = amount * 1.0 / 10;

  UIView *secondaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
  secondaryView.backgroundColor = [UIColor blueColor];

  UIView *primaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
  primaryView.backgroundColor = [UIColor redColor];

  enum PrimaryViewOnWhichSide primaryViewOnWhichSide = indexPath.row%4;

  NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:floatAmount], PRIMARY_VIEW_RATIO,
                            [NSNumber numberWithInt:primaryViewOnWhichSide], PRIMARY_VIEW_ON_WHICH_SIDE,
                            secondaryView, SECONDARY_VIEW,
                            primaryView, PRIMARY_VIEW,
                            nil];
  return settings;
}

@end
