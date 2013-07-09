//
//  Constants.h
//  Jansampark
//
//  Created by DevMacPro on 08/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import <Foundation/Foundation.h>

// Matchbook API & Model
#define kModelURL [[NSBundle mainBundle] URLForResource:@"Jansampark" withExtension:@"momd"]
#define kJSAPIBaseURL [NSURL URLWithString:@"http://50.57.224.47"]
#define kDataStoreFileName @"JS.sqlite"


@interface Constants : NSObject

@end