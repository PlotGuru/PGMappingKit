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

@import AFNetworking;

@class PGMappingDescription;

NS_ASSUME_NONNULL_BEGIN

@interface PGNetworkHandler : AFHTTPSessionManager

@property (nonatomic, getter=isCanceled) BOOL canceled;

- (nullable NSURLSessionDataTask *)PUT:(NSString *)URLString
                                  from:(nullable NSDictionary *)data
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                                finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                                   from:(nullable NSDictionary *)data
                               progress:(nullable void (^)(NSProgress *progress))progress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                                 finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                                  from:(nullable NSDictionary *)data
                              progress:(nullable void (^)(NSProgress *progress))progress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                                finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish;

- (nullable NSURLSessionDataTask *)DELETE:(NSString *)URLString
                                     from:(nullable NSDictionary *)data
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                                   finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish;

@end

NS_ASSUME_NONNULL_END
