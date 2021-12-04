//
//  MappingProtocol.h

#import <Foundation/Foundation.h>


@protocol MappingProtocol <NSObject>
@required
+ (NSDictionary *)mapProperties;
@end
