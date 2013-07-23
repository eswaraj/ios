//
//  MLA+JSAPIAdditions.h
//  Jansampark
//
//  Created by dev27 on 7/11/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "MLA.h"
#import <RestKit/RestKit.h>
#import "JSAPIInterface.h"
#import "RestKitAdditions.h"

@interface MLA (JSAPIAdditions) <RestKitAdditions>

+ (void)fetchMLAIdWithLat:(NSString *)lat
                   andLon:(NSString *)lon
               completion:(JSAPICompletionBlock)block;

+ (void)fetchMLAWithId:(NSNumber *)mla_id
                completion:(JSAPICompletionBlock)block;

+ (RKObjectRequestOperation *)postComplaintWithParams:(NSDictionary *)params
                          image:(UIImage*)img
                andProfileImage:(UIImage *)profile_img
            completion:(JSAPICompletionBlock)block;

@end
