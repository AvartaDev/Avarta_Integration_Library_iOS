//
//  ECEncryption.h
//  AvartaIntegrationLibrary
//
//  Created by DARSHANA  on 25/04/19.
//  Copyright © 2019 Dmitrii Babii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <nuntius/nuntius.h>
#import <_25519/Ed25519.h>
#import <_25519/Curve25519.h>



NS_ASSUME_NONNULL_BEGIN

@interface ECEncryption : NSObject
+ (instancetype)defaultInstance;
@property(nonatomic,strong) NSString *strPrivateKey;
@property(nonatomic,strong) NSString *strPublicKey;
@property(nonatomic,strong)NSData *sharedSecret;
-(NSData*)getSharedSecret:(NSString*)serverPublicKey;
@end

NS_ASSUME_NONNULL_END
