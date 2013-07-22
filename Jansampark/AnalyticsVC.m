//
//  AnalyticsVC.m
//  Jansampark
//
//  Created by DevMacPro on 03/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "AnalyticsVC.h"
#import "OpenSansBold.h"
#import "OpenSansLight.h"
#import "UICountingLabel.h"
#import "JSModel.h"
#import "LocationSearchCell.h"
#import <RestKit/RestKit.h>
#define kGreyishColor [UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1]

@interface AnalyticsVC () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *leftSegment;
@property (strong, nonatomic) IBOutlet UIButton *rightSegment;
@property (strong, nonatomic) IBOutlet OpenSansBold *locLabel;
@property (strong, nonatomic) IBOutlet OpenSansBold *leftSegmentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bigCircleBG;
@property (strong, nonatomic) IBOutlet UICountingLabel *issueCountLabel;
@property (strong, nonatomic) IBOutlet OpenSansLight *issuesLabel;
@property (strong, nonatomic) IBOutlet OpenSansLight *complaintsLabel;
@property (strong, nonatomic) IBOutlet UICountingLabel *complaintsCountLabel;
@property (strong, nonatomic) IBOutlet UIView *statisticsView;
@property (strong, nonatomic) IBOutlet UIView *searchOverlay;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) NSArray *locationSearchResults;
@property (strong, nonatomic) IBOutlet UITableView *locationTable;
@property (strong, nonatomic) IBOutlet UIImageView *locationSearcdhBackgroundImage;
@end

@implementation AnalyticsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  [self fetchDataWithID:13];
	// Do any additional setup after loading the view.
  [self.leftSegment setImage:[UIImage imageNamed:@"leftSegmentOn"]
                    forState:(UIControlStateHighlighted | UIControlStateSelected)];
  [self.rightSegment setImage:[UIImage imageNamed:@"rightSegmentOn"]
                     forState:(UIControlStateHighlighted | UIControlStateSelected)];
  if(!IS_IPHONE_5) {
    [self.bigCircleBG setFrame:CGRectMake(100, 50, 120, 120)];
    [self.issueCountLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:24]];
    [self.issuesLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:12]];
    [self.complaintsCountLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:24]];
    [self.complaintsLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:12]];
    CGRect frame = self.statisticsView.frame;
    frame.origin.y -= 34;
    [self.statisticsView setFrame:frame];
  } else {
    [self.issueCountLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:30]];
    [self.complaintsCountLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:30]];
  }
  
  UITapGestureRecognizer *tapGesture =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(dismissOverlay)];
  [self.locationSearcdhBackgroundImage addGestureRecognizer:tapGesture];
  
  UITapGestureRecognizer *tableTapGesture =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(dismissOverlay)];
  [self.locationTable addGestureRecognizer:tableTapGesture];
  
  [self.searchField setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12]];
}

- (void)viewDidAppear:(BOOL)animated  {
  [super viewDidAppear:animated];
  
  self.complaintsCountLabel.format = @"%d";
  [self.complaintsCountLabel countFrom:0 to:2345 withDuration:1.4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  
  
}

- (IBAction)leftSegmentTapped:(id)sender {
  [self.leftSegment setSelected:YES];
  [self.rightSegment setSelected:NO];
  [self.leftSegmentLabel setTextColor:[UIColor whiteColor]];
  [self.locLabel setTextColor:kGreyishColor];
}

- (IBAction)rightSegmentTapped:(id)sender {
  
  if(!self.rightSegment.isSelected) {
    [self.rightSegment setSelected:YES];
    [self.leftSegment setSelected:NO];
    [self.leftSegmentLabel setTextColor:kGreyishColor];
    [self.locLabel setTextColor:[UIColor whiteColor]];
  } else {
    [self displaySearchView];
  }
  
}

- (void)displaySearchView {
  [self.searchOverlay setHidden:NO];
  [self.searchField becomeFirstResponder];
}

- (void)dismissOverlay {
  [self.searchOverlay setHidden:YES];
  [self.searchField resignFirstResponder];
}

#pragma mark - TextField Delegates 

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
  
  NSString *newString = [textField.text stringByReplacingCharactersInRange:range
                                                                withString:string];
  
  NSPredicate *searchPredicate = [NSPredicate predicateWithBlock:
                                  ^BOOL(id evaluatedObject, NSDictionary *bindings) {
    NSArray *object = (NSArray *)evaluatedObject;
    if([self doesString:[object objectAtIndex:0] containSubstring:newString]) {
      return YES;
    } else {
      return NO;
    }
  }];
  
  self.locationSearchResults =
  [[[JSModel sharedModel] delhiConst] filteredArrayUsingPredicate:searchPredicate];
  [self.locationTable reloadData];
  
  return YES;
}

- (BOOL)doesString:(NSString *)string containSubstring:(NSString *)substring{
  if([string length] == 0 || [substring length] == 0)
    return NO;
  NSRange textRange;
  textRange = [[string lowercaseString] rangeOfString:[substring lowercaseString]];
  
  if(textRange.location != NSNotFound)
  {
    return YES;
  }else{
    return NO;
  }
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
  return self.locationSearchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LocationSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationSearchCell"];
  [cell.locationName setText:[[self.locationSearchResults objectAtIndex:indexPath.row] objectAtIndex:0]];
  
  UITapGestureRecognizer *cellapGesture =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(cellSelected:)];
  [cell addGestureRecognizer:cellapGesture];
  return cell;
}

- (void)cellSelected:(id)sender {
  int row = [self.locationTable indexPathForCell:(UITableViewCell *)[(UITapGestureRecognizer *)sender view]].row;
  NSString *constituencyName= [[self.locationSearchResults objectAtIndex:row]objectAtIndex:0];
  NSString *constituency = [[self.locationSearchResults objectAtIndex:row] objectAtIndex:1];
  int constituencyID = constituency.intValue;
  
  [self.locLabel setText:constituencyName];
  NSLog(@"const : %d", constituencyID);
  [self dismissOverlay];
  [self fetchDataWithID:constituencyID];
}


- (void)fetchDataWithID:(int)id {
  NSString *path = [NSString stringWithFormat:@"/html/dev/micronews/get_summary.php?cid=%d&time_frame=1m",id];
  
  [[RKObjectManager sharedManager] postObject:nil
                                         path:path
                                   parameters:nil
                                      success:
   ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
     
   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
     NSData *jsonData = [error.localizedRecoverySuggestion
                         dataUsingEncoding:NSUTF8StringEncoding];
     NSError *e = nil;
     NSDictionary *jsonDictionary =
     [NSJSONSerialization JSONObjectWithData:jsonData
                                     options:NSJSONReadingMutableContainers
                                       error: &e];
     
    
     [[JSModel sharedModel] setWaterAnalytics:[jsonDictionary objectForKey:@"48"]];
     [[JSModel sharedModel] setRoadAnalytics:[jsonDictionary objectForKey:@"51"]];
     [[JSModel sharedModel] setElectricityAnalytics:[jsonDictionary objectForKey:@"49"]];
     [[JSModel sharedModel] setLawAnalytics:[jsonDictionary objectForKey:@"53"]];
     [[JSModel sharedModel] setSewageAnalytics:[jsonDictionary objectForKey:@"50"]];
     [[JSModel sharedModel] setTransportationAnalytics:[jsonDictionary objectForKey:@"52"]];
     
     [self refreshAnalytics];
   }];

}

- (void)refreshAnalytics {
  
  
  NSArray *water = [[JSModel sharedModel] waterAnalytics];
  int totalWaterCount = [self totalCountInIssue:water];
  
  NSArray *sewage = [[JSModel sharedModel] sewageAnalytics];
  int totalSewageCount = [self totalCountInIssue:sewage];
  
  NSArray *electricity = [[JSModel sharedModel] electricityAnalytics];
  int totalElectricityCount = [self totalCountInIssue:electricity];
  
  NSArray *transportation = [[JSModel sharedModel] transportationAnalytics];
  int totalTransportationCount = [self totalCountInIssue:transportation];
  
  NSArray *road = [[JSModel sharedModel] roadAnalytics];
  int totalRoadCount = [self totalCountInIssue:road];
  
  NSArray *law = [[JSModel sharedModel] lawAnalytics];
  int totalLawCount = [self totalCountInIssue:law];

  
  int totalNumberOfComplaints = totalWaterCount + totalSewageCount +
                                totalElectricityCount + totalLawCount +
                                totalTransportationCount + totalRoadCount;

  
  
}

- (int)totalCountInIssue:(NSArray *)issue {
  int totalCount = 0;
  for(NSDictionary *dict in issue) {
    totalCount += [[dict objectForKey:@"counter"] intValue];
  }
  return totalCount;
}

@end
