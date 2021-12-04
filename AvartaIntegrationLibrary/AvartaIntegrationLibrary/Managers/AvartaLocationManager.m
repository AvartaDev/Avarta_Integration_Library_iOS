//
//  AvartaLocationManager.m
//  Avarta
//
//  Created by Dmitrii Babii on 21.08.16.
//  Copyright © 2016 Avarta Password Solutions. All rights reserved.
//

#import "AvartaLocationManager.h"
#import <Bugsnag/Bugsnag.h>

@interface AvartaLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) void (^permissionCompletion)(BOOL success);
@end

@implementation AvartaLocationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return self;
}

-(void)checkLocationPermissionsWithCompletionAndStartUpdating:(void(^)(BOOL success))completion
{
    if ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        if ( [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] ) {
            _permissionCompletion = completion;
            [_locationManager requestWhenInUseAuthorization];
        }
    }else{
        [_locationManager startUpdatingLocation];
        completion(YES);
    }
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(_permissionCompletion)
    {
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
                _permissionCompletion(NO);
                break;
            case kCLAuthorizationStatusRestricted:
                _permissionCompletion(NO);
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                [_locationManager startUpdatingLocation];
                _permissionCompletion(YES);
                break;
            case kCLAuthorizationStatusDenied:
                _permissionCompletion(NO);
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                [_locationManager startUpdatingLocation];
                _permissionCompletion(YES);
                break;
            default:
                _permissionCompletion(NO);
                break;
        }
        
        _permissionCompletion = nil;
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    _coordinates = [locations lastObject].coordinate;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
   [Bugsnag notifyError:error];
}

@end
