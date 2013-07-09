//
//  IssuesVC.m
//  Jansampark
//
//  Created by dev27 on 7/2/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "IssuesVC.h"


@interface IssuesVC ()
@property (weak, nonatomic) IBOutlet UILabel *issuesLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSArray * issuesArray;

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
  NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
  // get documents path
  NSString *documentsPath = [paths objectAtIndex:0];
  // get the path to our Data/plist file
  NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Category.plist"];
  
  // check to see if Data.plist exists in documents
  if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
  {
    // if not in documents, get property list from main bundle
    plistPath = [[NSBundle mainBundle] pathForResource:@"Category" ofType:@"plist"];
  }
  
  // read property list into memory as an NSData object
  NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
  NSString *errorDesc = nil;
  NSPropertyListFormat format;
  // convert static property liost into dictionary object
  NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
  if (!temp)
  {
    NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
  }
  // assign values
  NSDictionary * category = [temp objectForKey:self.category];
  self.issuesArray = [NSArray arrayWithArray:[category objectForKey:@"Issues"]];
  
}

#pragma mark - TableView Datasource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 54.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.issuesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"IssuesCell";
  
  IssuesCell *cell = (IssuesCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  [cell setObject:[self.issuesArray objectAtIndex:indexPath.row]];
  return cell;
}
@end
