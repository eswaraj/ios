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
@property (nonatomic, strong) NSArray *bangaloreConst;
@property (nonatomic, assign) BOOL analyticsAppeared;

@property (nonatomic, strong) KSReachability *reachability;

+ (JSModel *)sharedModel;

- (void)deleteAllObjectsForEntity:(NSString *)entity;
- (void)deleteAnalyticObjectsForCID:(NSNumber *)cid;
- (NSArray *)fetchAllObjectsForEntity:(NSString *)entity;
- (NSArray *)fetchAnalyticForIssue:(NSString *)issue constituency:(NSNumber *)constID;
- (NSArray *)fetchAnalyticForConstituency:(NSNumber *)constID;
// Location Methods
- (void)startTrackingLocation;
- (void)stopTrackingLocation;
- (void)getAddressFromLocation:(CLLocation *)location
                 completion:(JSLocationGeocodedBlock)block;
- (void)getCityFromLocation:(CLLocation *)location
                 completion:(JSLocationGeocodedBlock)block;


- (UIColor *)configureColorWithSystemCode:(NSNumber *)systemCode;
- (NSString *)systemLevelWithSystemCode:(NSNumber *)systemCode;

- (BOOL)isNetworkReachable;

- (NSString *)GetUUID;
- (NSDictionary *)jsonFromHTMLError:(NSError **)error;

- (void)showMLAInfoAlert;
- (void)showNetworkError;

@end
