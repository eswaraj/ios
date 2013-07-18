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


+ (RKObjectRequestOperation *)postComplaintWithParams:(NSDictionary *)params
                          image:(UIImage*)img
                andProfileImage:(UIImage *)profile_img
                     completion:(JSAPICompletionBlock)block {
  
  NSMutableURLRequest *request =
  [[RKObjectManager sharedManager] multipartFormRequestWithObject:nil
                                                           method:RKRequestMethodPOST
                                                             path:@"/html/dev/micronews/?q=phonegap/post"
                                                       parameters:params
                                        constructingBodyWithBlock:
   ^(id<AFMultipartFormData> formData) {
     
     
     [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 1)
                                 name:@"img"
                             fileName:@"photo.jpg"
                             mimeType:@"image/jpeg"];
     
     
     [formData appendPartWithFileData:UIImageJPEGRepresentation(profile_img, 1)
                                 name:@"profile_img"
                             fileName:@"photo.jpg"
                             mimeType:@"image/jpeg"];
     
     
   }];
  
  NSManagedObjectContext *context =
  [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
  RKObjectRequestOperation *operation =
  [[RKObjectManager sharedManager] managedObjectRequestOperationWithRequest:request
                                                       managedObjectContext:context
                                                                    success:
   ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
     block(YES, [mappingResult array], nil);
   } failure:
   ^(RKObjectRequestOperation *operation, NSError *error) {
     block(NO, nil, error);
   }];
  return operation;
}

+ (void)fetchMLAIdWithLat:(NSString *)lat
                   andLon:(NSString *)lon
               completion:(JSAPICompletionBlock)block {
  NSString *path = [NSString stringWithFormat:@"/html/dev/micronews/getmlaid.php?lat=%@&long=%@",lat,lon];
  
  [[RKObjectManager sharedManager] postObject:nil
                                         path:path
                                   parameters:nil
                                      success:
   ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
     block(YES, [mappingResult array], nil);
   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
     block(NO, nil, error);
   }];
}
@end
