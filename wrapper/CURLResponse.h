#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CURLResponse : NSObject
@property (nonatomic, assign, readonly) NSInteger statusCode;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSString *> *httpHeaders;
@property (nonatomic, strong, readonly) NSData *data;

- (instancetype)initWithStatusCode:(NSInteger)statusCode httpHeaders:(NSDictionary<NSString *, NSString *> *)httpHeaders data:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
