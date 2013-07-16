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
#import "JSModel.h"
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface JSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIView *mapSuperview;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *profileButtonOutlet;

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
  [self updateProfileImage];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateMap:)
                                               name:@"Location_Updated"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateProfileImage)
                                               name:@"PROFILE_PIC_UPDATED"
                                             object:nil];
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions 

- (IBAction)categoryButtonTapped:(id)sender {
  IssuesVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IssuesVC"];
  UIButton *button = (UIButton *)sender;
  switch (button.tag) {
    case 0:
      [vc setCategory:@"Road"];
      break;
    case 1:
      [vc setCategory:@"Water"];
      break;
    case 2:
      [vc setCategory:@"Transportation"];
      break;
    case 3:
      [vc setCategory:@"Electricity"];
      break;
    case 4:
      [vc setCategory:@"Law"];
      break;
    case 5:
      [vc setCategory:@"Sewage"];
      break;
    default:
      break;
  }
  
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
    
  }
}

- (void)updateMap:(NSNotification *)notif {
  CLLocation *currentLocation = [JSModel sharedModel].currentLocation;
  
  CLLocationCoordinate2D zoomLocation;
  zoomLocation.latitude = currentLocation.coordinate.latitude;
  zoomLocation.longitude= currentLocation.coordinate.longitude;
  // 2
  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1*METERS_PER_MILE, 1*METERS_PER_MILE);
  [self.mapView setRegion:viewRegion animated:YES];
  [[JSModel sharedModel] getAddressFromLocation:[JSModel sharedModel].currentLocation completion:^(NSString *geocodedLocation) {
    [self.locationLabel setText:geocodedLocation];
  }];
}

- (void)updateProfileImage {
  NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile_image"];
  UIImage* image = [UIImage imageWithData:imageData];
  if(image!=nil) {
    [self.profileButtonOutlet setImage:image forState:UIControlStateNormal];
  } else {
    [self.profileButtonOutlet setImage:[UIImage imageNamed:@"profile_image.png"]
                              forState:UIControlStateNormal];
  }
}
@end
