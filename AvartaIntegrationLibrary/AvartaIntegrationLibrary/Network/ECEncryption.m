//
//  ECEncryption.m
//  AvartaIntegrationLibrary
//
//  Created by DARSHANA  on 25/04/19.
//  Copyright © 2019 Dmitrii Babii. All rights reserved.
//

#import "ECEncryption.h"
#import <Security/Security.h>


#define kPublicKeyTag "com.apple.sample.publickey";
static const uint8_t kFromKeyIdentifier[] = kPublicKeyTag;

@interface ECEncryption ()
//@property(nonatomic,strong)ECKeyPair *EncryptionService ;
@property(nonatomic,strong)ECKeyPair *keyPair;

//@property(nonatomic,strong) ECKeyPair *curve25519Key;
@end

@implementation ECEncryption

+ (instancetype)defaultInstance {
    static ECEncryption *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.keyPair = [Curve25519 generateKeyPair];
        
        NSString *resultPublicKey = [sharedInstance.keyPair.publicKey base64EncodedStringWithOptions:0];
        NSLog(@"PublicKey:%@",resultPublicKey);
        sharedInstance.strPublicKey = resultPublicKey;
        
        
//        NSData *publicKey =  [[NSData alloc] initWithBase64EncodedString:@"JtvhkRdSRpvemfi0XkpFJPG4P5gn2PE33lesMYlwRkM=" options:0];
        
      
//        sharedInstance.curve25519Key = [Curve25519 new];
//        //sharedInstance.EncryptionService =  [IREncryptionService new];
//        sharedInstance.keyPair = [sharedInstance.EncryptionService generateKeyPair];
//
//        NSData * pubkey = sharedInstance.keyPair.publicKey;
//        NSString *strKey  =  [pubkey base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//        sharedInstance.strPublicKey = strKey;
//
//        NSData * prikey = sharedInstance.keyPair.privateKey;
//        sharedInstance.strPrivateKey  =  [prikey base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        
     
        
//
//        CFErrorRef error = nil ;
//        CFDictionaryRef  decRef = (__bridge CFDictionaryRef)[sharedInstance attribues];
//        if (@available(iOS 10.0, *)) {
//            SecKeyRef privateKey =  SecKeyCreateRandomKey(decRef,&error );
//            SecKeyRef publicKey =  SecKeyCopyPublicKey(privateKey);
//
//            NSData *key = dataFromKey(publicKey);
//            CFErrorRef error = NULL;
//            NSData* keyData = (NSData*)CFBridgingRelease(  // ARC takes ownership
//                                                         SecKeyCopyExternalRepresentation(publicKey, &error)
//                                                         );
//            if (!keyData) {
//                NSError *err = CFBridgingRelease(error);  // ARC takes ownership
//                // Handle the error. . .
//            }
//
//
//
//        sharedInstance.strPublicKey  =[key base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

//        } else {
//            // Fallback on earlier versions
//        }
    });
    return sharedInstance;
}

-(NSData*)getSharedSecret:(NSString*)serverPublicKey{
    
     NSData *publicKey =  [[NSData alloc] initWithBase64EncodedString:serverPublicKey options:0];
    
    NSData *mysharedSecret = [Curve25519 generateSharedSecretFromPublicKey:publicKey andKeyPair:self.keyPair];
    
//    NSString *resultsharedSecret = [mysharedSecret base64EncodedStringWithOptions:0];
    
//
//    NSData *publicKey =  [[NSData alloc] initWithBase64EncodedString:serverPublicKey options:0];
//
//    NSData *sharedSecretAlice = [self.EncryptionService senderSharedKeyWithRecieverPublicKey:publicKey  andSenderKeyPair:self.keyPair];
//// sharedSecretAlice =    [self.EncryptionService receiverSharedKeyWithSenderPublicKey:publicKey andReceiverKeyPair:self.keyPair];
//    NSString *sharedSecret = [sharedSecretAlice base64EncodedStringWithOptions:0];
    
   
    
//    NSLog(@"%@",sharedSecretAlice);
    
    self.sharedSecret = mysharedSecret;
    return mysharedSecret;
}

-(NSDictionary*)attribues {
    NSMutableDictionary *keyAttribute = [[NSMutableDictionary alloc] init];
    [keyAttribute setValue: [NSNumber numberWithInt:256] forKey:(NSString*)kSecAttrKeySizeInBits];
    [keyAttribute setValue:(NSString*)kSecAttrKeyTypeEC forKey:(NSString*)kSecAttrKeyType];
    [keyAttribute setValue:@{(NSString*)kSecAttrIsPermanent:[NSNumber numberWithBool:false]} forKey:(NSString*)kSecPrivateKeyAttrs];
    
    return keyAttribute;
}
NSMutableDictionary * rsa2048KeyQuery(NSData* tag) {
    NSMutableDictionary * rsaQuery = [[NSMutableDictionary alloc] init];
    
    rsaQuery[(__bridge id)kSecClass]              = (__bridge id)kSecClassKey;
    rsaQuery[(__bridge id)kSecAttrKeyType]        = (__bridge id)kSecAttrKeyTypeRSA ;
    rsaQuery[(__bridge id)kSecAttrApplicationTag] = tag ;
    rsaQuery[(__bridge id)kSecAttrKeySizeInBits]  = @(2048);
    
    return rsaQuery;
}


void queryValueToData(NSMutableDictionary *query, void * value) {
    query[(__bridge id)kSecValueRef] = (__bridge id)value ;
    query[(__bridge id)kSecReturnData] = @YES ;
}
void queryDataToValue(NSMutableDictionary *query, id data) {
    query[(__bridge id)kSecValueData] = data ;
    query[(__bridge id)kSecReturnRef] = @YES ;
}
OSStatus queryAddAndRemove(NSMutableDictionary * query, CFTypeRef * ref) {
    OSStatus sanityCheck;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) query, ref);
    if(sanityCheck == errSecDuplicateItem) {
        // if it was already there, need to delete before we add
        (void) SecItemDelete((__bridge CFDictionaryRef) query);
        sanityCheck = SecItemAdd((__bridge CFDictionaryRef) query, ref);
    }
    // delete from Keychain
    (void) SecItemDelete((__bridge CFDictionaryRef) query);
    return sanityCheck;
}
NSData * dataFromKey(SecKeyRef givenKey) {
    
    // http://stackoverflow.com/questions/16748993/ios-seckeyref-to-nsdata
    NSData *publicTag = [[NSData alloc] initWithBytes:kFromKeyIdentifier
                                               length:sizeof(kFromKeyIdentifier)];
    
    // BUILD query
    NSMutableDictionary * queryPublicKey = rsa2048KeyQuery(publicTag);
    queryValueToData(queryPublicKey, givenKey);
    
    // MAKE query
    CFDataRef result;
    OSStatus sanityCheck = noErr;
    sanityCheck = queryAddAndRemove(queryPublicKey, (CFTypeRef *)&result);
    
    // SETUP result
    NSData * publicKeyBits = nil;
    if (sanityCheck == errSecSuccess) {
        publicKeyBits = CFBridgingRelease(result);
    }
    
    return publicKeyBits;
}


@end
