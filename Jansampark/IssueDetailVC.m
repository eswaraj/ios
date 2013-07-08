//
//  IssueDetailVC.m
//  Jansampark
//
//  Created by dev27 on 7/3/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "IssueDetailVC.h"
#import "OpenSansBold.h"
#import <RestKit/RestKit.h>

@interface IssueDetailVC ()

@property (weak, nonatomic) IBOutlet OpenSansBold *categoryLabel;
@property (weak, nonatomic) IBOutlet OpenSansBold *issueNameLabel;
@property (weak, nonatomic) IBOutlet OpenSansBold *systemLevelLabel;
@property (weak, nonatomic) IBOutlet OpenSansBold *descriptionLabel;

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
  
}

#pragma mark - IBActions 

- (IBAction)backTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editTapped:(id)sender {
}

- (IBAction)addDescriptionTapped:(id)sender {
}

- (IBAction)removePhotoTapped:(id)sender {
}

- (IBAction)attachPhotoTapped:(id)sender {
  self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)takePhotoTapped:(id)sender {
  self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
  [self presentViewController:self.imagePicker animated:YES completion:nil];
  
}

- (IBAction)postComplaint:(id)sender {
  
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"45.34", @"lat",
                          @"-70.34", @"long",
                          @"water", @"issue_type",
                          [NSNumber numberWithInt:11], @"issue_tmpl_id",
                          @"pretty bad situation", @"txt",
                          @"123", @"reporter_id",
                          @"BH-234, Ashok Vihar, Delhi", @"addr", nil];
  
  [[RKObjectManager sharedManager] postObject:nil
                                         path:@"/html/dev/micronews/?q=phonegap/post"
                                   parameters:params
                                      success:
   ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    
     NSLog(@"success result : %@", mappingResult);
     
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    
    NSLog(@"failure error : %@", error);
    
  }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
  self.imageView.image = img;
  [picker dismissViewControllerAnimated:YES completion:nil];
  [self.addPhotoView setHidden:YES];
  [self.photoAddedView setHidden:NO];
}
@end
