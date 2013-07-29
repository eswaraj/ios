//
//  IssuesVC.m
//  Jansampark
//
//  Created by dev27 on 7/2/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "IssuesVC.h"
#import "IssueDetailVC.h"
#import "SystemLevelVC.h"

@interface IssuesVC ()
@property (weak, nonatomic) IBOutlet UILabel *issuesLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSArray * issuesArray;
@property (strong, nonatomic) NSString *issueCategory;
@property (strong, nonatomic) NSNumber *issueType;

@property (weak, nonatomic) IBOutlet UIImageView *banner;

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
  [self fetchPlist];
  [self configureUI];
}

#pragma mark - IBActions

- (IBAction)backPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Custom Methods

- (void)configureUI {
  NSString *bannerName = [NSString stringWithFormat:@"%@_banner.png",self.category];
  UIImage *bannerImage = [UIImage imageNamed:bannerName];
  [self.banner setImage:bannerImage];
  [self.issuesLabel setText:[NSString stringWithFormat:@"%d Issues",self.issuesArray.count]];
}

- (void)fetchPlist {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Category" ofType: @"plist"];
  NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
  
  NSDictionary * category = [dict objectForKey:self.category];
  self.issuesArray = [NSArray arrayWithArray:[category objectForKey:@"Issues"]];
  
  //setting issues category and tmpl_id from plist
  self.issueCategory = [category objectForKey:@"Issue_name"];
  self.issueType = [category objectForKey:@"Category_id"];
}

#pragma mark - TableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.issuesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"IssuesCell";
  
  IssuesCell *cell = (IssuesCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  [cell setObject:[self.issuesArray objectAtIndex:indexPath.row]];
  return cell;
}

#pragma mark - Tableview Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  int systemCode = [[[self.issuesArray objectAtIndex:indexPath.row] objectForKey:@"sys_code"] intValue];
  if(systemCode == 5) {
    SystemLevelVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SystemLevelVC"];
    [svc setIssue:[self.issuesArray objectAtIndex:indexPath.row]];
    [svc setIssueCategory:self.issueCategory];
    [svc setIssueType:self.issueType];
    [self.navigationController pushViewController:svc animated:YES];
  } else {
    IssueDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IssueDetailVC"];
    [vc setIssue:[self.issuesArray objectAtIndex:indexPath.row]];
    [vc setIssueCategory:self.issueCategory];
    [vc setIssueType:self.issueType];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

@end
