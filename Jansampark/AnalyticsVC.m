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

#define kGreyishColor [UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1]

@interface AnalyticsVC ()

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
  [self.searchOverlay addGestureRecognizer:tapGesture];
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

@end
