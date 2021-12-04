//
//  AppVersionManager.h
//  Avarta
//
//  Created by Dmitrii Babii on 26.07.16.
//  Copyright © 2016 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvartaAppVersionManager : NSObject

+(NSString *)appVersion;
+(NSString *)build;
+(NSString*)deviceName;
+(NSString*)currentAppVersionName;
+(NSString*)currentUserAgent;
@end
