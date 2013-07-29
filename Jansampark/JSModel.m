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
#import "Constants.h"

#define k00Color [UIColor colorWithRed:1 green:0 blue:0.1 alpha:1]
#define k01Color [UIColor colorWithRed:1 green:0.8 blue:0.2 alpha:1]
#define k02Color [UIColor colorWithRed:0.02 green:0.44 blue:0.73 alpha:1]
#define k03Color [UIColor colorWithRed:0.75 green:0.3 blue:0.31 alpha:1]
#define k04Color [UIColor colorWithRed:0.0 green:0.69 blue:0.36 alpha:1]
#define k05Color [UIColor grayColor];

#define kSystemLevel0 @"Lack of Infrastructure"
#define kSystemLevel1 @"Lack of Maintenance"
#define kSystemLevel2 @"Lack of Quality of Staff"
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
    CLLocation * defaultLocation = [[CLLocation alloc] initWithLatitude:29.0167 longitude:12.234];
    [self setCurrentLocation:defaultLocation];
    self.address = @"Delhi";
    self.analyticsAppeared = NO;
    [self parseConstituencyData];
    [self fetchCategoryDataFromPlist];
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

- (void)deleteAnalyticObjectsForCID:(NSNumber *)cid {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSManagedObjectContext *context =
  [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Analytic"
                                                       inManagedObjectContext:context];
  [fetchRequest setEntity:entityDescription];
  
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"constituencyID == %@", cid];
    [fetchRequest setPredicate:predicate];
  
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

- (NSArray *)fetchAnalyticForIssue:(NSString *)issue constituency:(NSNumber *)constID {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSManagedObjectContext *context =
  [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Analytic"
                                                       inManagedObjectContext:context];
  [fetchRequest setEntity:entityDescription];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"issue == %@ && constituencyID == %@", issue, constID];
  [fetchRequest setPredicate:predicate];
  
  NSError *error;
  NSArray * items  = [context executeFetchRequest:fetchRequest error:&error];
  
  return items;
}

- (NSArray *)fetchAnalyticForConstituency:(NSNumber *)constID {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSManagedObjectContext *context =
  [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Analytic"
                                                       inManagedObjectContext:context];
  [fetchRequest setEntity:entityDescription];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"constituencyID == %@", constID];
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
   postNotificationName:LOC_UPDATED_NOTIF
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

- (void)getCityFromLocation:(CLLocation *)location
                    completion:(JSLocationGeocodedBlock)block {
  
  CLGeocoder *geocoder = [[CLGeocoder alloc] init];
  [geocoder reverseGeocodeLocation:location
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                   if (placemarks.count) {
                     NSString *city =
                     [[[placemarks objectAtIndex:0] addressDictionary] valueForKey:@"City"];
                     
                     if(!city) {
                       city = [[[placemarks objectAtIndex:0] addressDictionary] valueForKey:@"State"];
                     }
                     block(city);
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
  NSLog(@"systemCode : %@", systemCode);
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
  NSString *delhiPath = [[NSBundle mainBundle] pathForResource:@"delhi"
                                                        ofType:@"txt"];
  self.delhiConst =
  [NSArray arrayWithContentsOfCSVFile:delhiPath
                              options:CHCSVParserOptionsStripsLeadingAndTrailingWhitespace];
  
  NSString *bangalorePath = [[NSBundle mainBundle] pathForResource:@"bangalore"
                                                            ofType:@"txt"];
  self.bangaloreConst =
  [NSArray arrayWithContentsOfCSVFile:bangalorePath
                              options:CHCSVParserOptionsStripsLeadingAndTrailingWhitespace];
}

- (BOOL)isNetworkReachable {
  if(self.reachability.reachable) {
    return YES;
  } else {
    return NO;
  }
}

- (void)fetchCategoryDataFromPlist {
  
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

- (void)showMLAInfoAlert {
  UIAlertView *alertView =
  [[UIAlertView alloc] initWithTitle:@"Oops!"
                             message:@"An error occured while fetching the MLA information"
                            delegate:nil cancelButtonTitle:@"OK"
                   otherButtonTitles: nil];
  [alertView show];
}

- (void)showNetworkError {
  UIAlertView *alert =
  [[UIAlertView alloc] initWithTitle:@"No network connection"
                             message:@"Please try again when the network is available"
                            delegate:nil
                   cancelButtonTitle:@"OK"
                   otherButtonTitles:nil];
  [alert show];
}

@end
