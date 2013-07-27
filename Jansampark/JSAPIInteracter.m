//
//  JSAPIInteracter.m
//  Jansampark
//
//  Created by DevMacPro on 27/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "JSAPIInteracter.h"
#import "JSModel.h"
#import "MLA+JSAPIAdditions.h"

static JSAPIInteracter *shared = nil;

@implementation JSAPIInteracter

#pragma mark - Singeton Methods

+ (JSAPIInteracter *)shared {
  if(shared == nil) {
    shared = [[super allocWithZone:NULL] init];
  }
  return shared;
}

- (id)init {
  self = [super init];
  if(self) {
    
  }
  return self;
}

+ (id)allocWithZone:(NSZone *)zone {
  return [self shared];
}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}

#pragma mark - API Calls

- (void)fetchMLAInfoWithCompletion:(JSAPIBlock)block {
  CLLocation *currentLocation = [JSModel sharedModel].currentLocation;
  NSString *latitude =
  [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
  NSString *longitude =
  [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
  
  [MLA fetchMLAIdWithLat:latitude
                  andLon:longitude
              completion:
   ^(BOOL success, NSArray *result, NSError *error) {
     
     NSDictionary *jsonDict = [[JSModel sharedModel] jsonFromHTMLError:&error];
     NSNumber * mla_id = [jsonDict objectForKey:@"consti_id"];
     NSNumber * drop_bit = [jsonDict objectForKey:@"ol_drop_bit"];
     
     if(!drop_bit.intValue && mla_id) {
       [MLA fetchMLAWithId:mla_id completion:
        ^(BOOL success, NSArray *result, NSError *error) {
         if(success) {
           block(YES, [result objectAtIndex:0], nil);
         } else {
           block(NO, nil, error);
         }
       }];
     } else {
       UIAlertView *alertView =
       [[UIAlertView alloc] initWithTitle:@"Coming Soon"
                                  message:@"Sorry, we will be coming to your area soon!"
                                 delegate:nil cancelButtonTitle:@"OK"
                        otherButtonTitles: nil];
       [alertView show];
     }
     
   }];
}

@end
