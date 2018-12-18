#import "CURLResponse.h"
#import "CURLResponse_Protected.h"


@interface CURLResponse ()
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *httpHeaders;
@property (nonatomic, strong) NSData *data;
@end


@implementation CURLResponse

- (instancetype)initWithStatusCode:(NSInteger)statusCode httpHeaders:(NSDictionary<NSString *, NSString *> *)httpHeaders data:(NSData *)data {
    if (self = [super init]) {
        self.statusCode = statusCode;
        self.httpHeaders = httpHeaders;
        self.data = data;
    }

    return self;
}

@end
