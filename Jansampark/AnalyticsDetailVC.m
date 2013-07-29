//
//  AnalyticsDetailVC.m
//  Jansampark
//
//  Created by DevMacPro on 28/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "AnalyticsDetailVC.h"
#import "OpenSansBold.h"
#import "AnalyticsCell.h"

@interface AnalyticsDetailVC ()

@property (strong, nonatomic) IBOutlet UIImageView *banner;
@property (strong, nonatomic) IBOutlet OpenSansBold *issuesLabel;
@property (strong, nonatomic) IBOutlet OpenSansBold *complaintsLabel;

@property (strong, nonatomic) NSArray *issuesArray;
@property (strong, nonatomic) NSString *issueCategory;
@property (strong, nonatomic) NSNumber *issueType;

@property (nonatomic, assign) int totalComplaints;
@end

@implementation AnalyticsDetailVC

#pragma marjk - LifeCycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  [self configureDefaultValues];
}

- (IBAction)goBack:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - CustomMethods

- (void)configureDefaultValues {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Category" ofType: @"plist"];
  NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
  
  NSDictionary * category = [dict objectForKey:self.category];
  self.issuesArray = [NSArray arrayWithArray:[category objectForKey:@"Issues"]];
  
  //setting issues category and tmpl_id from plist
  self.issueCategory = [category objectForKey:@"Issue_name"];
  self.issueType = [category objectForKey:@"Category_id"];
  
  NSString *bannerName = [NSString stringWithFormat:@"%@_banner.png",self.category];
  UIImage *bannerImage = [UIImage imageNamed:bannerName];
  [self.banner setImage:bannerImage];
  [self.issuesLabel setText:[NSString stringWithFormat:@"%d Issues",self.issuesArray.count]];
  
  int counter = 0;
  for(Analytic *analytic in self.analytics) {
    counter += analytic.counter.intValue;
  }
  self.totalComplaints = counter;
  [self.complaintsLabel setText:[NSString stringWithFormat:@"%d Complaints",counter]];
}

#pragma mark - TableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.issuesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"AnalyticsCell";
  AnalyticsCell *cell =
  (AnalyticsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  int templateID = [[[self.issuesArray objectAtIndex:indexPath.row] objectForKey:@"tmpl_id"] intValue];
  
  Analytic *cellAnalytic;
  for(Analytic *analytic in self.analytics) {
    if(analytic.templateID.intValue == templateID) {
      cellAnalytic = analytic;
      break;
    }
  }
  
  int percentage = 0;
  if(self.totalComplaints) {
    percentage = (int)((cellAnalytic.counter.intValue * 100) / self.totalComplaints);
  }
  
  if(indexPath.row == (self.issuesArray.count - 1)) {
    
    int otherSum = 0;
    for(int i = indexPath.row; i < (indexPath.row + 5); i++) {
      Analytic *analytic = [self.analytics objectAtIndex:i];
      otherSum += analytic.counter.intValue;
    }
    percentage = (int)((otherSum * 100) / self.totalComplaints);
    [cell.complaintsLabel setText:[NSString stringWithFormat:@"%d Complaints", otherSum]];
    [cell.percentageLabel setText:[NSString stringWithFormat:@"%d%%", percentage]];
  } else {
    [cell setAnalyticPercentage:percentage];
    [cell setAnalytic:cellAnalytic];
  }
  
  
  [cell setObject:[self.issuesArray objectAtIndex:indexPath.row]];
  
  return cell;
}

@end
