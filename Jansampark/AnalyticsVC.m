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
#import "MyriadBoldLabel.h"
#import "Constants.h"
#import <RestKit/RestKit.h>
#import "Analytic+JSAPIAdditions.h"
#import "MLA+JSAPIAdditions.h"
#import "DSActivityView.h"
#import "AnalyticsDetailVC.h"
#import "JSAPIInteracter.h"

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
@property (strong, nonatomic) IBOutlet UITableView *locationTable;
@property (strong, nonatomic) IBOutlet UIImageView *locationSearcdhBackgroundImage;
@property (strong, nonatomic) IBOutlet OpenSansBold *currentCityLabel;
@property (strong, nonatomic) IBOutlet UIView *disableAnalyticsView;

@property (weak, nonatomic) IBOutlet MyriadBoldLabel *waterPercent;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *transportationPercent;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *electricityPercent;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *lawPercent;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *sewagePercent;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *roadPercent;

@property (strong, nonatomic) NSArray *locationSearchResults;
@property (assign, nonatomic) int totalNumberOfComplaints;
@property (strong, nonatomic) NSNumber *currentConstituencyID;
@property (strong, nonatomic) NSNumber *currentCityID;

@end

@implementation AnalyticsVC

#pragma mark - LifeCycle Methods

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [DSBezelActivityView newActivityViewForView:self.view];
  
  [self addNotifObserver];
  [self configureUI];
  [self configureGestures];
}

- (void)viewDidAppear:(BOOL)animated  {
  [super viewDidAppear:animated];
  self.complaintsCountLabel.format = @"%d";
  [self.complaintsCountLabel countFrom:0 to:self.totalNumberOfComplaints withDuration:0.5];
}

#pragma mark - Initial Setup Methods

- (void)addNotifObserver {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(fetchAnalytics)
                                               name:@"Location_Updated"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(fetchAnalytics)
                                               name:@"AnalyticsTapped"
                                             object:nil];
}

- (void)configureUI {
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
  
  [self.searchField setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12]];
}

- (void)configureGestures {
  UITapGestureRecognizer *tapGesture =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(dismissOverlay)];
  [self.locationSearcdhBackgroundImage addGestureRecognizer:tapGesture];
  
  UITapGestureRecognizer *tableTapGesture =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(dismissOverlay)];
  [self.locationTable addGestureRecognizer:tableTapGesture];
}

#pragma mark - IBActionMethods

- (IBAction)categoryButtonTapped:(id)sender {
  AnalyticsDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AnalyticsDetailVC"];
  UIButton *button = (UIButton *)sender;
  
  NSNumber *constID;
  if(self.leftSegment.isSelected) {
    constID = self.currentCityID;
  } else {
    constID = self.currentConstituencyID;
  }
  
  switch (button.tag) {
    case 0:
      [vc setCategory:@"Road"];
      [vc setAnalytics:[[JSModel sharedModel] fetchAnalyticForIssue:@"51"
                                                       constituency:constID]];
      break;
    case 1:
      [vc setCategory:@"Water"];
      [vc setAnalytics:[[JSModel sharedModel] fetchAnalyticForIssue:@"48"
                                                       constituency:constID]];
      break;
    case 2:
      [vc setCategory:@"Transportation"];
      [vc setAnalytics:[[JSModel sharedModel] fetchAnalyticForIssue:@"52"
                                                       constituency:constID]];
      break;
    case 3:
      [vc setCategory:@"Electricity"];
      [vc setAnalytics:[[JSModel sharedModel] fetchAnalyticForIssue:@"49"
                                                       constituency:constID]];
      break;
    case 4:
      [vc setCategory:@"Law"];
      [vc setAnalytics:[[JSModel sharedModel] fetchAnalyticForIssue:@"53"
                                                       constituency:constID]];
      break;
    case 5:
      [vc setCategory:@"Sewage"];
      [vc setAnalytics:[[JSModel sharedModel] fetchAnalyticForIssue:@"50"
                                                       constituency:constID]];
      break;
    default:
      break;
  }
  [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)leftSegmentTapped:(id)sender {
  [self.leftSegment setSelected:YES];
  [self.rightSegment setSelected:NO];
  [self.leftSegmentLabel setTextColor:[UIColor whiteColor]];
  [self.locLabel setTextColor:kGreyishColor];
  [self refreshAnalyticsForConstID:self.currentCityID];
}

- (IBAction)rightSegmentTapped:(id)sender {
  
  if(!self.rightSegment.isSelected) {
    [self.rightSegment setSelected:YES];
    [self.leftSegment setSelected:NO];
    [self.leftSegmentLabel setTextColor:kGreyishColor];
    [self.locLabel setTextColor:[UIColor whiteColor]];
    [self refreshAnalyticsForConstID:self.currentConstituencyID];
    
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
  
  NSPredicate *searchPredicate =
  [NSPredicate predicateWithBlock:
   ^BOOL(id evaluatedObject, NSDictionary *bindings) {
     NSArray *object = (NSArray *)evaluatedObject;
     if([self doesString:[object objectAtIndex:0] containSubstring:newString]) {
       return YES;
     } else {
       return NO;
     }
   }];
  
  NSArray *constArray;
  if(self.currentCityID.intValue == 999) {
    constArray = [[JSModel sharedModel] delhiConst];
  } else if(self.currentCityID.intValue == 998) {
    constArray = [[JSModel sharedModel] bangaloreConst];
  }
  self.locationSearchResults =
  [constArray filteredArrayUsingPredicate:searchPredicate];
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
  NSString *constituencyName = [[self.locationSearchResults objectAtIndex:row]objectAtIndex:0];
  NSString *constituencyLat = [[self.locationSearchResults objectAtIndex:row] objectAtIndex:2];
  NSString *constituencyLong = [[self.locationSearchResults objectAtIndex:row] objectAtIndex:3];
  
  [self.locLabel setText:constituencyName];
  [self dismissOverlay];
  
  [DSBezelActivityView newActivityViewForView:self.view];
  [[JSAPIInteracter shared] fetchMLAIDWithLat:constituencyLat
                                          lon:constituencyLong
                                   completion:
   ^(BOOL success, id result, NSError *error) {
     
     if(success) {
       self.currentConstituencyID = result;
       [self fetchDataWithID:result];
       [MLA fetchMLAWithId:result completion:
        ^(BOOL success, NSArray *result, NSError *error) {
          if(success) {
            MLA *mla = [result objectAtIndex:0];
            [self.locLabel setText:mla.constituency];
            [self enableAnalytics];
          } else {
            [self disableAnalytics];
          }
        }];
     } else {
       [self disableAnalytics];
     }
   }];
}


- (void)fetchDataWithID:(NSNumber *)constID {
  NSString *path =
  [NSString stringWithFormat:@"/html/dev/micronews/get_summary.php?cid=%d&time_frame=1w",constID.intValue];
  
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
     
     
     [[JSModel sharedModel] deleteAnalyticObjectsForCID:constID];
     
     if(jsonDictionary) {
       NSArray *waterArray = [jsonDictionary objectForKey:@"48"];
       for(NSDictionary *dict in waterArray) {
         [self performMappingForSource:dict andIssue:@"48"];
       }
       
       NSArray *roadArray = [jsonDictionary objectForKey:@"51"];
       for(NSDictionary *dict in roadArray) {
         [self performMappingForSource:dict andIssue:@"51"];
       }
       
       NSArray *electricityArray = [jsonDictionary objectForKey:@"49"];
       for(NSDictionary *dict in electricityArray) {
         [self performMappingForSource:dict andIssue:@"49"];
       }
       
       NSArray *lawArray = [jsonDictionary objectForKey:@"53"];
       for(NSDictionary *dict in lawArray) {
         [self performMappingForSource:dict andIssue:@"53"];
       }
       
       NSArray *sewageArray = [jsonDictionary objectForKey:@"50"];
       for(NSDictionary *dict in sewageArray) {
         [self performMappingForSource:dict andIssue:@"50"];
       }
       
       NSArray *transportationArray = [jsonDictionary objectForKey:@"52"];
       for(NSDictionary *dict in transportationArray) {
         [self performMappingForSource:dict andIssue:@"52"];
       }
     }
     
     if(self.leftSegment.isSelected) {
       [self refreshAnalyticsForConstID:self.currentCityID];
     } else {
       [self refreshAnalyticsForConstID:self.currentConstituencyID];
     }
   }];
}

- (void)refreshAnalyticsForConstID:(NSNumber *)constID {
  
  
  NSArray *water = [[JSModel sharedModel] fetchAnalyticForIssue:@"48" constituency:constID];
  int totalWaterCount = [self totalCountInIssue:water];
  
  NSArray *sewage = [[JSModel sharedModel] fetchAnalyticForIssue:@"50" constituency:constID];
  int totalSewageCount = [self totalCountInIssue:sewage];
  
  NSArray *electricity = [[JSModel sharedModel] fetchAnalyticForIssue:@"49" constituency:constID];
  int totalElectricityCount = [self totalCountInIssue:electricity];
  
  NSArray *transportation = [[JSModel sharedModel] fetchAnalyticForIssue:@"52" constituency:constID];
  int totalTransportationCount = [self totalCountInIssue:transportation];
  
  NSArray *road = [[JSModel sharedModel] fetchAnalyticForIssue:@"51" constituency:constID];
  int totalRoadCount = [self totalCountInIssue:road];
  
  NSArray *law = [[JSModel sharedModel] fetchAnalyticForIssue:@"53" constituency:constID];
  int totalLawCount = [self totalCountInIssue:law];
  
  
  self.totalNumberOfComplaints = totalWaterCount + totalSewageCount +
  totalElectricityCount + totalLawCount +
  totalTransportationCount + totalRoadCount;
  
  if(self.totalNumberOfComplaints) {
    self.roadPercent.text =
    [NSString stringWithFormat:@"%d%%",(int)((totalRoadCount*100)/self.totalNumberOfComplaints)];
    self.sewagePercent.text =
    [NSString stringWithFormat:@"%d%%",(int)((totalSewageCount*100)/self.totalNumberOfComplaints)];
    self.electricityPercent.text =
    [NSString stringWithFormat:@"%d%%",(int)((totalElectricityCount*100)/self.totalNumberOfComplaints)];
    self.transportationPercent.text =
    [NSString stringWithFormat:@"%d%%",(int)((totalTransportationCount*100)/self.totalNumberOfComplaints)];
    self.waterPercent.text =
    [NSString stringWithFormat:@"%d%%",(int)((totalWaterCount*100)/self.totalNumberOfComplaints)];
    self.lawPercent.text =
    [NSString stringWithFormat:@"%d%%",(int)((totalLawCount*100)/self.totalNumberOfComplaints)];
    self.complaintsCountLabel.text =
    [NSString stringWithFormat:@"%d",(int)self.totalNumberOfComplaints];
  }
  
}

- (int)totalCountInIssue:(NSArray *)issue {
  int totalCount = 0;
  for(Analytic *analytic in issue) {
    totalCount += analytic.counter.intValue;
  }
  return totalCount;
}

- (void)performMappingForSource:(NSDictionary *)source andIssue:(NSString *)issue {
  
  NSMutableDictionary *modifiedSourceDict = [[NSMutableDictionary alloc] initWithDictionary:source];
  [modifiedSourceDict setObject:issue forKey:@"issue"];
  
  RKManagedObjectStore *store = [RKObjectManager sharedManager].managedObjectStore;
  NSEntityDescription *entity =
  [NSEntityDescription entityForName:@"Analytic" inManagedObjectContext:store.persistentStoreManagedObjectContext];
  
  Analytic *analytic = [[Analytic alloc] initWithEntity:entity
                         insertIntoManagedObjectContext:store.persistentStoreManagedObjectContext];
  RKEntityMapping *analyticMapping = [Analytic restkitObjectMappingForStore:store];
  
  RKMappingOperation *operation = [[RKMappingOperation alloc] initWithSourceObject:modifiedSourceDict
                                                                 destinationObject:analytic
                                                                           mapping:analyticMapping];
  NSError *error = nil;
  [operation performMapping:&error];
  [[[[RKObjectManager sharedManager] managedObjectStore] persistentStoreManagedObjectContext] save:&error];
}

- (void)fetchAnalytics {
  
  if([[JSModel sharedModel] analyticsAppeared]) {
    [[JSModel sharedModel] getCityFromLocation:[JSModel sharedModel].currentLocation
                                    completion:
     ^(NSString *geocodedLocation) {
       if([[geocodedLocation lowercaseString] isEqualToString:@"karnataka"]) {
         geocodedLocation = @"Bangalore";
       }
       [self.currentCityLabel setText:geocodedLocation];
       if([[geocodedLocation lowercaseString] isEqualToString:@"delhi"] ||
          [[geocodedLocation lowercaseString] isEqualToString:@"new delhi"]) {
         self.currentCityID = [NSNumber numberWithInt:999];
         [self fetchDataWithID:self.currentCityID];
         [self fetchConstituencyAnalytics];
       } else if([[geocodedLocation lowercaseString] isEqualToString:@"bangalore"] ||
                 [[geocodedLocation lowercaseString] isEqualToString:@"bangalooru"]) {
         self.currentCityID = [NSNumber numberWithInt:998];
         [self fetchDataWithID:self.currentCityID];
         [self fetchConstituencyAnalytics];
       } else {
         [self disableAnalytics];
       }
     }];
  }
  
}

- (void)fetchConstituencyAnalytics {
  
  [[JSAPIInteracter shared] fetchMLAIDWithCompletion:
   ^(BOOL success, id result, NSError *error) {
     
     if(success) {
       self.currentConstituencyID = result;
       [self fetchDataWithID:result];
       [MLA fetchMLAWithId:result completion:
        ^(BOOL success, NSArray *result, NSError *error) {
          if(success) {
            MLA *mla = [result objectAtIndex:0];
            [self.locLabel setText:mla.constituency];
            [self enableAnalytics];
          } else {
            [self disableAnalytics];
          }
        }];
     } else {
       [self disableAnalytics];
     }
   }];
}

- (void)disableAnalytics {
  [self.disableAnalyticsView setHidden:NO];
  [DSBezelActivityView removeViewAnimated:YES];
}

- (void)enableAnalytics {
  [self.disableAnalyticsView setHidden:YES];
  [DSBezelActivityView removeViewAnimated:YES];
}

@end
