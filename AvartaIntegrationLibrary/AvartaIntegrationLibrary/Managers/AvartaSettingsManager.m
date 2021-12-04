//
//  AvartaAppUpdater.m
//  Avarta
//
//  Created by Dmitrii Babii on 15.12.16.
//  Copyright © 2016 Avarta Password Solutions. All rights reserved.
//

#import "AvartaSettingsManager.h"
#import "AvartaNetworkRequestManager.h"
#import "AvartaAppVersionManager.h"
#import "AvartaAppSettingsModel.h"
#import "BaseMappingObject.h"
#import <Bugsnag/Bugsnag.h>


@interface AvartaSettingsManager ()

@property (nonnull, nonatomic, strong) AvartaNetworkRequestManager *manager;

@end

@implementation AvartaSettingsManager

- (nonnull instancetype)initWithNetworkManager:(AvartaNetworkRequestManager*)manager
{
    self = [super init];
    if (self) {
        self.manager = manager;
        
        
    }
    return self;
}

- (void)getApplicationSettingsWithApplicationCode:(NSString*)appcode Completion:(void (^ _Nullable)(NSError  * _Nullable error, AvartaAppSettingsModel * _Nullable model))completionBlock
{
    [self.manager appConfigRequestWithApplicationCode:appcode Completion:^(NSError *error, NSDictionary *result) {
       if(!error)
       {
           AvartaAppSettingsModel *model = [AvartaAppSettingsModel mapSimpleObject:result toClass:[AvartaAppSettingsModel class]];
           completionBlock(nil, model);
       }else{
          [Bugsnag notifyError:error];
           completionBlock(error, nil);
       }
    }];
}


@end
