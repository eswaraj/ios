//
//  IssueSummaryVC.m
//  Jansampark
//
//  Created by dev27 on 7/11/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "IssueSummaryVC.h"
#import "OpenSansBold.h"
#import "MyriadRegularLabel.h"

@interface IssueSummaryVC ()
@property (weak, nonatomic) IBOutlet OpenSansBold *mlaNameOutlet;
@property (weak, nonatomic) IBOutlet OpenSansBold *mlaConstituency;
@property (weak, nonatomic) IBOutlet UIImageView *mlaImageOutlet;
@property (weak, nonatomic) IBOutlet UIButton *doneButton4;
@property (strong, nonatomic) IBOutlet MyriadBoldLabel *issueTitleLabel;
@property (strong, nonatomic) IBOutlet MyriadRegularLabel *summaryLabel;
@end

@implementation IssueSummaryVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  [self configureUI];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if([self.mla.constituency isEqualToString:@"Rest_of_India"]) {
    
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:@"Coming Soon"
                               message:@"MLA information could not be fetched as the service is currently not available in this location. Will be coming here soon!."
                              delegate:nil cancelButtonTitle:@"OK"
                     otherButtonTitles: nil];
    [alertView show];
    
  }
  
}
#pragma mark - IBActions

- (IBAction)anotherComplaintPressed:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Custom Methods

- (void)configureUI {
  if(!IS_IPHONE_5) {
    [self.doneButton4 setHidden:NO];
  }
  
  [self.mlaNameOutlet setText:[self.mla name]];
  [self.mlaConstituency setText:[NSString stringWithFormat:@"MLA, %@",[self.mla constituency]]];
  
  NSURL *url = [NSURL URLWithString:[self.mla image]];
  NSData *data = [NSData dataWithContentsOfURL:url];
  [self.mlaImageOutlet setImage:[UIImage imageWithData:data]];

  [self.issueCategoryLabel setText:self.issueCategory];
  [self.systemLevelLabel setText:self.systemLevel];
  [self.addressLabel setText:self.address];
  [self.issueTitleLabel setText:self.issueTitle];
  
}
@end
