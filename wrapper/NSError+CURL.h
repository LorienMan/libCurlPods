#import <Foundation/Foundation.h>
#import <libCurlPods/libCurlPods.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *kCURLErrorDomain;
static NSInteger kCURLCancelledErrorCode;
static NSInteger kCURLGenericErrorCode;

@interface NSError (CURL)

+ (NSError *)errorWithCURLCode:(CURLcode)code;
+ (NSError *)curlCancelError;
+ (NSError *)curlGenericError;

@end

NS_ASSUME_NONNULL_END
