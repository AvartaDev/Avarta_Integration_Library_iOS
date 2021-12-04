//
//  BaseMappingObject.h

#import "MappingProtocol.h"

@interface BaseMappingObject : NSObject<MappingProtocol>

@property (nonatomic, strong) NSNumber *baseObjId;

- (void)_description;
- (void)_shortDescription;

+ (NSDictionary *)mapProperties;
+ (NSString *)keyName;
+ (NSString *)keyNameAlter;

//map objects
+ (NSArray *)mapDictionary:(NSDictionary *)dict toClass:(Class)mappingClass;
+ (id)mapSimpleObject:(NSDictionary *)dict toClass:(Class)mappingClass;
+ (NSArray *)mapArrayToClass:(NSArray*)rootArray toClass:(Class)mappingClass;

@end
