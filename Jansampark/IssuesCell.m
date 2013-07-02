//
//  IssuesCell.m
//  Jansampark
//
//  Created by dev27 on 7/2/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "IssuesCell.h"

@interface IssuesCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *complaintLabel;

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

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self configureFonts];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureFonts {
  [self.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
  [self.categoryLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:9]];
  [self.percentLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
  [self.complaintLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:9]];
}

@end
