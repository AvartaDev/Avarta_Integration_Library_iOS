//
//  AvartaLibraryHelper.h
//  Avarta
//
//  Created by Dmitrii Babii on 11.09.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntegrationLibrary.h"

@interface AvartaLibraryHelper : NSObject

+(nullable NSString*)codeForActivity:(AvartaActivitiesE)type;
+(AvartaActivitiesE)activityTypeForCode:(nullable NSString*)code;
+(nullable NSString*)typeCodeForAvartaWorkflowtype:(AvartaWorkflowType)type;
+(nullable NSString*)serializeJSONToString:(nonnull NSDictionary*)json;

@end
