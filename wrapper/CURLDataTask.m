#import "CURLDataTask.h"
#import "CURLDataTask_Protected.h"
#import "CURLBufferReader.h"
#import "curl.h"
#import "NSError+CURL.h"
#import "CURLResponse.h"
#import "CURLResponse_Protected.h"


static NSString *kDefaultHTTPMethod = @"GET";
static NSTimeInterval kDefaultTimeoutInerval = 30;
static NSInteger kMaxRedirects = 5;
static NSString *kAcceptEncodingHeaderName = @"Accept-Encoding";


@interface CURLDataTask ()
@property (nonatomic, weak) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, copy) void (^completionHandler)(NSData *data, CURLResponse *response, NSError *error);
@property (nonatomic, assign) BOOL didStart;
@property (nonatomic, assign) BOOL isCancelled;
@property (nonatomic, strong) CURLResponse *response;
@property (nonatomic, strong) NSError *error;
@end


@implementation CURLDataTask

- (instancetype)initWithURLRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, CURLResponse *response, NSError *error))completionHandler operationQueue:(NSOperationQueue *)operationQueue {
    if (self = [super init]) {
        self.request = request;
        self.completionHandler = completionHandler;
        self.operationQueue = operationQueue;
    }

    return self;
}

- (void)start {
    if (self.didStart) {
        return;
    }

    self.didStart = YES;

    [self.operationQueue addOperationWithBlock:^{
        [self executeRequest];
    }];
}

- (void)cancel {
    if (!self.didStart) {
        return;
    }

    self.isCancelled = YES;
}

- (void)executeRequest {
    CURL *handle = curl_easy_init();
    if (!handle) {
        self.error = [NSError curlGenericError];
        [self dispatchResult];
        return;
    }

    curl_easy_setopt(handle, CURLOPT_NOSIGNAL, 1L);

    if (self.request.HTTPBody != nil) {
        curl_easy_setopt(handle, CURLOPT_POST, 1L);
        curl_easy_setopt(handle, CURLOPT_POSTFIELDS, (char *)[self.request.HTTPBody bytes]);
        curl_easy_setopt(handle, CURLOPT_POSTFIELDSIZE, (long)[self.request.HTTPBody length]);
    }

    const char *verb = [(self.request.HTTPMethod ?: kDefaultHTTPMethod) UTF8String];
    curl_easy_setopt(handle, CURLOPT_CUSTOMREQUEST, verb);

    const char *url = [(self.request.URL.absoluteString ?: @"") UTF8String];
    curl_easy_setopt(handle, CURLOPT_URL, url);

    // Setup - headers
    __block struct curl_slist *headers = NULL;
    [self.request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        if ([key isEqual:kAcceptEncodingHeaderName]) {
            curl_easy_setopt(handle, CURLOPT_ACCEPT_ENCODING, [value UTF8String]);
        } else {
            const char *header = [[NSString stringWithFormat:@"%@: %@", key, value] UTF8String];
            headers = curl_slist_append(headers, header);
        }
    }];

    curl_easy_setopt(handle, CURLOPT_HTTPHEADER, headers);

    // Setup - response handling callback

    CURLBufferReader *headerBuffer = [CURLBufferReader new];
    curl_easy_setopt(handle, CURLOPT_HEADER, 0L);
    curl_easy_setopt(handle, CURLOPT_HEADERFUNCTION, CURLBufferReaderCallback);
    curl_easy_setopt(handle, CURLOPT_HEADERDATA, headerBuffer);

    CURLBufferReader *dataBuffer = [CURLBufferReader new];
    curl_easy_setopt(handle, CURLOPT_WRITEFUNCTION, CURLBufferReaderCallback);
    curl_easy_setopt(handle, CURLOPT_WRITEDATA, dataBuffer);

    // Setup - configure timeouts
    curl_easy_setopt(handle, CURLOPT_CONNECTTIMEOUT, (long)(self.request.timeoutInterval ?: kDefaultTimeoutInerval));

    // Setup - configure redirections
    curl_easy_setopt(handle, CURLOPT_FOLLOWLOCATION, YES);
    curl_easy_setopt(handle, CURLOPT_MAXREDIRS, (long)kMaxRedirects);

    // Setup - misc configuration
    curl_easy_setopt(handle, CURLOPT_NOPROGRESS, 1L);
    curl_easy_setopt(handle, CURLOPT_FAILONERROR, 0L);
    curl_easy_setopt(handle, CURLOPT_SSL_VERIFYPEER, 1L);

    // Execute
    CURLcode curlResult = curl_easy_perform(handle);

    long statusCode;
    curl_easy_getinfo(handle, CURLINFO_RESPONSE_CODE, &statusCode);

    // Cleanup the headers & handle
    curl_slist_free_all(headers);
    curl_easy_cleanup(handle);

    // Handle result
    if (self.isCancelled) {
        self.error = [NSError curlCancelError];
    } else if (curlResult != CURLE_OK) {
        self.error = [NSError errorWithCURLCode:curlResult];
    } else {
        CURLResponse *response = [[CURLResponse alloc] initWithStatusCode:(NSInteger)statusCode
                                                              httpHeaders:[headerBuffer httpHeaders]
                                                                     data:[dataBuffer data]];
        self.response = response;
    }

    [self dispatchResult];
}

- (void)dispatchResult {
    self.completionHandler(self.response.data, self.response, self.error);
}

@end
