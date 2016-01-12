//
//  Copyright (C) 2015 by Plot Guru.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "PGNetworkHandler.h"
#import "PGMappingDescription.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGNetworkHandler ()

- (void)succeedWithTask:(NSURLSessionDataTask *)task
         responseObject:(nullable id)responseObject
                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                 finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish;

- (void)failedWithTask:(nullable NSURLSessionDataTask *)task
                 error:(NSError *)error
               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish;

@end

@implementation PGNetworkHandler

- (instancetype)initWithBaseURL:(nullable NSURL *)url sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (void)succeedWithTask:(NSURLSessionDataTask *)task
         responseObject:(nullable id)responseObject
                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                 finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish
{
    if (self.isCanceled) {
        return;
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (success) {
            success(task, responseObject);
        }
        
        if (finish) {
            finish(task);
        }
    }];
}

- (void)failedWithTask:(nullable NSURLSessionDataTask *)task
                 error:(NSError *)error
               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish
{
    if (self.isCanceled) {
        return;
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (failure) {
            failure(task, error);
        }
        
        if (finish) {
            finish(task);
        }
    }];
}

#pragma mark - PUT

- (nullable NSURLSessionDataTask *)PUT:(NSString *)URLString
                                  from:(nullable NSDictionary *)data
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                                finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish
{
    return [self PUT:URLString parameters:data success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self succeedWithTask:task responseObject:responseObject success:success finish:finish];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failedWithTask:task error:error failure:failure finish:finish];
    }];
}

#pragma mark - POST

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                                   from:(nullable NSDictionary *)data
                               progress:(nullable void (^)(NSProgress *progress))progress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                                 finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish
{
    return [self POST:URLString parameters:data progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self succeedWithTask:task responseObject:responseObject success:success finish:finish];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failedWithTask:task error:error failure:failure finish:finish];
    }];
}

#pragma mark - GET

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                                  from:(nullable NSDictionary *)data
                              progress:(nullable void (^)(NSProgress *progress))progress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                                finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish
{
    return [self GET:URLString parameters:data progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self succeedWithTask:task responseObject:responseObject success:success finish:finish];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failedWithTask:task error:error failure:failure finish:finish];
    }];
}

#pragma mark - DELETE

- (nullable NSURLSessionDataTask *)DELETE:(NSString *)URLString
                                     from:(nullable NSDictionary *)data
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                                   finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish
{
    return [self DELETE:URLString parameters:data success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self succeedWithTask:task responseObject:responseObject success:success finish:finish];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failedWithTask:task error:error failure:failure finish:finish];
    }];
}

@end

NS_ASSUME_NONNULL_END
