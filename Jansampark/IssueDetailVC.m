//
//  IssueDetailVC.m
//  Jansampark
//
//  Created by dev27 on 7/3/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "IssueDetailVC.h"

@interface IssueDetailVC ()

@end

@implementation IssueDetailVC

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

#pragma mark - IBActions 

- (IBAction)backTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
