//
//  AboutVC.m
//  Jansampark
//
//  Created by dev27 on 7/15/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AboutVC

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
  [self.scrollView setContentSize:CGSizeMake(320, 720)];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)crossTapped:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
