#import <Foundation/Foundation.h>

@class CURLBufferReader;

NS_ASSUME_NONNULL_BEGIN

extern size_t CURLBufferReaderCallback(char *buffer, size_t size, size_t length, CURLBufferReader *reader);

@interface CURLBufferReader : NSObject
@property (nonatomic, strong, readonly) NSData *data;

- (NSDictionary<NSString *, NSString *> *)httpHeaders;

@end

NS_ASSUME_NONNULL_END
