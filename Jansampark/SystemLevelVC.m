//
//  SystemLevelVC.m
//  Swaraj
//
//  Created by DevMacPro on 29/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "SystemLevelVC.h"
#import "IssueDetailVC.h"

@interface SystemLevelVC ()

@end

@implementation SystemLevelVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)infraSelected:(id)sender {
  [self showIssueDetailsWithTemplateID:0 systemLevel:0];
}

- (IBAction)maintenanceSelected:(id)sender {
  [self showIssueDetailsWithTemplateID:10 systemLevel:1];
}

- (IBAction)staffQualitySelected:(id)sender {
  [self showIssueDetailsWithTemplateID:20 systemLevel:2];
}

- (IBAction)poorPricingSelected:(id)sender {
  [self showIssueDetailsWithTemplateID:30 systemLevel:3];
}

- (IBAction)awarenessSelected:(id)sender {
  [self showIssueDetailsWithTemplateID:40 systemLevel:4];
}

- (void)showIssueDetailsWithTemplateID:(int)templateID systemLevel:(int)level{
  IssueDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IssueDetailVC"];
  [vc setIssue:self.issue];
  [vc setIssueCategory:self.issueCategory];
  [vc setIssueType:self.issueType];
  [vc setTemplateID:[NSNumber numberWithInt:templateID]];
  [vc setSystemLevel:[NSNumber numberWithInt:level]];
  [self.navigationController pushViewController:vc animated:YES];

}

@end
