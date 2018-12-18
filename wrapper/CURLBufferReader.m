#import "CURLBufferReader.h"


@interface CURLBufferReader ()
@property (nonatomic, strong) NSMutableData *mutableData;

- (void)appendBuffer:(char *)buffer length:(size_t)length;
@end


size_t CURLBufferReaderCallback(char *buffer, size_t size, size_t length, CURLBufferReader *reader) {
    [reader appendBuffer:buffer length: length];
    return length;
}


@implementation CURLBufferReader

- (instancetype)init {
    if (self = [super init]) {
        self.mutableData = [NSMutableData new];
    }

    return self;
}

- (void)appendBuffer:(char *)buffer length:(size_t)length {
    [self.mutableData appendBytes:buffer length:length];
}

- (NSData *)data {
    return [self.mutableData copy];
}

- (NSDictionary<NSString *, NSString *> *)httpHeaders {
    NSString *headersString = self.description;
    NSMutableArray<NSString *> *headerLines = [[headersString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];

    // Skip status code
    [headerLines removeObjectAtIndex:0];

    NSMutableDictionary<NSString *, NSString *> *mHeaders = [NSMutableDictionary new];
    for (NSString *headerLine in headerLines) {
        NSRange range = [headerLine rangeOfString:@":"];
        if (range.location == NSNotFound) {
            continue;
        }

        NSString *key = [headerLine substringToIndex:range.location];
        key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        NSString *value = [headerLine substringFromIndex:range.location + 1];
        value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if ([key length] > 0 && [value length] > 0) {
            mHeaders[key] = value;
        }
    }

    return [mHeaders copy];
}

- (NSString *)description {
    NSString *dataString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    return [dataString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

@end
