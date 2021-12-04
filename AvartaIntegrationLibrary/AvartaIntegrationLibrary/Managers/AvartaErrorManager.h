//
//  AvartaErrorManager.h
//  Avarta
//
//  Created by Dmitrii Babii on 19.08.16.
//  Copyright © 2016 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvartaErrorManager : NSObject

extern NSInteger const kBadRequestCode;
extern NSString * _Nonnull const AvartaErrorDomain;
extern NSInteger const kEmptyActivities;
extern NSInteger const kNoStartedWorkflow;

+(BOOL)checkNoWebInstance:(nonnull NSError*)error;
+(nullable NSString*)AvartaCodeFromError:(nonnull NSError*)error;
+(nullable NSError *)errorFromAvartaCode:(nullable NSString*)code;
+(nullable NSError*)formattedErrorForError:(nonnull NSError*)error forLogIn:(BOOL)logIn enableWorkflowKey:(BOOL)enableWorkflowKey andCurrentUserName:(nullable NSString*)currentUserName;
+(nullable NSError*)checkBadRequestAndReturnError:(nonnull NSError*)error;
+(nullable NSError*)resolveError:(nonnull NSError*)error;
+(nullable NSError*)errorFromCode:(NSInteger)errorCode userName:(nullable NSString*)username;

@end
