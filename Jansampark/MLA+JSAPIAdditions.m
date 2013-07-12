//
//  MLA+JSAPIAdditions.m
//  Jansampark
//
//  Created by dev27 on 7/11/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "MLA+JSAPIAdditions.h"

@implementation MLA (JSAPIAdditions)

+(RKEntityMapping *)restkitObjectMappingForStore:(RKManagedObjectStore *)store {
  RKEntityMapping *tagMapping = [RKEntityMapping mappingForEntityForName:@"MLA"
                                                    inManagedObjectStore:store];
  [tagMapping setIdentificationAttributes:@[@"name"]];
  [tagMapping addAttributeMappingsFromDictionary:
   @{@"mla_name" : @"name",
   @"image" : @"image",
   @"constituency" : @"constituency",
   }];
  return tagMapping;
}


+ (void)fetchMLAWithId:(NSNumber *)mla_id
            completion:(JSAPICompletionBlock)block {

  NSString *path = [NSString stringWithFormat:@"/html/dev/micronews/mla-info/%@",mla_id];
  [[RKObjectManager sharedManager] postObject:nil path:path parameters:nil success:
   ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    block(YES, [mappingResult array], nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    block(NO, nil, error);
  }];
  }


@end
