//
//  LocationManagerStore.h
//  goskate
//
//  Created by Edward Kim on 9/9/12.
//  Copyright (c) 2012 shoddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManagerStore : NSObject
@property (strong) void (^updateLocationBlock)(double speed);
+ (LocationManagerStore*)sharedStore;
- (void)startLocationUpdates;
- (void)stopLocationUpdates;
@end
