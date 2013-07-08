 //
//  IssuesCell.m
//  Jansampark
//
//  Created by dev27 on 7/2/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "IssuesCell.h"

#define k00Color [UIColor colorWithRed:1 green:0.43 blue:0.34 alpha:1]
#define k01Color [UIColor colorWithRed:1 green:0.8 blue:0.2 alpha:1]
#define k02Color [UIColor colorWithRed:0.16 green:0.85 blue:1 alpha:1]


@interface IssuesCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIView *leftBar;
@property (strong, nonatomic) UIColor *currentColor;


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
  NSString *systemCode = [issue objectForKey:@"sys_code"];
  
  [self configureColorWithSystemCode:systemCode];
  
  
  [self.titleLabel setText:[issue objectForKey:@"text"]];
  [self.categoryLabel setTextColor:self.currentColor];
  [self.leftBar setBackgroundColor:self.currentColor];
  
}

- (void)configureColorWithSystemCode:(NSString *)systemCode {
  
  if ([systemCode isEqualToString:@"00"]) {
    self.currentColor = k00Color;
  } else if ([systemCode isEqualToString:@"01"]) {
    self.currentColor = k01Color;
  } else if ([systemCode isEqualToString:@"02"]) {
    self.currentColor = k02Color;
  } else {
    self.currentColor = [UIColor blackColor];
  }
  
}

@end
