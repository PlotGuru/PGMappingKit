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

#import "PGNetworkHandler+PGCoreData.h"
#import "PGMappingDescription.h"
#import "NSManagedObjectContext+PGObject.h"
#import "NSManagedObjectContext+PGMapping.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGNetworkHandler (PGCoreDataInternal)

- (void)succeedWithTask:(NSURLSessionDataTask *)task
         responseObject:(nullable id)responseObject
                context:(NSManagedObjectContext *)context
                mapping:(PGMappingDescription *)mapping
                 option:(PGSaveOption)option
                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end

@implementation PGNetworkHandler (PGCoreDataInternal)

- (void)succeedWithTask:(NSURLSessionDataTask *)task
         responseObject:(nullable id)responseObject
                context:(NSManagedObjectContext *)context
                mapping:(PGMappingDescription *)mapping
                 option:(PGSaveOption)option
                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSError *error = nil;
    
    if (option == PGSaveOptionReplaceAll) {
        NSArray *oldObjects = [context objectsWithMapping:mapping error:&error];
        
        for (NSManagedObject *oldObject in oldObjects) {
            [context deleteObject:oldObject];
        }
    }
    
    [context save:&error];
    
    NSMutableArray *results = [NSMutableArray array];
    
    NSArray *responseArray = [responseObject isKindOfClass:[NSArray class]] ? responseObject : (responseObject ? @[responseObject] : nil);
    for (id responseArrayItem in responseArray) {
        if ([responseArrayItem isKindOfClass:[NSDictionary class]]) {
            if (option == PGSaveOptionReplace) {
                NSManagedObject *object = [context objectWithMapping:mapping data:responseArrayItem error:&error];
                if (object) {
                    [context deleteObject:object];
                }
            }
            [results addObject:[context save:mapping.localName with:responseArrayItem description:mapping error:&error]];
        }
    }
    
    [context save:&error];
    
    if (!error) {
        if (success) {
            success(task, results.copy);
        }
    } else {
        if (failure) {
            failure(task, error);
        }
    }
}

@end

@implementation PGNetworkHandler (PGCoreData)

- (nullable NSURLSessionDataTask *)PUT:(NSString *)URLString
                                  from:(nullable NSDictionary *)data
                                    to:(NSManagedObjectContext *)context
                               mapping:(PGMappingDescription *)mapping
                                option:(PGSaveOption)option
                               success:(nullable void (^)(NSURLSessionDataTask *task, NSArray *results))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                                finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish
{
    return [self PUT:URLString from:data success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self succeedWithTask:task responseObject:responseObject context:context mapping:mapping option:option success:success failure:failure];
    } failure:failure finish:finish];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                                   from:(nullable NSDictionary *)data
                                     to:(NSManagedObjectContext *)context
                                mapping:(PGMappingDescription *)mapping
                                 option:(PGSaveOption)option
                               progress:(nullable void (^)(NSProgress *progress))progress
                                success:(nullable void (^)(NSURLSessionDataTask *task, NSArray *results))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                                 finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish
{
    return [self POST:URLString from:data progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self succeedWithTask:task responseObject:responseObject context:context mapping:mapping option:option success:success failure:failure];
    } failure:failure finish:finish];
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                                  from:(nullable NSDictionary *)data
                                    to:(NSManagedObjectContext *)context
                               mapping:(PGMappingDescription *)mapping
                                option:(PGSaveOption)option
                              progress:(nullable void (^)(NSProgress *progress))progress
                               success:(nullable void (^)(NSURLSessionDataTask *task, NSArray *results))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                                finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish
{
    return [self GET:URLString from:data progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self succeedWithTask:task responseObject:responseObject context:context mapping:mapping option:option success:success failure:failure];
    } failure:failure finish:finish];
}

- (nullable NSURLSessionDataTask *)DELETE:(NSString *)URLString
                                     from:(nullable NSDictionary *)data
                                       to:(NSManagedObjectContext *)context
                                  mapping:(PGMappingDescription *)mapping
                                   option:(PGSaveOption)option
                                  success:(nullable void (^)(NSURLSessionDataTask *task, NSArray *results))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
                                   finish:(nullable void (^)(NSURLSessionDataTask * _Nullable task))finish
{
    return [self DELETE:URLString from:data success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self succeedWithTask:task responseObject:responseObject context:context mapping:mapping option:option success:success failure:failure];
    } failure:failure finish:finish];
}

@end

NS_ASSUME_NONNULL_END
