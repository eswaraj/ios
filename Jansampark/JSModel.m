//
//  JSModel.m
//  Jansampark
//
//  Created by DevMacPro on 08/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "JSModel.h"

#define k00Color [UIColor colorWithRed:1 green:0.43 blue:0.34 alpha:1]
#define k01Color [UIColor colorWithRed:1 green:0.8 blue:0.2 alpha:1]
#define k02Color [UIColor colorWithRed:0.16 green:0.85 blue:1 alpha:1]

#define kSystemLevel0 @"Lack of infrastructure"
#define kSystemLevel1 @"Lack of maintainance"
#define kSystemLevel2 @"Lack of Quality of staff"
#define kSystemLevel3 @"Poor Pricing"
#define kSystemLevel4 @"Awareness"
#define kSystemLevel5 @"Others"

@implementation JSModel

static JSModel *sharedModel = nil;

+ (JSModel *)sharedModel {
  if(sharedModel == nil) {
    sharedModel = [[super allocWithZone:NULL] init];
  }
  return sharedModel;
}

- (UIColor *)configureColorWithSystemCode:(NSNumber *)systemCode {
  
  switch ([systemCode intValue]) {
    case 0:
      return k00Color;
      break;
    case 1:
      return k01Color;
      break;
    case 2:
      return k02Color;
      break;
      
    default:
      return [UIColor blackColor];
      break;
  }
}

- (NSString *)systemLevelWithSystemCode:(NSNumber *)systemCode {
  
  switch ([systemCode intValue]) {
    case 0:
      return kSystemLevel0;
      break;
    case 1:
      return kSystemLevel1;
      break;
    case 2:
      return kSystemLevel2;
      break;
    case 3:
      return kSystemLevel3;
      break;
    case 4:
      return kSystemLevel4;
      break;
    case 5:
      return kSystemLevel5;
      break;
    default:
      return @"Others";
      break;
  }
}
@end
