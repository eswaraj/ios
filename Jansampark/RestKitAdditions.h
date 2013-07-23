
//  Created by dvg-fueled on 3/11/12.
//  Copyright (c) 2012 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/Restkit.h>

@protocol RestKitAdditions

@optional

+(RKObjectMapping *)restkitObjectMapping;
+(RKEntityMapping *)restkitObjectMappingForStore:(RKManagedObjectStore *)store;
+(RKEntityMapping *)serializationMapping;
+(RKObjectMapping *)serializationMappingForStore:(RKManagedObjectStore *)store;
-(BOOL)isValid;

@end
