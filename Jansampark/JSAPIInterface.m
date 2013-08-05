//
//  JSAPIInterface.m
//  Jansampark
//
//  Created by DevMacPro on 08/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "JSAPIInterface.h"
#import "Constants.h"
#import "MLA+JSAPIAdditions.h"
#import "Analytic+JSAPIAdditions.h"
#import "JSModel.h"

static JSAPIInterface *__instance = nil;

@implementation JSAPIInterface

+ (JSAPIInterface *)sharedInterface {
  if (__instance == nil) {
    __instance = [[super allocWithZone:NULL] init];
  }
  return __instance;
}

- (id)init {
  self = [super init];
  if (self != nil) {
    // initialized on app lauch, sets up restkit, with all mappings and configurations
    [self setupRestkit];
    [self setupConfiguration];
    [self setupMappings];
  }
  return self;
}

- (void)setupRestkit {
  
  RKLogConfigureByName("*", RKLogLevelOff);
  // Create a new model using the coredata model file
  NSManagedObjectModel *objectModel = [[NSManagedObjectModel alloc]
                                       initWithContentsOfURL:kModelURL];
  
  // Create a new shared model using the API Base URL
  RKObjectManager *sharedManager =
  [RKObjectManager managerWithBaseURL:kJSAPIBaseURL];
  
  // create a new managed object store with the new model
  RKManagedObjectStore *managedStore = [[RKManagedObjectStore alloc]
                                        initWithManagedObjectModel:objectModel];
  
  NSError *error;
  NSString *storePath = [RKApplicationDataDirectory()
                         stringByAppendingPathComponent:kDataStoreFileName];
  // create a persistent SQLite store with a new sqlite db file
  [managedStore addSQLitePersistentStoreAtPath:storePath
                        fromSeedDatabaseAtPath:nil
                             withConfiguration:nil
                                       options:nil
                                         error:&error];
  
  if (error) {
    NSLog(@"unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  // create a managed object context for the new store
  [managedStore createManagedObjectContexts];
  
  // create a managed object cache for the new store, probably not required
  managedStore.managedObjectCache =
  [[RKInMemoryManagedObjectCache alloc]
   initWithManagedObjectContext:managedStore.mainQueueManagedObjectContext];
  
  // set the shared manager store as the new store
  sharedManager.managedObjectStore = managedStore;
  
  // Set the shared manager
  [RKObjectManager setSharedManager:sharedManager];
}

- (void)setupConfiguration {
  [[RKObjectManager sharedManager]
   setRequestSerializationMIMEType:@"application/json"];
  [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Accept"
                                                         value:RKMIMETypeJSON];
//  [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Content-Type"
//                                                         value:RKMIMETypeFormURLEncoded];
}

- (void)setupMappings {
  NSIndexSet *successSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  RKManagedObjectStore *store = [RKObjectManager sharedManager].managedObjectStore;
  
  // Set User Response descriptor
  RKEntityMapping *mlaMapping = [MLA restkitObjectMappingForStore:store];
  RKResponseDescriptor *mlaDescriptor =
  [RKResponseDescriptor responseDescriptorWithMapping:mlaMapping
                                          pathPattern:@"/html/dev/micronews/mla-info/:mlaid"
                                              keyPath:@"nodes.node"
                                          statusCodes:successSet];
  [[RKObjectManager sharedManager] addResponseDescriptor:mlaDescriptor];
}


@end
