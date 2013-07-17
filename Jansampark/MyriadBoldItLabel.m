//
//  MyriadBoldItLabel.m
//  Jansampark
//
//  Created by dev27 on 7/17/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "MyriadBoldItLabel.h"

@implementation MyriadBoldItLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    [self setFont:[UIFont fontWithName:@"MyriadPro-BoldIt" size:self.font.pointSize]];
  }
  return self;
}

@end
