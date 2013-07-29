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
  [self fetchMLAIDWithCompletion:^(BOOL success, id result, NSError *error) {
    if(success) {
      [MLA fetchMLAWithId:result completion:
       ^(BOOL success, NSArray *result, NSError *error) {
         if(success) {
           block(YES, [result objectAtIndex:0], nil);
         } else {
           block(NO, nil, error);
         }
       }];
    }
  }];
}

- (void)fetchMLAIDWithCompletion:(JSAPIBlock)block {
  CLLocation *currentLocation = [JSModel sharedModel].currentLocation;
  NSString *latitude =
  [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
  NSString *longitude =
  [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
  [self fetchMLAIDWithLat:latitude lon:longitude completion:block];
}

- (void)fetchMLAIDWithLat:(NSString *)lat lon:(NSString *)lon completion:(JSAPIBlock)block {
  [MLA fetchMLAIdWithLat:lat
                  andLon:lon
              completion:
   ^(BOOL success, NSArray *result, NSError *error) {
     
     NSDictionary *jsonDict = [[JSModel sharedModel] jsonFromHTMLError:&error];
     NSNumber * mla_id = [jsonDict objectForKey:@"consti_id"];
     NSNumber * drop_bit = [jsonDict objectForKey:@"ol_drop_bit"];
     
     if(!drop_bit.intValue && mla_id) {
       block(YES, mla_id, nil);
     } else {
       block(NO, nil, error);
     }
   }];
}

@end
