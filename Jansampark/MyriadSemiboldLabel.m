//
//  MyriadSemiboldLabel.m
//  Jansampark
//
//  Created by DevMacPro on 03/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "MyriadSemiboldLabel.h"

@implementation MyriadSemiboldLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    [self setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:self.font.pointSize]];
  }
  return self;
}

@end
