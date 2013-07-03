//
//  MyriadBoldLabel.m
//  Jansampark
//
//  Created by dev27 on 7/3/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "MyriadBoldLabel.h"

@implementation MyriadBoldLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    [self setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:self.font.pointSize]];
  }
  return self;
}

@end
