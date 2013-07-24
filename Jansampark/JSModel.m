//
//  JSModel.m
//  Jansampark
//
//  Created by DevMacPro on 08/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "JSModel.h"
#import "CHCSVParser.h"
#import <RestKit/RestKit.h>

#define k00Color [UIColor colorWithRed:0.91 green:0.41 blue:0.41 alpha:1]
#define k01Color [UIColor colorWithRed:0.97 green:0.72 blue:0.33 alpha:1]
#define k02Color [UIColor colorWithRed:0.38 green:0.59 blue:0.87 alpha:1]
#define k03Color [UIColor colorWithRed:0.53 green:0.42 blue:0.79 alpha:1]
#define k04Color [UIColor colorWithRed:0.55 green:0.79 blue:0.35 alpha:1]
#define k05Color [UIColor clearColor];

#define kSystemLevel0 @"Lack of infrastructure"
#define kSystemLevel1 @"Lack of maintainance"
#define kSystemLevel2 @"Lack of Quality of staff"
#define kSystemLevel3 @"Poor Pricing"
#define kSystemLevel4 @"Awareness"
#define kSystemLevel5 @"Others"

@interface JSModel()

@property (strong, nonatomic) NSTimer * timer;

@end

@implementation JSModel

static JSModel *sharedModel = nil;

+ (JSModel *)sharedModel {
  if(sharedModel == nil) {
    sharedModel = [[super allocWithZone:NULL] init];
  }
  return sharedModel;
}

- (id)init {
  self = [super init];
  if(self) {
    
    //TODO store last location of user in core data
    // SET A DEFAULT LOCATION (NEW YORK)
    CLLocation * defaultLocation = [[CLLocation alloc] initWithLatitude:12.88 longitude:77.655];
    [self setCurrentLocation:defaultLocation];
    self.address = @"Banglore";
    [self parseConstituencyData];
  }
  return self;
}

#pragma mark - CoreData Method

// deletes all objects of an entity
- (void)deleteAllObjectsForEntity:(NSString *)entity {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSManagedObjectContext *context =
  [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity
                                                       inManagedObjectContext:context];
  [fetchRequest setEntity:entityDescription];
  NSError *error;
  NSArray * items  = [context executeFetchRequest:fetchRequest error:&error];
  for (NSManagedObject *managedObject in items) {
    [context deleteObject:managedObject];
  }
  if (![context saveToPersistentStore:&error]) {
    NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
  }
}

- (NSArray *)fetchAllObjectsForEntity:(NSString *)entity {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSManagedObjectContext *context =
  [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity
                                                       inManagedObjectContext:context];
  [fetchRequest setEntity:entityDescription];
  NSError *error;
  NSArray * items  = [context executeFetchRequest:fetchRequest error:&error];
  
  return items;
}

- (NSArray *)fetchAnalyticForIssue:(NSString *)issue {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSManagedObjectContext *context =
  [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Analytic"
                                                       inManagedObjectContext:context];
  [fetchRequest setEntity:entityDescription];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"issue == %@", issue];
  [fetchRequest setPredicate:predicate];
  
  NSError *error;
  NSArray * items  = [context executeFetchRequest:fetchRequest error:&error];
  
  return items;
}

#pragma mark - Location Tracking Methods

- (void)startTrackingLocation {
  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    
  } else {
    if (!self.locationManager) {
      self.locationManager = [[CLLocationManager alloc] init];
      self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
      self.locationManager.delegate = self;
    }
    [self.locationManager startMonitoringSignificantLocationChanges];
  }
}

- (void)stopTrackingLocation {
  [self.locationManager stopMonitoringSignificantLocationChanges];
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  self.currentLocation = newLocation;
  // Reverse geocode the location to get the city
  [[NSNotificationCenter defaultCenter]
   postNotificationName:@"Location_Updated"
   object:nil
   userInfo:nil];

  [self getAddressFromLocation:newLocation completion:^(NSString *geocodedLocation) {
    self.address = geocodedLocation;
  }];
}


- (void)getAddressFromLocation:(CLLocation *)location
                 completion:(JSLocationGeocodedBlock)block {
  
  CLGeocoder *geocoder = [[CLGeocoder alloc] init];
  [geocoder reverseGeocodeLocation:location
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                   if (placemarks.count) {
                     NSString *address =
                     [self formattedLocationForPlacemark:[placemarks objectAtIndex:0]];
                     block(address);

                   }
                 }];
}

- (NSString *)formattedLocationForPlacemark:(CLPlacemark *)place {
  NSString *street = [place.addressDictionary valueForKey:@"Street"];
  NSString *city = [place.addressDictionary valueForKey:@"City"];
  NSString *state = [place.addressDictionary valueForKey:@"State"];
  
  NSString *address = @"";
  if(street) {
    address = [address stringByAppendingString:street];
    address = [address stringByAppendingString:@", "];
  }
  if(city) {
    address = [address stringByAppendingString:city];
    address = [address stringByAppendingString:@", "];
  }
  if(state) {
    address = [address stringByAppendingString:state];
  }
  return address;
}

- (UIColor *)configureColorWithSystemCode:(NSNumber *)systemCode {
  
  switch ([systemCode intValue]) {
    case 0:
      return k00Color;
      break;
    case 1:
      return k01Color;
      break;
    case 2:
      return k02Color;
      break;
    case 3:
      return k03Color;
      break;
    case 4:
      return k04Color;
      break;
    case 5:
      return k05Color;
      break;
    default:
      return [UIColor clearColor];
      break;
  }
}

- (NSString *)systemLevelWithSystemCode:(NSNumber *)systemCode {
  
  switch ([systemCode intValue]) {
    case 0:
      return kSystemLevel0;
      break;
    case 1:
      return kSystemLevel1;
      break;
    case 2:
      return kSystemLevel2;
      break;
    case 3:
      return kSystemLevel3;
      break;
    case 4:
      return kSystemLevel4;
      break;
    case 5:
      return kSystemLevel5;
      break;
    default:
      return @"Others";
      break;
  }
}

- (void)parseConstituencyData {
  NSString* path = [[NSBundle mainBundle] pathForResource:@"centroid"
                                                   ofType:@"txt"];
  self.delhiConst =
  [NSArray arrayWithContentsOfCSVFile:path
                              options:CHCSVParserOptionsStripsLeadingAndTrailingWhitespace];
}

- (BOOL)isNetworkReachable {
  if(self.reachability.reachable) {
    return YES;
  } else {
    return NO;
  }
}

- (void)runBackgroundTimer {
  self.timer = [NSTimer scheduledTimerWithTimeInterval:20
                                                target:self
                                              selector:@selector(runOperationQueue)
                                              userInfo:nil
                                               repeats:YES];
}

- (void)stopBackgroundTimer {
  [self.timer invalidate];
  self.timer =  nil;
}


- (void)runOperationQueue {
  if ([JSModel sharedModel].operationQueue.count && [[JSModel sharedModel] isNetworkReachable]) {
    RKObjectRequestOperation * queuedOperation =
    [[JSModel sharedModel].operationQueue objectAtIndex:0];
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:queuedOperation];
    [[JSModel sharedModel].operationQueue removeObjectAtIndex:0];
  }
}

- (NSDictionary *)jsonFromHTMLError:(NSError **)error {
  NSData *jsonData = [[*error localizedRecoverySuggestion] dataUsingEncoding:NSUTF8StringEncoding];
  NSError *e = nil;
  return [NSJSONSerialization JSONObjectWithData:jsonData
                                         options:NSJSONReadingMutableContainers
                                           error:&e];
}

- (NSString *)GetUUID {
  CFUUIDRef theUUID = CFUUIDCreate(NULL);
  CFStringRef string = CFUUIDCreateString(NULL, theUUID);
  CFRelease(theUUID);
  return (__bridge NSString *)string;
}
@end
