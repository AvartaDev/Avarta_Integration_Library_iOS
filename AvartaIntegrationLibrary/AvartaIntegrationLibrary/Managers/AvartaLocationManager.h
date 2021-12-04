//
//  AvartaLocationManager.h
//  Avarta
//
//  Created by Dmitrii Babii on 21.08.16.
//  Copyright © 2016 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface AvartaLocationManager : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
-(void)checkLocationPermissionsWithCompletionAndStartUpdating:(void(^)(BOOL success))completion;

@end
