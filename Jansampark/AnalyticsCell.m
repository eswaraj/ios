//
//  AnalyticsCell.m
//  Jansampark
//
//  Created by DevMacPro on 28/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "AnalyticsCell.h"
#import "MyriadSemiboldLabel.h"
#import "OpenSansBold.h"
#import "JSModel.h"

@interface AnalyticsCell ()

@property (strong, nonatomic) IBOutlet MyriadSemiboldLabel *titleLabel;
@property (strong, nonatomic) IBOutlet OpenSansBold *categoryLabel;
@property (strong, nonatomic) IBOutlet UIView *leftBar;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *complaintsLabel;


@end

@implementation AnalyticsCell
@synthesize analytic = _analytic;

- (void)setAnalytic:(Analytic *)analytic {
  _analytic = analytic;
  
  [self.complaintsLabel setText:[NSString stringWithFormat:@"%d Complaints", analytic.counter.intValue]];
  [self.percentageLabel setText:[NSString stringWithFormat:@"%d%%", self.analyticPercentage]];
}

- (void)setObject:(NSDictionary*)issue {
  NSNumber *systemCode = [issue objectForKey:@"sys_code"];
  
  UIColor *currentColor =
  [[JSModel sharedModel] configureColorWithSystemCode:systemCode];
  
  NSString *systemLevel =
  [[JSModel sharedModel] systemLevelWithSystemCode:systemCode];
  
  [self.titleLabel setText:[issue objectForKey:@"text"]];
  [self.categoryLabel setTextColor:currentColor];
  [self.leftBar setBackgroundColor:currentColor];
  [self.categoryLabel setText:systemLevel];
  
}
@end
