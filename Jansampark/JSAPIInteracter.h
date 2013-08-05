//
//  JSAPIInteracter.h
//  Jansampark
//
//  Created by DevMacPro on 27/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JSAPIBlock)(BOOL success, id result, NSError *error);

@interface JSAPIInteracter : NSObject

+ (JSAPIInteracter *)shared;

- (void)fetchMLAInfoWithCompletion:(JSAPIBlock)block;

- (void)fetchMLAIDWithCompletion:(JSAPIBlock)block;

- (void)fetchMLAIDWithLat:(NSString *)lat lon:(NSString *)lon completion:(JSAPIBlock)block;

- (void)fetchYoutubeVideoURLs;

@end
