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

@interface IssueDetailVC ()

@property (weak, nonatomic) IBOutlet MyriadBoldLabel *categoryLabel;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *issueNameLabel;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *systemLevelLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *textviewBG;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *descriptionLabel;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  
	// Do any additional setup after loading the view.
  self.imagePicker = [[UIImagePickerController alloc] init];
  self.imagePicker.allowsEditing = YES;
  self.imagePicker.delegate = self;
  
  [self configureUI];
  
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
  [self.loaderImage setAnimationDuration:2];
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
  if ([[JSModel sharedModel] isNetworkReachable]) {
    RKObjectRequestOperation * operation = [self operationWithFetchingMLA];
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
  } else {
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(stopLoader) userInfo:nil repeats:NO];
    RKObjectRequestOperation * operation = [self operationInBackground];
    if(![[JSModel sharedModel] operationQueue]) {
      [JSModel sharedModel].operationQueue = [[NSMutableArray alloc] init];
      
    }
    [[JSModel sharedModel].operationQueue addObject:operation];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                    message:@"Your issue will be posted automatically when network is available"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  }
  
}



#pragma mark - Custom Methods

- (void)stopLoader {
  [self.loaderView setHidden:YES];
  [self.loaderImage stopAnimating];
}

- (RKObjectRequestOperation *)operationWithFetchingMLA {
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
  
  NSMutableURLRequest *request =
  [[RKObjectManager sharedManager] multipartFormRequestWithObject:nil
                                                           method:RKRequestMethodPOST
                                                             path:@"/html/dev/micronews/?q=phonegap/post"
                                                       parameters:params
                                        constructingBodyWithBlock:
   ^(id<AFMultipartFormData> formData) {
     
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
     
   } failure:
   ^(RKObjectRequestOperation *operation, NSError *error) {
     if ([error.localizedRecoverySuggestion isEqualToString:@"\r\nsuccess"]) {
       NSLog(@"sucess is working");
     }
     NSLog(@"kdsjhfksjd - %@", error.userInfo);

     
     
     [[RKObjectManager sharedManager] postObject:nil
                                            path:@"/html/dev/micronews/getmlaid.php?lat=12.88&long=77.655"
                                      parameters:nil
                                         success:
      ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSData *jsonData = [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e = nil;
        NSDictionary *jsonArray =
        [NSJSONSerialization JSONObjectWithData:jsonData
                                        options:NSJSONReadingMutableContainers
                                          error: &e];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * mla_id = [f numberFromString:[jsonArray objectForKey:@"consti_id"]];
        [MLA fetchMLAWithId:mla_id completion:^(BOOL success, NSArray *result, NSError *error) {
          if(success) {
            MLA *mla = [result objectAtIndex:0];
            IssueSummaryVC *vc =
            [self.storyboard instantiateViewControllerWithIdentifier:@"IssueSummaryVC"];
            [vc setMla:mla];
            [self.loaderImage stopAnimating];
            [self.loaderView setHidden:YES];
            [self.navigationController pushViewController:vc animated:YES];
          } else {
            
          }
        }];
      }];
   }];
 return operation;
}

- (RKObjectRequestOperation *)operationInBackground {
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
  
  NSMutableURLRequest *request =
  [[RKObjectManager sharedManager] multipartFormRequestWithObject:nil
                                                           method:RKRequestMethodPOST
                                                             path:@"/html/dev/micronews/?q=phonegap/post"
                                                       parameters:params
                                        constructingBodyWithBlock:
   ^(id<AFMultipartFormData> formData) {
     
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
     
   } failure:
   ^(RKObjectRequestOperation *operation, NSError *error) {
     if ([error.localizedRecoverySuggestion isEqualToString:@"\nsuccess"]) {
       //[self.activityIndicator stopAnimating];
       [self.loaderImage stopAnimating];
       [self.loaderView setHidden:YES];
     }
     NSLog(@"kdsjhfksjd - %@", error.userInfo);
    
     if ([JSModel sharedModel].operationQueue.count&&[[JSModel sharedModel] isNetworkReachable]) {
       RKObjectRequestOperation * queuedOperation =
       [[JSModel sharedModel].operationQueue objectAtIndex:0];
       [[RKObjectManager sharedManager] enqueueObjectRequestOperation:queuedOperation];
       [[JSModel sharedModel].operationQueue removeObjectAtIndex:0];
     }
        }];

  return operation;
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
