//
//  JSViewController.m
//  Jansampark
//
//  Created by dev27 on 6/25/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "JSViewController.h"
#import "WalkthroughVC.h"
#import "IssuesVC.h"

@interface JSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIView *mapSuperview;

@end

@implementation JSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
// WalkthroughVC *wVC = (WalkthroughVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"WalkthroughVC"];
//[self presentViewController:wVC animated:NO completion:nil];
  [self configureFonts];
  [self configureUI];

  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions 

- (IBAction)waterTapped:(id)sender {
  IssuesVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IssuesVC"];
  [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Custom Methods

- (void)configureFonts {
}

- (void)configureUI {
  if(!IS_IPHONE_5) {
    [self.categoryLabel setHidden:YES];
    
    CGRect mapframe = self.mapSuperview.frame;
    mapframe.size.height = mapframe.size.height - 10;
    [self.mapSuperview setFrame:mapframe];
    
//    CGRect buttonsFrame = self.buttonsView.frame;
//    buttonsFrame.origin.y = buttonsFrame.origin.y - 10;
//    [self.buttonsView  setFrame:buttonsFrame];
  }
}

@end
