 //
//  IssuesCell.m
//  Jansampark
//
//  Created by dev27 on 7/2/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "IssuesCell.h"
#import "JSModel.h"

@interface IssuesCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIView *leftBar;



@end

@implementation IssuesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setObject:(NSDictionary*)issue {
  NSNumber *systemCode = [issue objectForKey:@"sys_code"];
  
  UIColor *currentColor =
  [[JSModel sharedModel] configureColorWithSystemCode:systemCode];
  
  NSString *systemLevel =
  [[JSModel sharedModel] systemLevelWithSystemCode:systemCode];
  
  [self.titleLabel setText:[issue objectForKey:@"text"]];
  [self.categoryLabel setTextColor:currentColor];
  [self.leftBar setBackgroundColor:currentColor];
  [self.categoryLabel setText:systemLevel];
  
}



@end
