#import <Foundation/Foundation.h>
#import "CURLDataTask.h"

@class CURLResponse;

NS_ASSUME_NONNULL_BEGIN

@interface CURLDataTask (Protected)

- (instancetype)initWithURLRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, CURLResponse * _Nullable response, NSError * _Nullable error))completionHandler operationQueue:(NSOperationQueue *)operationQueue;
- (void)overrideHostWithIp:(NSString *)ip port:(NSInteger)port;

@end

NS_ASSUME_NONNULL_END
