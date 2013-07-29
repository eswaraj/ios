//
//  AnalyticsCell.h
//  Jansampark
//
//  Created by DevMacPro on 28/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Analytic.h"

@interface AnalyticsCell : UITableViewCell {
  Analytic *_analytic;
}

- (void)setObject:(NSDictionary*)issue;

@property (strong, nonatomic) IBOutlet UILabel *complaintsLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (nonatomic, strong) Analytic *analytic;
@property (nonatomic, assign) int analyticPercentage;
@end
