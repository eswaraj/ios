//
//  ProfileVC.m
//  Jansampark
//
//  Created by dev27 on 7/15/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "ProfileVC.h"
#import "WalkthroughVC.h"
#import "Constants.h"

@interface ProfileVC ()
@property (weak, nonatomic) IBOutlet UIView *addedPhotoView;
@property (weak, nonatomic) IBOutlet UIView *addPhotoView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (nonatomic, retain) UIImagePickerController *imagePicker;

@end

@implementation ProfileVC

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
  [self configureUI];
	self.imagePicker = [[UIImagePickerController alloc] init];
  self.imagePicker.allowsEditing = YES;
  self.imagePicker.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)crossTapped:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)removePhoto:(id)sender {
  [self.addPhotoView setHidden:NO];
  [self.addedPhotoView setHidden:YES];
  self.profileImage.image = nil;
  
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kProfileImageKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)attachPhoto:(id)sender {
  self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)takePhoto:(id)sender {
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
  } else {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  }
  
  [self presentViewController:self.imagePicker animated:YES completion:nil];
  
}


- (IBAction)howItWorksTapped:(id)sender {
  WalkthroughVC *wVC = (WalkthroughVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"WalkthroughVC"];
  [self presentViewController:wVC animated:YES completion:nil];
}

#pragma mark - Custom Methods

- (void)configureUI {
  NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:kProfileImageKey];
  UIImage* image = [UIImage imageWithData:imageData];
  if(image==nil) {
    [self.addPhotoView setHidden:NO];
    [self.addedPhotoView setHidden:YES];
    self.profileImage.image = nil;
  } else {
    [self.addPhotoView setHidden:YES];
    [self.addedPhotoView setHidden:NO];
    [self.profileImage setImage:image];
  }
}

#pragma mark - ImagePicker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)img
                  editingInfo:(NSDictionary *)editInfo {
  self.profileImage.image = img;
  [picker dismissViewControllerAnimated:YES completion:nil];
  [self.addPhotoView setHidden:YES];
  [self.addedPhotoView setHidden:NO];
  [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(img)
                                            forKey:kProfileImageKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
