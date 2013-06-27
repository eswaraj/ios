//
//  WalkthroughVC.m
//  Jansampark
//
//  Created by dev27 on 6/27/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "WalkthroughVC.h"

@interface WalkthroughVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end

@implementation WalkthroughVC

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
  [self configureUI];
  self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)pageControlClicked:(id)sender {
  CGRect frame = self.scrollView.bounds;
  frame.origin.x = self.pageControl.currentPage*frame.size.width;
  [self.scrollView scrollRectToVisible:frame animated:YES];
  NSLog(@"%d",self.pageControl.currentPage);
}


#pragma mark - Custom Methods

- (void)configureUI {

  self.scrollView.contentSize = CGSizeMake(3*self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
}

- (void)updatePageControl {
  // First, determine which page is currently visible
  CGFloat pageWidth = self.scrollView.frame.size.width;
  NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
  
  // Update the page control
  self.pageControl.currentPage = page;
  
}

#pragma mark - ScrollView Delegates

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [self updatePageControl];
}

@end
