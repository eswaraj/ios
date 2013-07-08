//
//  JSAPIInterface.h
//  Jansampark
//
//  Created by DevMacPro on 08/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

typedef void (^JSAPICompletionBlock)(BOOL success,
NSArray *result,
NSError *error);

@interface JSAPIInterface : NSObject

+ (JSAPIInterface *)sharedInterface;

@end
