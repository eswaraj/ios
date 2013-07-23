//
//  Analytic.h
//  Jansampark
//
//  Created by DevMacPro on 23/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Analytic : NSManagedObject

@property (nonatomic, retain) NSNumber * constituencyID;
@property (nonatomic, retain) NSNumber * counter;
@property (nonatomic, retain) NSNumber * indexID;
@property (nonatomic, retain) NSNumber * templateID;
@property (nonatomic, retain) NSString * timeFrame;
@property (nonatomic, retain) NSString * issue;

@end
