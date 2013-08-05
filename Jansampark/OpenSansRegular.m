//
//  OpenSansRegular.m
//  Swaraj
//
//  Created by DevMacPro on 05/08/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "OpenSansRegular.h"

@implementation OpenSansRegular

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    [self setFont:[UIFont fontWithName:@"OpenSans-Regular" size:self.font.pointSize]];
  }
  return self;
}

@end
