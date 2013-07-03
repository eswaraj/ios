//
//  MyriadLabel.m
//  Jansampark
//
//  Created by dev27 on 7/1/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "MyriadLabel.h"

@implementation MyriadLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    [self setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:self.font.pointSize]];
  }
  return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
