#import "CURLSession.h"
#import "CURLDataTask.h"
#import "CURLDataTask_Protected.h"
#import "CURLResponse.h"


#define MAX_SIMULTANEOUS_REQUESTS_COUNT 20


@interface CURLSession ()
@property (nonatomic, strong) NSOperationQueue *taskOperationQueue;
@end


@implementation CURLSession

+ (instancetype)sharedSession {
    static CURLSession *sharedSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSession = [CURLSession new];
    });

    return sharedSession;
}

- (instancetype)init {
    if (self = [super init]) {
        self.taskOperationQueue = [NSOperationQueue new];
        self.taskOperationQueue.maxConcurrentOperationCount = MAX_SIMULTANEOUS_REQUESTS_COUNT;
    }

    return self;
}

- (CURLDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, CURLResponse *response, NSError *error))completionHandler {
    return [[CURLDataTask alloc] initWithURLRequest:request completionHandler:completionHandler operationQueue:self.taskOperationQueue];
}

@end
