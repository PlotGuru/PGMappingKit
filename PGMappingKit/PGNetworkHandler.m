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

#import "PGNetworkHandler.h"
#import "NSObject+PGPropertyList.h"
#import "NSMutableDictionary+PGSafeCheck.h"

@interface PGNetworkHandler ()

@property (strong, nonatomic) NSURL *baseURL;
@property (strong, nonatomic, readonly, nonnull) AFHTTPSessionManager *sessionManager;

@end

@implementation PGNetworkHandler

#pragma mark - Init Methods

- (instancetype)init
{
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        self.baseURL = baseURL;
    }
    return self;
}

#pragma mark - POST

- (NSMutableDictionary *)dataFromObject:(id)object mapping:(PGNetworkMapping *)mapping
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];

    NSDictionary *properties = [NSObject propertiesOfObject:object];
    for (NSString *propertyName in properties.allKeys) {
        NSString *key = [mapping keyForMapping:propertyName];
        [data setObjectIfExists:[object valueForKey:propertyName] forKey:key];
    }

    return data;
}

- (void)POST:(NSString *)URLString from:(id)object mapping:(PGNetworkMapping *)mapping success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish
{
    [self POST:URLString from:[self dataFromObject:object mapping:mapping] success:success failure:failure finish:finish];
}

- (void)POST:(NSString *)URLString from:(NSDictionary *)data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish
{
    [self.sessionManager POST:URLString parameters:data progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(responseObject);
            }
            
            if (finish) {
                finish();
            }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (failure) {
                failure(error);
            }
            
            if (finish) {
                finish();
            }
        }];
    }];
}

#pragma mark - PUT

- (void)PUT:(NSString *)URLString from:(id)object mapping:(PGNetworkMapping *)mapping success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish
{
    [self PUT:URLString from:[self dataFromObject:object mapping:mapping] success:success failure:failure finish:finish];
}

- (void)PUT:(NSString *)URLString from:(NSDictionary *)data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish
{
    [self.sessionManager PUT:URLString parameters:data success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(responseObject);
            }
            
            if (finish) {
                finish();
            }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (failure) {
                failure(error);
            }
            
            if (finish) {
                finish();
            }
        }];
    }];
}

#pragma mark - GET

- (void)GET:(NSString *)URLString to:(NSManagedObjectContext *)context mapping:(PGNetworkMapping *)mapping option:(PGSaveOption)saveOption success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish
{
    [self.sessionManager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.isCanceled) {
            return;
        }
        
        NSError *error = nil;
        
        if (saveOption == PGSaveOptionReplaceAll) {
            NSArray *oldObjects = [context objectsWithMapping:mapping error:&error];
            if (oldObjects && oldObjects.count) {
                for (NSManagedObject *oldObject in oldObjects) {
                    [context deleteObject:oldObject];
                }
                
                [context save:&error];
            }
        }
        
        NSArray *responseArray = [responseObject isKindOfClass:[NSArray class]] ? responseObject : (responseObject ? @[responseObject] : nil);
        NSMutableArray *results = [NSMutableArray array];
        for (id responseArrayItem in responseArray) {
            if ([responseArrayItem isKindOfClass:[NSDictionary class]]) {
                if (saveOption == PGSaveOptionReplace) {
                    NSManagedObject *object = [context objectWithMapping:mapping data:responseArrayItem error:&error];
                    if (object) {
                        [context deleteObject:object];
                    }
                }
                [results addObject:[context save:mapping.entityName with:responseArrayItem mapping:mapping error:&error]];
            }
        }
        
        [context save:&error];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (!error) {
                if (success) {
                    success(results.copy);
                }
            } else {
                if (failure) {
                    failure(error);
                }
            }
            
            if (finish) {
                finish();
            }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.isCanceled) {
            return;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (failure) {
                failure(error);
            }
            
            if (finish) {
                finish();
            }
        }];
    }];
}

- (void)GET:(NSString *)URLString success:(void (^)(id results))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish
{
    [self.sessionManager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.isCanceled) {
            return;
        }

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(responseObject);
            }

            if (finish) {
                finish();
            }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.isCanceled) {
            return;
        }

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (failure) {
                failure(error);
            }

            if (finish) {
                finish();
            }
        }];
    }];
}

#pragma mark - Authorization Header Methods

- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username password:(NSString *)password
{
    [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
}

- (void)clearAuthorizationHeader
{
    [self.sessionManager.requestSerializer clearAuthorizationHeader];
}

#pragma mark - Setter & Getter Methods

@synthesize sessionManager = _sessionManager;

- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }

    return _sessionManager;
}

@end
