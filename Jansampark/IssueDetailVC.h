//
//  IssueDetailVC.h
//  Jansampark
//
//  Created by dev27 on 7/3/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueDetailVC : UIViewController <UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic)  NSMutableDictionary *issue;
@property (strong, nonatomic)  NSString *issueCategory;
@property (strong, nonatomic)  NSNumber *issueType;
@property (assign, nonatomic)  NSNumber *templateID;
@property (assign, nonatomic)  NSNumber *systemLevel;

@end
