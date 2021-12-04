//
//  AvartaCryptModel.m
//  Avarta
//
//  Created by Dmitrii Babii on 29.03.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaCryptModel.h"
#import <CommonCrypto/CommonCrypto.h>


//#define CIPHER "vuka@8SW"
////#define PASPHRASE "$h#hudABEy54aPre2haKa+epr2huwRuR"

@interface AvartaCryptModel ()

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *vector;
@property (nonatomic, strong) NSString *cipher;
@property (nonatomic, strong) NSString *salt;

@end

@implementation AvartaCryptModel

- (instancetype)initWithVector:(NSString*)vector key:(NSString*)key cipher:(NSString*)cipher
{
    self = [super init];
    if (self) {
        self.key = key;
        self.vector = vector;
        self.cipher = cipher;
    }
    return self;
}

-(NSString*)encryptString:(NSString*)inputString {
    NSMutableString *string = [NSMutableString new];
    if(self.salt){
        [string appendString:self.salt];
    }
    
    if(inputString){
        [string appendString:inputString];
    }
    
    if(self.cipher) {
        [string appendString:self.cipher];
    }
    
    NSData *inputData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
   NSData *result = [self cryptOperation:kCCEncrypt inputData:inputData stringkey:self.key vector:self.vector];
   NSString *resultString = [result base64EncodedStringWithOptions:0];
    return resultString;
}



-(NSString*)encryptString:(NSString*)inputString  withKey:(NSData*)sharedKey{
    NSMutableString *string = [NSMutableString new];
    if(self.salt){
        [string appendString:self.salt];
    }
    
    if(inputString){
        [string appendString:inputString];
    }
    
    if(self.cipher) {
        [string appendString:self.cipher];
    }
    
    NSData *inputData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *result = [self cryptOperation:kCCEncrypt inputData:inputData key:sharedKey vector:self.vector];
    
    NSString *resultString = [result base64EncodedStringWithOptions:0];
    return resultString;
}


-(NSString*)encryptStringWithoutSalt:(NSString*)inputString  with:(NSData*)dtKey{
    NSMutableString *string = [NSMutableString new];
    
    if(inputString){
        [string appendString:inputString];
    }
    
    if(self.cipher) {
        [string appendString:self.cipher];
    }
    
    NSData *inputData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *result = [self cryptOperation:kCCEncrypt inputData:inputData key:dtKey vector:self.vector];
    NSString *resultString = [result base64EncodedStringWithOptions:0];
    return resultString;
}

-(NSString*)decryptString:(NSString *)inputString{

    NSData *inputData =  [[NSData alloc] initWithBase64EncodedString:inputString options:0];
    NSData *result = [self cryptOperation:kCCDecrypt inputData:inputData stringkey:self.key vector:self.vector];
    
    if(result){
        NSMutableString *resultString = [[NSMutableString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        if (self.cipher) {
            [resultString replaceOccurrencesOfString:self.cipher withString:@"" options:0 range:NSMakeRange(0, resultString.length)];
        }
        if (self.salt) {
            [resultString replaceOccurrencesOfString:self.salt withString:@"" options:0 range:NSMakeRange(0, resultString.length)];
        }
        
        return resultString;
    }
    return nil;
}

-(NSString*)dataToHexString:(NSData*)data
{
    NSUInteger capacity = data.length * 2;
    NSMutableString *sbuf = [NSMutableString stringWithCapacity:capacity];
    const unsigned char *buf = (const unsigned char*)data.bytes;
    NSInteger i;
    for (i=0; i<data.length; ++i) {
        [sbuf appendFormat:@"%02lX", (unsigned long)buf[i]];
    }
    
    return sbuf;
}
-(NSData*)cryptOperation:(CCOperation)operation inputData:(NSData*)inputData key:(NSData*)keyData vector:(NSString*)vector {
    CCCryptorStatus ccStatus = kCCSuccess;
    size_t cryptBytes = 0;
    //NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *vectorData = [vector dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *buffer = [NSMutableData dataWithLength:inputData.length + kCCBlockSizeAES128];
    ccStatus = CCCrypt(operation,
                       kCCAlgorithmAES128,
                       kCCOptionPKCS7Padding,
                       keyData.bytes,
                       kCCKeySizeAES256,
                       vectorData.bytes,
                       inputData.bytes,
                       inputData.length,
                       buffer.mutableBytes,
                       buffer.length,
                       &cryptBytes);
    if (ccStatus == kCCSuccess){
        buffer.length = cryptBytes;
        return buffer;
    }
    
    return nil;
}

-(NSData*)cryptOperation:(CCOperation)operation inputData:(NSData*)inputData stringkey:(NSString*)key vector:(NSString*)vector {
    CCCryptorStatus ccStatus = kCCSuccess;
    size_t cryptBytes = 0;
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *vectorData = [vector dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *buffer = [NSMutableData dataWithLength:inputData.length + kCCBlockSizeAES128];
    ccStatus = CCCrypt(operation,
                       kCCAlgorithmAES128,
                       kCCOptionPKCS7Padding,
                       keyData.bytes,
                       kCCKeySizeAES256,
                       vectorData.bytes,
                       inputData.bytes,
                       inputData.length,
                       buffer.mutableBytes,
                       buffer.length,
                       &cryptBytes);
    if (ccStatus == kCCSuccess){
        buffer.length = cryptBytes;
        return buffer;
    }
    
    return nil;
}

-(NSString *)decryptedSalt{
    return self.salt;
}

- (void)decryptSalt:(NSString*)salt withkey:(NSData*)dtKey
{
    if (salt == nil)
    {
        return;
    }
    NSData *inputData =  [[NSData alloc] initWithBase64EncodedString:salt options:0];
    
    NSData *result;
    
    if(dtKey == nil )
    {
        result = [self cryptOperation:kCCDecrypt inputData:inputData stringkey: self.key  vector:self.vector];
    }else
        {
      result = [self cryptOperation:kCCDecrypt inputData:inputData key: dtKey  vector:self.vector];
        }
    if(result){
        NSMutableString *resultString = [[NSMutableString alloc] initWithData:result encoding:NSUTF8StringEncoding];
//      resultString =   [[result base64EncodedStringWithOptions:0] mutableCopy];
        if (self.cipher) {
            [resultString replaceOccurrencesOfString:self.cipher withString:@"" options:0 range:NSMakeRange(0, resultString.length)];
        }
        self.salt = resultString;
    }
}

@end
