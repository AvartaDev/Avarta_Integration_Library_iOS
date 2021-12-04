//
//  AvartaAppUpdater.h
//  Avarta
//
//  Created by Dmitrii Babii on 15.12.16.
//  Copyright © 2016 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AvartaAppSettingsModel;
@class AvartaNetworkRequestManager;

@interface AvartaSettingsManager : NSObject

- (nonnull instancetype)initWithNetworkManager:(nonnull AvartaNetworkRequestManager*)manager;
- (void)getApplicationSettingsWithApplicationCode:(nonnull NSString*)appcode Completion:(void (^ _Nullable)(NSError  * _Nullable error, AvartaAppSettingsModel * _Nullable model))completionBlock;

@end
