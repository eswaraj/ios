//
//  MLA.h
//  Jansampark
//
//  Created by dev27 on 7/11/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MLA : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * constituency;

@end
