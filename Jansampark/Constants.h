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

#define kTotalComplaints @"TotalComplaints"
#define kWaterComplaints @"WaterComplaints"
#define kRoadComplaints @"RoadComplaints"
#define kElectricityComplaints @"ElectricityComplaints"
#define kSewageComplaints @"SewageComplaints"
#define kLawComplaints @"LawComplaints"
#define kTransportationComplaints @"TransportationComplaints"

@interface Constants : NSObject

@end