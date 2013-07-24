//
//  JSModel.h
//  Jansampark
//
//  Created by DevMacPro on 08/07/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <KSReachability.h>

typedef void (^JSLocationGeocodedBlock)(NSString *geocodedLocation);

@interface JSModel : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSArray *delhiConst;

@property (nonatomic, strong) KSReachability *reachability;

@property (nonatomic, strong) NSMutableArray *operationQueue;

- (void)deleteAllObjectsForEntity:(NSString *)entity;
- (NSArray *)fetchAllObjectsForEntity:(NSString *)entity;
- (NSArray *)fetchAnalyticForIssue:(NSString *)issue;

// Location Methods
- (void)startTrackingLocation;
- (void)stopTrackingLocation;
- (void)getAddressFromLocation:(CLLocation *)location
                 completion:(JSLocationGeocodedBlock)block;

+ (JSModel *)sharedModel;

- (UIColor *)configureColorWithSystemCode:(NSNumber *)systemCode;
- (NSString *)systemLevelWithSystemCode:(NSNumber *)systemCode;

- (BOOL)isNetworkReachable;

- (void)runBackgroundTimer;
- (void)runOperationQueue;

- (NSString *)GetUUID;
- (NSDictionary *)jsonFromHTMLError:(NSError **)error;

@end
