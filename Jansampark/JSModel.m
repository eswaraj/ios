//
//  JSModel.m
//  Jansampark
//
//  Created by DevMacPro on 08/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "JSModel.h"

@implementation JSModel

static JSModel *sharedModel = nil;

+ (JSModel *)sharedModel {
  if(sharedModel == nil) {
    sharedModel = [[super allocWithZone:NULL] init];
  }
  return sharedModel;
}

@end
