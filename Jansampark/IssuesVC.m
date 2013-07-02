//
//  IssuesVC.m
//  Jansampark
//
//  Created by dev27 on 7/2/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "IssuesVC.h"

@interface IssuesVC ()

@end

@implementation IssuesVC

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

- (IBAction)backPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Datasource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 54.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"IssuesCell";
  
  IssuesCell *cell = (IssuesCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  return cell;
}
@end
