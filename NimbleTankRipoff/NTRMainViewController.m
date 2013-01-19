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
  for (NSInteger index = 0; index < 100; index++) {
    NSString *word = [NSString stringWithFormat:@"Word %d", index];
    [self.wordsArray addObject:word];
  }

  self.ntrMainView = [[NTRMainView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) andTableViewDataSource:self];
  self.ntrMainView.delegate = self;
  [self.view addSubview:self.ntrMainView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 if ([tableView isKindOfClass:[NTRTableView class]] == NO)
   return nil;
  NTRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NTR_CELL_IDENTIFIER];
  if (cell == nil)
    cell = [[NTRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NTR_CELL_IDENTIFIER flipOutSuperview:self.ntrMainView];
            
  [cell setWord:[self.wordsArray objectAtIndex:indexPath.row]];
  
  return cell;
}

#pragma mark - Unimplemented beginning animation

- (void)viewWillAppear:(BOOL)animated {
  //  [super viewWillAppear:animated];
  //  CGSize roundedRectViewSize = ROUNDED_RECT_SMALL_SIZE;
  //
  //  CGFloat timeIntervalForWholeThing = 2;
  //
  //  for (NSInteger index = 0; index < [self.wordsArray count]; index++) {
  //    NTRRoundedRectView *roundedRectView = [[NTRRoundedRectView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), roundedRectViewSize.width, roundedRectViewSize.height) andWord:[self.wordsArray objectAtIndex:index]];
  //    roundedRectView.tag = ([self.wordsArray count] - 1) - index;
  //    roundedRectView.layer.transform = CATransform3DIdentity;
  //    [self.view addSubview:roundedRectView];
  //
  //    [self performSelector:@selector(addCurvedTranslationAnimationToRoundedRectView:) withObject:roundedRectView afterDelay:(timeIntervalForWholeThing/[self.wordsArray count]) * index];
  //  }
}

- (void)addCurvedTranslationAnimationToRoundedRectView:(NTRRoundedRectView *)roundedRectView {
  CGPoint curvedTranslationTarget = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2);
  
  CAKeyframeAnimation *curvedTranslationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  curvedTranslationAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:1], nil];
  curvedTranslationAnimation.calculationMode = kCAAnimationPaced;
  curvedTranslationAnimation.fillMode = kCAFillModeForwards;
  curvedTranslationAnimation.removedOnCompletion = NO;
  CGMutablePathRef curvedPath = CGPathCreateMutable();
  CGPathMoveToPoint(curvedPath, NULL, 0, CGRectGetHeight(self.view.bounds));
  CGPathAddQuadCurveToPoint(curvedPath, NULL, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) * 3 / 4, curvedTranslationTarget.x, curvedTranslationTarget.y);
  CGPathAddLineToPoint(curvedPath, NULL, CGRectGetWidth(self.view.bounds)/2 - (CGRectGetWidth(roundedRectView.bounds) + 10) * roundedRectView.tag, curvedTranslationTarget.y);
  curvedTranslationAnimation.path = curvedPath;
  CGPathRelease(curvedPath);
  curvedTranslationAnimation.duration = 1;
  curvedTranslationAnimation.delegate = self;
  [curvedTranslationAnimation setValue:roundedRectView forKey:VIEW_OF_LAYER_BEING_ANIMATED];
  
  roundedRectView.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2 - CGRectGetWidth(roundedRectView.bounds) * roundedRectView.tag, curvedTranslationTarget.y, CGRectGetWidth(roundedRectView.bounds), CGRectGetHeight(roundedRectView.bounds));
  
  [roundedRectView.layer addAnimation:curvedTranslationAnimation forKey:@"curvedTranslationAndLeave"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  NTRRoundedRectView *roundedRectView = [anim valueForKey:VIEW_OF_LAYER_BEING_ANIMATED];
  if (CGRectIntersectsRect(self.view.frame, roundedRectView.frame) == NO)
    [roundedRectView removeFromSuperview];
}

- (NSString *)wordForIndexPath:(NSIndexPath *)indexPath {
  return [self.wordsArray objectAtIndex:indexPath.row];
}

- (NSDictionary *)settingsForMoreInfoViewForIndexPath:(NSIndexPath *)indexPath {
  NSInteger amount = indexPath.row % 10;
  if (amount < 1)
    amount = 1;
  CGFloat floatAmount = amount * 1.0 / 10;
  BOOL shouldFlip = indexPath.row % 2;
  NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:floatAmount], LOWER_HALF_RATIO, [NSNumber numberWithBool:shouldFlip], SHOULD_FLIP_TO_LOWER_HALF, nil];
  return settings;
}

@end
