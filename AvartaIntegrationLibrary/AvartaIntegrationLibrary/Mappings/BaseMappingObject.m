//
//  BaseMappingObject.m

#import "BaseMappingObject.h"

@implementation BaseMappingObject

+ (NSDictionary *)mapProperties
{
    return @{};
}

+ (NSString *)keyName
{
    return @"";
}

+ (NSString *)keyNameAlter
{
    return @"";
}

- (void)_description
{
    printf("\n========================== [ %s ]==============================\n", [NSStringFromClass([self class]) UTF8String]);
    [[[self class] mapProperties] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        if (![obj isKindOfClass:[NSString class]])
        {
            if ([[self valueForKey:key] isKindOfClass:[NSArray class]])
            {
                printf("%20s : (%d)\n", [key UTF8String], (int)[[self valueForKey:key] count]);
                [[self valueForKey:key] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [obj _shortDescription];
                    if (![[[self valueForKey:key] lastObject] isEqual:obj])
                    {
                        printf("%10s %20s\n", "", "--------------------------------------------------------");
                    }
                }];
            }
            else
            {
                printf("%20s : \n", [key UTF8String]);
                [[self valueForKey:key] _shortDescription];
            }
        }
        else
        {
            if ([[self valueForKey:key] isKindOfClass:[NSString class]])
            {
                printf("%20s : %s\n", [key UTF8String], [[self valueForKey:key] UTF8String]);
            }
            else
            {
                printf("%20s : %s\n", [key UTF8String], [[[self valueForKey:key] description] UTF8String]);
            }
        }
    }];
}

- (void)_shortDescription
{
    printf("%28s [ %s ] ** \n", "**",[NSStringFromClass([self class]) UTF8String]);
    [[[self class] mapProperties] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj conformsToProtocol:@protocol(MappingProtocol)]) {
            Class mappingClass = [obj class];
            id tmpObj = [mappingClass new];
            [tmpObj _description];
        }
        else if (![obj isKindOfClass:[NSString class]])
        {
            printf("%35s : (\n", [key UTF8String]);
            [[self valueForKey:key] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj _shortDescription];
            }];
            printf("%35s : )\n", [key UTF8String]);
        }
        else
        {
            if ([[self valueForKey:key] isKindOfClass:[NSString class]])
            {
                printf("%35s : %s\n", [key UTF8String], [[self valueForKey:key] UTF8String]);
            }
            else
            {
                printf("%35s : %s\n", [key UTF8String], [[[self valueForKey:key] description] UTF8String]);
            }
        }
    }];
}

#pragma mark - Parse objects
+ (id)localMapDictionary:(NSDictionary *)dict toClass:(Class)mappingClass
{
    // init mapping class
    id mObj = [mappingClass new];
    
    [[[mappingClass class] mapProperties] enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop)
     {
         // if sub object conforms to MappingProtocol map his properties
         if ([obj conformsToProtocol:@protocol(MappingProtocol)])
         {
             // if sub obj - array
             NSString *objString = NSStringFromClass([obj class]);
             if ([obj respondsToSelector:@selector(keyName)]) {
                 NSString *tmpObjString = [obj keyName];
                 if (dict[tmpObjString]) {
                     objString = [obj keyName];
                 }
             }
             if ([obj respondsToSelector:@selector(keyNameAlter)]) {
                 NSString *tmpObjString = [obj keyNameAlter];
                 if (dict[tmpObjString]) {
                     objString = [obj keyNameAlter];
                 }
             }
             
             if (dict && !dict[objString]) { //have key, but does not have data, so just skip
                 //NSLog(@"property %@ has no data for key %@", key, objString);
                 [mObj setValue:nil forKey:key];
             }
             else if (dict && [dict isKindOfClass:[NSDictionary class]] && dict[objString] && [dict[objString] isKindOfClass:[NSArray class]])
             {
                 NSMutableArray *tmpArray = [NSMutableArray new];
                 // map all his items
                 for (NSDictionary *d in dict[objString])
                 {
                     if (d != NULL && [d class] != [NSNull class])
                     {
                         id mObj2 = [self localMapDictionary:d toClass:[obj class]];
                         [tmpArray addObject:mObj2];
                     }
                 }
                 
                 [mObj setValue:tmpArray forKey:key];
             }
             else
             {
                 //if (dict[obj] != NULL && ![dict[obj] isKindOfClass:[NSNull class]])
                 if (dict != NULL && [dict class] != [NSNull class] && [dict isKindOfClass:[NSDictionary class]] && dict[objString])
                 {
                     id dictObj = dict[objString];
                     if (dictObj && [dictObj class] != [NSNull class] && ![dictObj isKindOfClass:[NSString class]]) {
                         id subObj = [self localMapDictionary:dict[objString] toClass:[obj class]];
                         [mObj setValue:subObj forKey:key];
                     }
                 }
             }
         }
         else
         {
             // non user object map directly
             if (dict && [dict isKindOfClass:[NSDictionary class]])
             {
                 if (dict[obj] != NULL && ([dict[obj] class] != [NSNull class])) {
                     NSLog(@"dict[obj] %@", dict[obj]);
                     [mObj setValue:dict[obj] forKey:key];
                 }
             }
         }
     }];
    
    return mObj;
}

+ (NSArray*)mapArrayToClass:(NSArray*)rootArray toClass:(Class)mappingClass
{
    NSMutableArray *retArray = [NSMutableArray array];
    
    for (NSDictionary *tmpValues in rootArray)
    {
        // sub mapping
        id mObj = [self localMapDictionary:tmpValues toClass:mappingClass];
        
        // main array
        [retArray addObject:mObj];
    }
    
    return retArray;
}

+ (NSArray *)mapDictionary:(NSDictionary *)dict toClass:(Class)mappingClass
{
    if (dict == NULL || ![dict isKindOfClass:[NSDictionary class]])
    {
        return [NSArray new];
    }
    
    ////fix single object
    NSArray *rootArray;
    if (dict[@"data"]!= NULL)
    {
        rootArray = dict[@"data"];
    }
    else
    {
        rootArray = @[dict];
    }
    
    NSArray *retArray = [self mapArrayToClass:rootArray toClass:mappingClass];
    
    return retArray;
}

+ (id)mapSimpleObject:(NSDictionary *)dict toClass:(Class)mappingClass
{
    if (![dict isKindOfClass:[NSDictionary class]])
        return NULL;
    
    //fix single object
    NSArray *rootArray;
    rootArray = @[dict];
    
    if (rootArray.count > 0)
    {
        id mObj = [self localMapDictionary:rootArray[0] toClass:mappingClass];
        return mObj;
    }
    
    return NULL;
}


@end


