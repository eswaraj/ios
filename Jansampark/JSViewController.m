//
//  JSViewController.m
//  Jansampark
//
//  Created by dev27 on 6/25/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "JSViewController.h"
#import "WalkthroughVC.h"

@interface JSViewController ()

@end

@implementation JSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  WalkthroughVC *wVC = (WalkthroughVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"WalkthroughVC"];
 // [self presentViewController:wVC animated:NO completion:nil];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
