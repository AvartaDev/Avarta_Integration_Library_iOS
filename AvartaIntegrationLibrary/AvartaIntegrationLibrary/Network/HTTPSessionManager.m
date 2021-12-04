//
//  HTTPSessionManager.m
//  TestInterstitialsApp
//
//  Created by Dmitrii Babii on 12.04.17.
//  Copyright © 2017 Onix. All rights reserved.
//

#import "HTTPSessionManager.h"
#import <GZIP/GZIP.h>
#import <Bugsnag/Bugsnag.h>

@interface HTTPSessionManager ()<NSURLSessionDelegate>

@property (nonnull, nonatomic, strong) NSURLSession *session;
@property (nonnull, nonatomic, strong) NSURL *baseUrl;
@property (nonatomic, nonnull, strong) NSString *organizationId;
@property (nonatomic, nonnull, copy) NSIndexSet *acceptableStatusCodes;
@end

@implementation HTTPSessionManager


NSString *const kErrorJsonDataKey = @"ErrorJSONDataKey";


- (instancetype)initWithBaseURL:(NSURL*)baseURL andOrganizationId:(NSString*)organizationId
{
    self = [super init];
    if (self) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        self.baseUrl = baseURL;
        self.organizationId = organizationId;
        self.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        
    }
    return self;
}

-(NSString*)getAuthCredential{
    NSString *credentials = [NSString stringWithFormat:@"%@:%@",@"solus_api_user", @"solus_api_password"];
    NSData *authData = [credentials dataUsingEncoding:NSUTF8StringEncoding];
    NSString *auth = [NSString stringWithFormat:@"Basic %@",[authData base64EncodedStringWithOptions:0]];
    return auth;
}

-(void)getRequest:(NSString *)urlString params:(NSDictionary *)params andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))completionBlock {
    NSString *url = [[NSURL URLWithString:urlString relativeToURL:[NSURL URLWithString: self.baseUrl.absoluteString]] absoluteString];
    NSString *paramString = [self convertParamsToString:params];
    NSString *completedURLString = [url stringByAppendingString:paramString];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:completedURLString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:nil];
            completionBlock(nil, serializedData);
        }else{
           [Bugsnag notifyError:error];
            completionBlock(error, nil);
        }
    }];
    
    [dataTask resume];
}

-(void)postRequest:(NSString *)urlString params:(NSDictionary *)params andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))completionBlock {
    NSString *url = [[NSURL URLWithString:urlString relativeToURL:[NSURL URLWithString: self.baseUrl.absoluteString]] absoluteString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:[self getAuthCredential]  forHTTPHeaderField:@"Authorization"];
    [request addValue:self.organizationId forHTTPHeaderField:@"organisationKey"];
    [request addValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    if(self.isComressionRequired &&  [urlString isEqualToString:@"/api/v1/behaviour/logbehaviour/"]  )
    {
        [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        postData = [postData gzippedData];
    }
    [request setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if ([httpResponse statusCode] != 200 && httpResponse != nil)
        {
            
            NSError *err = [NSError errorWithDomain:@"" code:[httpResponse statusCode] userInfo:[NSDictionary dictionaryWithObject:httpResponse forKey:@"response"]];
            [Bugsnag notifyError:err];
            
        }
        if(!error){
            
            if(data && data.length > 0){
                NSError *serializationError = nil;
                NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&serializationError];
                if(!serializationError){
                    if([response isKindOfClass:[NSHTTPURLResponse class]]){
                        error = [self checkHTTPCodeInResponse:(NSHTTPURLResponse*)response data:serializedData];
                        if(error){
                           [Bugsnag notifyError:error];
                            completionBlock(error, nil);
                        }else{
                            completionBlock(nil, serializedData);
                        }
                    }else{
                        completionBlock(nil, serializedData);
                    }
                }else{
                    
                    [Bugsnag notifyError:serializationError];
                    if(serializationError.code == 3840){
                        NSString *stringResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        if(stringResult){
                            completionBlock(nil, @{@"Message":stringResult});
                        }else{
                            completionBlock(serializationError, nil);
                        }
                    }else{
                        completionBlock(serializationError, nil);
                    }
                }
            }else{
                 error = [self checkHTTPCodeInResponse:(NSHTTPURLResponse*)response data:nil];
               [Bugsnag notifyError:error];
                completionBlock(nil,nil);
            }
        }else{
           [Bugsnag notifyError:error];
            completionBlock(error, nil);
        }
    }];
    
    [postDataTask resume];
}

-(NSError*)checkHTTPCodeInResponse:(NSHTTPURLResponse*)response data:(NSDictionary*)data
{
    if (self.acceptableStatusCodes && ![self.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode] && [response URL]) {
        NSMutableDictionary *userInfo = [NSMutableDictionary new];
        [userInfo setObject:[NSHTTPURLResponse localizedStringForStatusCode:response.statusCode] forKey:NSLocalizedDescriptionKey];
        if(data){
            [userInfo setObject:data forKey:kErrorJsonDataKey];
        }
        return  [NSError errorWithDomain:@"HTTPSession" code:response.statusCode userInfo:userInfo];
    }
    return nil;
}

-(NSString*)convertParamsToString:(NSDictionary*)params {
    NSMutableString *result = [NSMutableString new];
    [result appendString:@"?"];
    
    for (NSString *key in [params allKeys]){
        [result appendString:[NSString stringWithFormat:@"%@=%@", [self percentSecapedStringFromString:key], [self percentSecapedStringFromString:params[key]]]];
        if ([[params allKeys] indexOfObject:key] != NSNotFound && [[params allKeys] indexOfObject:key] < params.allKeys.count - 1){
            [result appendString:@"&"];
        }
    }
    return result;
}

-(NSString*)percentSecapedStringFromString:(NSString*)string
{
    static NSString * const kCharactersDelimitersToEncode = @":#[]@";
    static NSString * const kSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kCharactersDelimitersToEncode stringByAppendingString:kSubDelimitersToEncode]];
    
    NSString *encoded = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    return encoded;
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    NSLog(@"error %@", error);
   [Bugsnag notifyError:error];
}

@end
