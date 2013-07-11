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

@interface MLA (JSAPIAdditions)

+(RKEntityMapping *)restkitObjectMappingForStore:(RKManagedObjectStore *)store;

+ (void)fetchMLAWithId:(NSNumber *)mla_id
                completion:(JSAPICompletionBlock)block;

@end
