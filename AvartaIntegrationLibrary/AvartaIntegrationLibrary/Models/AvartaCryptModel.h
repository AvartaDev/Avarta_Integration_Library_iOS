//
//  AvartaCryptModel.h
//  Avarta
//
//  Created by Dmitrii Babii on 29.03.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AvartaCryptModel : NSObject

- (nullable NSString*)encryptString:(nonnull NSString*)inputString;
- (nullable NSString*)encryptStringWithoutSalt:(nonnull NSString*)inputString with:( NSData*_Nullable)sharedkey;
- (nullable NSString*)decryptString:(nonnull NSString *)inputString;
- (nullable instancetype)initWithVector:(nonnull NSString*)vector key:(nonnull NSString*)key cipher:(nonnull NSString*)cipher;
- (void)decryptSalt:(nonnull NSString*)salt  withkey:(nonnull NSData*)strKey;
-(NSString*_Nullable)encryptString:(nonnull NSString*)inputString  withKey:(nonnull NSData*)sharedKey;
@property (nonatomic, nullable, strong, readonly) NSString *decryptedSalt;

@end
