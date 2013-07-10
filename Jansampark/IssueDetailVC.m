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

@interface IssueDetailVC ()

@property (weak, nonatomic) IBOutlet MyriadBoldLabel *categoryLabel;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *issueNameLabel;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *systemLevelLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *editButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *addDescriptionOutlet;

@property (weak, nonatomic) IBOutlet UIView *photoAddedView;
@property (weak, nonatomic) IBOutlet UIView *addPhotoView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) UIImagePickerController *imagePicker;

@end

@implementation IssueDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  self.imagePicker = [[UIImagePickerController alloc] init];
  self.imagePicker.allowsEditing = YES;
  self.imagePicker.delegate = self;
  
  [self configureUI];
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
  [self.descriptionTextView becomeFirstResponder];
}

- (IBAction)addDescriptionTapped:(id)sender {
  [self.editButtonOutlet setHidden:YES];
  [self.addDescriptionOutlet setHidden:YES];
  [self.descriptionLabel setHidden:YES];
  [self.descriptionTextView setHidden:NO];
  [self.descriptionTextView becomeFirstResponder];
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
  [self.activityIndicator startAnimating];
  
  CLLocation *currentLocation = [JSModel sharedModel].currentLocation;
  NSString *latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
  NSString *longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                          latitude, @"lat",
                          longitude, @"long",
                          self.issueType, @"issue_type",
                          [self.issue objectForKey:@"tmpl_id"], @"issue_tmpl_id",
                          self.descriptionLabel.text, @"txt",
                          @"123", @"reporter_id",
                          [JSModel sharedModel].address, @"addr", nil];
  
  UIImage *image = self.imageView.image;
  
  NSMutableURLRequest *request = [[RKObjectManager sharedManager] multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:@"/html/dev/micronews/?q=phonegap/post" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1)
                                name:@"img"
                            fileName:@"photo.jpg"
                            mimeType:@"image/jpeg"];
    
    
    [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1)
                                name:@"profile_img"
                            fileName:@"photo.jpg"
                            mimeType:@"image/jpeg"];
    
  }];
  
  NSManagedObjectContext *context =
  [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
  RKObjectRequestOperation *operation =
  [[RKObjectManager sharedManager] managedObjectRequestOperationWithRequest:request
                                                       managedObjectContext:context
                                                                    success:
   ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
     
   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
     if ([error.localizedRecoverySuggestion isEqualToString:@"\nsuccess"]) {
       [self.activityIndicator stopAnimating];
     }
     NSLog(@"kdsjhfksjd - \n%@", error.localizedRecoverySuggestion);
     
   }];
  [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
  
//  [[RKObjectManager sharedManager] postObject:nil
//                                         path:@"/html/dev/micronews/?q=phonegap/post"
//                                   parameters:params
//                                      success:
//   ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//    
//     NSLog(@"success result : %@", mappingResult);
//     
//  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//    
//    NSLog(@"failure error : %@", error);
//    
//  }];
}

#pragma mark - Custom Methods

- (void)configureUI {
  [self.descriptionTextView setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:14]];
  
  [self.categoryLabel setText:self.issueCategory];
  [self.issueNameLabel setText:[self.issue objectForKey:@"text"]];
  
  NSNumber *sys_code = [self.issue objectForKey:@"sys_code"];
  NSString *systemLevel = [[JSModel sharedModel] systemLevelWithSystemCode:sys_code];
  [self.systemLevelLabel setText:systemLevel];
}

#pragma mark - ImagePicker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
  self.imageView.image = img;
  [picker dismissViewControllerAnimated:YES completion:nil];
  [self.addPhotoView setHidden:YES];
  [self.photoAddedView setHidden:NO];
}

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  
  if([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    if (textView.text.length) {
      [self.descriptionLabel setText:textView.text];
      [self.descriptionTextView setHidden:YES];
      [self.descriptionLabel setHidden:NO];
      [self.addDescriptionOutlet setHidden:YES];
      [self.editButtonOutlet setHidden:NO];
    } else {
      [self.descriptionLabel setText:@""];
      [self.descriptionTextView setHidden:YES];
      [self.descriptionLabel setHidden:YES];
      [self.addDescriptionOutlet setHidden:NO];
      [self.editButtonOutlet setHidden:YES];
    }
    
    return NO;
  }
  
  return YES;
}

@end
