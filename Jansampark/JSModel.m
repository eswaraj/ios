//
//  JSModel.m
//  Jansampark
//
//  Created by DevMacPro on 08/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "JSModel.h"

#define k00Color [UIColor colorWithRed:0.91 green:0.41 blue:0.41 alpha:1]
#define k01Color [UIColor colorWithRed:0.97 green:0.72 blue:0.33 alpha:1]
#define k02Color [UIColor colorWithRed:0.38 green:0.59 blue:0.87 alpha:1]
#define k03Color [UIColor colorWithRed:0.53 green:0.42 blue:0.79 alpha:1]
#define k04Color [UIColor colorWithRed:0.55 green:0.79 blue:0.35 alpha:1]
#define k05Color [UIColor clearColor];

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
    case 3:
      return k03Color;
      break;
    case 4:
      return k04Color;
      break;
    case 5:
      return k05Color;
      break;
    default:
      return [UIColor clearColor];
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
