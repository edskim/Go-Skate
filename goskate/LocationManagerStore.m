//
//  LocationManagerStore.m
//  goskate
//
//  Created by Edward Kim on 9/9/12.
//  Copyright (c) 2012 shoddie. All rights reserved.
//

#import "LocationManagerStore.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManagerStore () <CLLocationManagerDelegate>
@property (strong) CLLocationManager *locationManager;
@property (strong) NSDate *locationManagerStartDate;
@end

@implementation LocationManagerStore
@synthesize updateLocationBlock;

- (id)init {
    self = [super init];
    if (self) {
        updateLocationBlock = ^(double speed){};
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return self;
}

//so no other instance can be created. alloc calls allocwithzone by default
+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedStore];
}

+ (LocationManagerStore*)sharedStore {
    //shared instance never destroyed because static pointer is strong pointer
    static LocationManagerStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

- (void)startLocationUpdates {
    [self.locationManager startUpdatingLocation];
    self.locationManagerStartDate = [NSDate date];
}

- (void)stopLocationUpdates {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark CLLocationManager delegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (!newLocation ||
        [newLocation.timestamp compare:oldLocation.timestamp] == NSOrderedAscending ||
        newLocation.horizontalAccuracy < 0.0 ||
        [newLocation.timestamp timeIntervalSinceDate:self.locationManagerStartDate] < 0.0) {
        return;
    }
    
    NSLog(@"\ncoords: %f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    NSLog(@"speed: %f",newLocation.speed);
    NSLog(@"horizontal accuracy: %f",newLocation.horizontalAccuracy);
    
    self.updateLocationBlock(newLocation.speed);
}

@end
