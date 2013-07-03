//
//  OpenSansLight.m
//  Jansampark
//
//  Created by DevMacPro on 03/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "OpenSansLight.h"

@implementation OpenSansLight

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    [self setFont:[UIFont fontWithName:@"OpenSans-Light" size:self.font.pointSize]];
  }
  return self;
}

@end
