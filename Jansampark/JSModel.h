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

@property (nonatomic, strong) NSArray *waterAnalytics;
@property (nonatomic, strong) NSArray *roadAnalytics;
@property (nonatomic, strong) NSArray *transportationAnalytics;
@property (nonatomic, strong) NSArray *sewageAnalytics;
@property (nonatomic, strong) NSArray *lawAnalytics;
@property (nonatomic, strong) NSArray *electricityAnalytics;
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

- (NSString *)GetUUID;
@end
