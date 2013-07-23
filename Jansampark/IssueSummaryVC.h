//
//  IssueSummaryVC.h
//  Jansampark
//
//  Created by dev27 on 7/11/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLA+JSAPIAdditions.h"
#import "MyriadBoldLabel.h"
@interface IssueSummaryVC : UIViewController

@property (strong, nonatomic) MLA *mla;

@property (weak, nonatomic) IBOutlet MyriadBoldLabel *issueCategoryLabel;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *systemLevelLabel;
@property (weak, nonatomic) IBOutlet MyriadBoldLabel *addressLabel;

@property (strong, nonatomic) NSString *issueCategory;
@property (strong, nonatomic) NSString *systemLevel;
@property (strong, nonatomic) NSString *address;
@end
