#import <Foundation/Foundation.h>
#import "CURLResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface CURLResponse : NSObject

- (instancetype)initWithStatusCode:(NSInteger)statusCode httpHeaders:(NSDictionary<NSString *, NSString *> *)httpHeaders data:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
