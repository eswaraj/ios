//
//  ContainerVC.m
//  Jansampark
//
//  Created by dev27 on 6/28/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "ContainerVC.h"
#import "JSModel.h"
#import "Constants.h"

#define kAnimationArrowRatio .45
#define kAnimationDuration 0.2

typedef enum {
  kIssuesVC,
  kAnalyticsVC
} CurrentVC;

@interface ContainerVC ()
@property (weak, nonatomic) IBOutlet UIView *analyticsContainer;
@property (weak, nonatomic) IBOutlet UIView *issueContainer;

@property (weak, nonatomic) IBOutlet UIButton *issuesOutlet;
@property (weak, nonatomic) IBOutlet UIButton *analyticsOutlet;

@property (weak, nonatomic) IBOutlet UIView *tabView;
@property (weak, nonatomic) IBOutlet UIImageView *tabBarBG;

@property (assign, nonatomic) CurrentVC currentVC;
@end

@implementation ContainerVC

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
    self.currentVC = kIssuesVC;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)issuesTapped:(id)sender {
  if(self.currentVC != kIssuesVC) {
    self.currentVC = kIssuesVC;
    [self removeAllContainerViews];
    [self.view addSubview:self.issueContainer];
    [self.view bringSubviewToFront:self.tabView];
    [self deselectAllButtons];
    [self.issuesOutlet setSelected:YES];
    [UIView animateWithDuration:kAnimationDuration animations:^{
      CGRect frame = self.tabBarBG.frame;
      frame.origin.x = 0;
      [self.tabBarBG setFrame:frame];
    }];
  }
}

- (IBAction)analyticsTapped:(id)sender {
  
  if(![[JSModel sharedModel] analyticsAppeared]) {
    [[JSModel sharedModel] setAnalyticsAppeared:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:ANALYTICS_ENTRY_NOTIF
                                                        object:nil];
  }
  
  if(self.currentVC != kAnalyticsVC) {
    self.currentVC = kAnalyticsVC;
    [self removeAllContainerViews];
    [self.view addSubview:self.analyticsContainer];
    [self.view bringSubviewToFront:self.tabView];
    [self deselectAllButtons];
    [self.analyticsOutlet setSelected:YES];
    [UIView animateWithDuration:kAnimationDuration animations:^{
      CGRect frame = self.tabBarBG.frame;
      frame.origin.x = kAnimationArrowRatio*self.view.frame.size.width;
      [self.tabBarBG setFrame:frame];
    }];
  }
}

#pragma mark - Custom Methods

- (void)removeAllContainerViews {
  [self.issueContainer removeFromSuperview];
  [self.analyticsContainer removeFromSuperview];
}

-(void)deselectAllButtons {
  [self.issuesOutlet setSelected:NO];
  [self.analyticsOutlet setSelected:NO];
}

@end
