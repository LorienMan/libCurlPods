#import <Foundation/Foundation.h>

@class CURLResponse;
@class CURLDataTask;

NS_ASSUME_NONNULL_BEGIN

@interface CURLSession : NSObject

+ (nonnull instancetype)sharedSession;

- (CURLDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, CURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *overrideHostIPs; // [Host: Ip]

@end

NS_ASSUME_NONNULL_END
