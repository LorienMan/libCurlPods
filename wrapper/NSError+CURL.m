#import "NSError+CURL.h"


static NSString *kCURLErrorDomain = @"kCURLErrorDomain";
static NSInteger kCURLCancelledErrorCode = -2;
static NSInteger kCURLGenericErrorCode = -1;


@implementation NSError (CURL)

+ (NSError *)errorWithCURLCode:(CURLcode)code {
    // Default to curl_easy_strerror, override when deemed necessary
    NSString *description = [NSString stringWithCString:curl_easy_strerror(code) encoding:NSUTF8StringEncoding];
    NSString *reason = nil;

    // Details from http://curl.haxx.se/libcurl/c/libcurl-errors.html
    switch (code) {
        case CURLE_UNSUPPORTED_PROTOCOL: // 1
            reason = @"The URL you passed to libcurl used a protocol that this libcurl does not support. "
            "The support might be a compile-time option that you didn't use, it can be a misspelled protocol "
            "string or just a protocol libcurl has no code for.";
            break;

        case CURLE_FAILED_INIT: // 2
            reason = @"Very early initialization code failed. This is likely to be an internal error or problem, or a "
            "resource problem where something fundamental couldn't get done at init time.";
            break;

        case CURLE_URL_MALFORMAT: // 3
            reason = @"The URL was not properly formatted.";
            break;

        case CURLE_NOT_BUILT_IN: // 4
            reason = @"A requested feature, protocol or option was not found built-in in this libcurl due to a "
            "build-time decision.";
            break;

        case CURLE_COULDNT_RESOLVE_PROXY: // 5
            reason = @"The given proxy host could not be resolved.";
            break;

        case CURLE_COULDNT_RESOLVE_HOST: // 6
            reason = @"The given remote host was not resolved.";
            break;

        case CURLE_COULDNT_CONNECT: // 7
            break;

        case CURLE_PARTIAL_FILE: // 18
            reason = @"This happens when the server first reports an expected transfer size, and then delivers data "
            "that doesn't match the previously given size.";
            break;

        case CURLE_HTTP_RETURNED_ERROR: // 22
            break;

        case CURLE_WRITE_ERROR: // 23
            reason = @"An error occurred when writing received data to a local file, or an error was returned to "
            "libcurl from a write callback.";
            break;

        case CURLE_READ_ERROR: // 26
            reason = @"There was a problem reading a local file or an error returned by the read callback.";
            break;

        case CURLE_OUT_OF_MEMORY: // 27 - Shit has seriously hit the fan!
            break;

        case CURLE_OPERATION_TIMEDOUT: // 28
            break;

        case CURLE_RANGE_ERROR: // 33
            break;

        case CURLE_HTTP_POST_ERROR: // 34
            reason = @"This is an odd error that mainly occurs due to internal confusion."; // lol
            break;

        case CURLE_SSL_CONNECT_ERROR: // 35
            reason = @"A problem occurred somewhere in the SSL/TLS handshake. "
            "Could be certificates (file formats, paths, permissions), passwords, and others.";
            break;

        case CURLE_BAD_DOWNLOAD_RESUME: // 36
            reason = @"The download could not be resumed because the specified offset was out of the file boundary.";
            break;

        case CURLE_FUNCTION_NOT_FOUND: // 41
            reason = @"A required zlib function was not found.";
            break;

        case CURLE_ABORTED_BY_CALLBACK: // 42
            reason = @"A callback returned 'abort' to libcurl.";
            break;

        case CURLE_BAD_FUNCTION_ARGUMENT: // 43
            description = @"Internal error.";
            reason = @"A function was called with a bad parameter.";
            break;

        case CURLE_INTERFACE_FAILED: // 45
            reason = @"Set which interface to use for outgoing connections' source IP address with CURLOPT_INTERFACE.";
            break;

        case CURLE_TOO_MANY_REDIRECTS: // 47
            reason = @"Redirect limit reached or loop detected.";
            break;

        case CURLE_UNKNOWN_OPTION: // 48
            reason = @"An option passed to libcurl is not recognized/known.";
            break;

        case CURLE_PEER_FAILED_VERIFICATION:
            reason = @"The remote server's SSL certificate or SSH md5 fingerprint was deemed not OK.";
            break;

        case CURLE_GOT_NOTHING: // 52
            break;

        case CURLE_SSL_ENGINE_NOTFOUND: // 53
            break;

        case CURLE_SSL_ENGINE_SETFAILED: // 54
            break;

        case CURLE_SEND_ERROR: // 55
            description = @"Failure sending data to server";
            break;

        case CURLE_RECV_ERROR: // 56
            description = @"Failure receiving data from server";
            break;

        case CURLE_SSL_CERTPROBLEM: // 58
            break;

        case CURLE_SSL_CIPHER: // 59
            break;

        case CURLE_SSL_CACERT: // 60
            break;

        case CURLE_BAD_CONTENT_ENCODING:
            break;

        case CURLE_FILESIZE_EXCEEDED: // 63
            break;

        case CURLE_SSL_ENGINE_INITFAILED: // 66
            break;

        case CURLE_LOGIN_DENIED: // 67
            reason = @"The remote server denied login; double check user and password.";
            break;

        case CURLE_CONV_FAILED: // 75
            break;

        case CURLE_CONV_REQD: // 76
            reason = @"Caller must register conversion callbacks using curl_easy_setopt options "
            "CURLOPT_CONV_FROM_NETWORK_FUNCTION, CURLOPT_CONV_TO_NETWORK_FUNCTION, and "
            "CURLOPT_CONV_FROM_UTF8_FUNCTION.";
            break;

        case CURLE_SSL_CACERT_BADFILE: // 77
            reason = @"Could not load CACERT file; missing or wrong format.";
            break;

        case CURLE_REMOTE_FILE_NOT_FOUND: // 78
            reason = @"The resource referenced in the URL does not exist.";
            break;

        case CURLE_SSL_SHUTDOWN_FAILED: // 80
            reason = @"Failed to shut down the SSL connection";
            break;

        case CURLE_SSL_CRL_BADFILE:
            reason = @"Could not load CRL file; missing or wrong format.";
            break;

        case CURLE_SSL_ISSUER_ERROR: // 84
            break;

        case CURLE_CHUNK_FAILED: // 88
            break;

        default:
            reason = [NSString stringWithFormat:@"Unknown libcurl error with code %u", code];
            break;
    }

    NSString *errorDescription = [description stringByAppendingString:reason ? [@" " stringByAppendingString:reason] : @""];
    return [NSError errorWithDomain:kCURLErrorDomain
                               code:code
                           userInfo:@{ NSLocalizedDescriptionKey: errorDescription }];
}

+ (NSError *)curlCancelError {
    return [NSError errorWithDomain:kCURLErrorDomain
                               code:kCURLCancelledErrorCode
                           userInfo:@{ NSLocalizedDescriptionKey: @"Request cancelled" }];
}

+ (NSError *)curlGenericError {
    return [NSError errorWithDomain:kCURLErrorDomain
                               code:kCURLGenericErrorCode
                           userInfo:@{ NSLocalizedDescriptionKey: @"Generic error" }];
}

@end
