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
#import "Constants.h"

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
  [self fetchMLAIDWithLat:latitude lon:longitude completion:^(BOOL success, id result, NSError *error) {
    block(success, result, error);
  }];
}

- (void)fetchMLAIDWithLat:(NSString *)lat lon:(NSString *)lon completion:(JSAPIBlock)block {
  [MLA fetchMLAIdWithLat:lat
                  andLon:lon
              completion:
   ^(BOOL success, NSArray *result, NSError *error) {
     
     NSDictionary *jsonDict = [[JSModel sharedModel] jsonFromHTMLError:&error];
     NSNumber * mla_id = [jsonDict objectForKey:@"consti_id"];
     //NSNumber * drop_bit = [jsonDict objectForKey:@"ol_drop_bit"];
     
     block(YES, mla_id, nil);
     
//     if(!drop_bit.intValue && mla_id) {
//       block(YES, mla_id, nil);
//     } else {
//       block(YES, mla_id, nil);
//     }
   }];
}

- (void)fetchYoutubeVideoURLs {
  
  [[RKObjectManager sharedManager] getObjectsAtPath:@"/html/dev/micronews/get_video_links.php"
                                         parameters:nil
                                            success:
   ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    NSData *jsonData = [error.localizedRecoverySuggestion
                        dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSDictionary *videDict =
    [NSJSONSerialization JSONObjectWithData:jsonData
                                    options:NSJSONReadingMutableContainers
                                      error: &e];

    if([videDict objectForKey:@"about"]) {
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      
      [defaults setObject:[videDict objectForKey:@"about"] forKey:kOverallVideoKey];
      [defaults setObject:[videDict objectForKey:@"48"] forKey:kWaterVideoKey];
      [defaults setObject:[videDict objectForKey:@"49"] forKey:kElectricityVideoKey];
      [defaults setObject:[videDict objectForKey:@"50"] forKey:kSewageVideoKey];
      [defaults setObject:[videDict objectForKey:@"51"] forKey:kRoadVideoKey];
      [defaults setObject:[videDict objectForKey:@"52"] forKey:kTransportationVideoKey];
      [defaults setObject:[videDict objectForKey:@"53"] forKey:kLawVideoKey];
      
      [defaults synchronize];
    }
  }];
}

@end
