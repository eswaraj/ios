//
//  IssueDetailVC.m
//  Jansampark
//
//  Created by dev27 on 7/3/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "IssueDetailVC.h"
#import "MyriadBoldLabel.h"
#import "JSModel.h"
#import <RestKit/RestKit.h>
#import "MLA+JSAPIAdditions.h"
#import "IssueSummaryVC.h"
#import <KSReachability/KSReachability.h>
#import "JSAPIInteracter.h"

@interface IssueDetailVC ()

@property (weak, nonatomic) IBOutlet MyriadBoldLabel *categoryLabel;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *issueNameLabel;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *systemLevelLabel;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *textviewBG;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *postButton4;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *editButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *addDescriptionOutlet;

@property (weak, nonatomic) IBOutlet UIView *photoAddedView;
@property (weak, nonatomic) IBOutlet UIView *addPhotoView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UIImageView *loaderImage;
@property (strong, nonatomic) IBOutlet UIView *loaderView;

@end

@implementation IssueDetailVC

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  [self configureImagePicker];
  [self configureUI];
  [self setupLoader];
}

#pragma mark - IBActions

- (IBAction)backTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editTapped:(id)sender {
  [self.editButtonOutlet setHidden:YES];
  [self.addDescriptionOutlet setHidden:YES];
  [self.descriptionLabel setHidden:YES];
  [self.descriptionTextView setHidden:NO];
  [self.textviewBG setHidden:NO];
  [self.descriptionTextView becomeFirstResponder];
  
  if(!IS_IPHONE_5) {
    [self.scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
  }
  
}

- (IBAction)addDescriptionTapped:(id)sender {
  [self.editButtonOutlet setHidden:YES];
  [self.addDescriptionOutlet setHidden:YES];
  [self.descriptionLabel setHidden:YES];
  [self.descriptionTextView setHidden:NO];
  [self.textviewBG setHidden:NO];
  [self.descriptionTextView becomeFirstResponder];
  
  if(!IS_IPHONE_5) {
    [self.scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
  }
  
}

- (IBAction)removePhotoTapped:(id)sender {
  [self.addPhotoView setHidden:NO];
  [self.photoAddedView setHidden:YES];
  self.imageView.image = nil;
}

- (IBAction)attachPhotoTapped:(id)sender {
  self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)takePhotoTapped:(id)sender {
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
  } else {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  }
  
  [self presentViewController:self.imagePicker animated:YES completion:nil];
  
}


- (IBAction)postComplaint:(id)sender {
  //[self.activityIndicator startAnimating];
  [self.loaderView setHidden:NO];
  [self.loaderImage startAnimating];
  
  
  //checking network reachability
  
  CLLocation *currentLocation = [JSModel sharedModel].currentLocation;
  NSString *latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
  NSString *longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
  NSString *UUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                          latitude, @"lat",
                          longitude, @"long",
                          self.issueType, @"issue_type",
                          [self.issue objectForKey:@"tmpl_id"], @"issue_tmpl_id",
                          self.descriptionLabel.text, @"txt",
                          UUID, @"reporter_id",
                          [JSModel sharedModel].address, @"addr", nil];
  
  if ([[JSModel sharedModel] isNetworkReachable]) {
    [self fetchResponsibleMLAInfoWithPostParams:params];
  } else {
    [[JSModel sharedModel] showNetworkError];
  }
}



#pragma mark - Custom Methods

- (void)configureImagePicker {
  self.imagePicker = [[UIImagePickerController alloc] init];
  self.imagePicker.allowsEditing = YES;
  self.imagePicker.delegate = self;
}

- (UIImage *)getProfileImage {
  NSData* imageData =
  [[NSUserDefaults standardUserDefaults] objectForKey:@"profile_image"];
  UIImage* image = [UIImage imageWithData:imageData];
  if(image) {
    image = [self compressImage:image toSize:CGSizeMake(60, 60)];
    return image;
  } else {
    return nil;
  }
}

- (UIImage *)getIssueImage {
  UIImage *image = nil;
  if(self.imageView.image) {
    image = [self compressImage:self.imageView.image toSize:CGSizeMake(800, 800)];
  }
  return image;
}

- (UIImage *)compressImage:(UIImage *)image toSize:(CGSize)size {
  float newWidth = 0;
  float newHeight = 0;
  
  if(image.size.height > image.size.width) {
    if(image.size.height > size.height) {
      newHeight = size.height;
      newWidth = (image.size.width / image.size.height) * size.height;
    }
  } else {
    if(image.size.width > size.width) {
      newWidth = size.width;
      newHeight = (image.size.height / image.size.width) * size.width;
    }
  }
  return [self image:image ScaledToSize:CGSizeMake(newWidth, newHeight)];
}

- (UIImage*)image:(UIImage *)img ScaledToSize:(CGSize)newSize {
  UIGraphicsBeginImageContext(newSize);
  [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

- (void)setupLoader {
  [self.loaderImage setAnimationImages:[NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"runningMan1"],
                                        [UIImage imageNamed:@"runningMan2"],
                                        [UIImage imageNamed:@"runningMan3"],
                                        [UIImage imageNamed:@"runningMan4"],
                                        [UIImage imageNamed:@"runningMan5"],
                                        [UIImage imageNamed:@"runningMan6"],
                                        [UIImage imageNamed:@"runningMan7"],
                                        [UIImage imageNamed:@"runningMan8"],
                                        [UIImage imageNamed:@"runningMan9"],
                                        [UIImage imageNamed:@"runningMan10"],
                                        [UIImage imageNamed:@"runningMan11"],
                                        [UIImage imageNamed:@"runningMan12"],
                                        nil]];
  [self.loaderImage setAnimationDuration:1];
}

- (void)stopLoader {
  [self.loaderView setHidden:YES];
  [self.loaderImage stopAnimating];
}

- (RKObjectRequestOperation *)MLAOperationWithParams:(NSDictionary *)params {
  RKObjectRequestOperation *operation =
  [MLA postComplaintWithParams:params
                         image:[self getIssueImage]
               andProfileImage:[self getProfileImage]
                    completion:^(BOOL success, NSArray *result, NSError *error) {
                      
                    }];
  return operation;
}


- (void)fetchResponsibleMLAInfoWithPostParams:(NSDictionary *)params {
  [[JSAPIInteracter shared] fetchMLAInfoWithCompletion:
   ^(BOOL success, id result, NSError *error) {
     if(success) {
       
      
       
       MLA *mla = result;
       IssueSummaryVC *vc =
       [self.storyboard instantiateViewControllerWithIdentifier:@"IssueSummaryVC"];
       [vc setMla:mla];
       vc.issueCategory = self.issueCategory;
       vc.systemLevel = self.systemLevelLabel.text;
       vc.address = [JSModel sharedModel].address;
       vc.issueTitle = [self.issue objectForKey:@"text"];
       [self.loaderImage stopAnimating];
       [self.loaderView setHidden:YES];
       
       
       [self.navigationController pushViewController:vc animated:YES];
       RKObjectRequestOperation * operation = [self MLAOperationWithParams:params];
       [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];

     } else {
       [[JSModel sharedModel] showMLAInfoAlert];
     }
  }];
  
}

- (void)configureUI {
  [self.descriptionTextView setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:14]];
  
  [self.categoryLabel setText:self.issueCategory];
  [self.issueNameLabel setText:[self.issue objectForKey:@"text"]];
  
  NSNumber *sys_code = [self.issue objectForKey:@"sys_code"];
  NSString *systemLevel = [[JSModel sharedModel] systemLevelWithSystemCode:sys_code];
  [self.systemLevelLabel setText:systemLevel];
  
  if(!IS_IPHONE_5) {
    [self.postButton4 setHidden:NO];
    self.scrollView.contentSize = self.scrollView.frame.size;
    
  }
}



#pragma mark - ImagePicker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)img
                  editingInfo:(NSDictionary *)editInfo {
  self.imageView.image = img;
  [picker dismissViewControllerAnimated:YES completion:nil];
  [self.addPhotoView setHidden:YES];
  [self.photoAddedView setHidden:NO];
}

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
  
  if([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    if (textView.text.length) {
      [self.descriptionLabel setText:textView.text];
      [self.descriptionTextView setHidden:YES];
      [self.textviewBG setHidden:YES];
      [self.descriptionLabel setHidden:NO];
      [self.addDescriptionOutlet setHidden:YES];
      [self.editButtonOutlet setHidden:NO];
    } else {
      [self.descriptionLabel setText:@""];
      [self.descriptionTextView setHidden:YES];
      [self.textviewBG setHidden:YES];
      [self.descriptionLabel setHidden:YES];
      [self.addDescriptionOutlet setHidden:NO];
      [self.editButtonOutlet setHidden:YES];
    }
    if(!IS_IPHONE_5) {
      [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return NO;
  }
  
  return YES;
}

@end
