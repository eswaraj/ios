//
//  Analytic+JSAPIAdditions.m
//  Jansampark
//
//  Created by DevMacPro on 23/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "Analytic+JSAPIAdditions.h"

@implementation Analytic (JSAPIAdditions)

#pragma mark - Mapping Methods

+(RKEntityMapping *)restkitObjectMappingForStore:(RKManagedObjectStore *)store {
  RKEntityMapping *analyticMapping = [RKEntityMapping mappingForEntityForName:@"Analytic"
                                                    inManagedObjectStore:store];
  [analyticMapping setIdentificationAttributes:@[@"indexID"]];
  [analyticMapping addAttributeMappingsFromDictionary:
   @{@"index_id" : @"indexID",
   @"cid" : @"constituencyID",
   @"counter" : @"counter",
   @"time_frame" : @"timeFrame",
   @"template_id" : @"templateID",
   @"issue" : @"issue"
   }];
  return analyticMapping;
}

#pragma mark - API Methods

@end
