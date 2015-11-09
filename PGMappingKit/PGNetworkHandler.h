//
//  PGNetworkHandler.h
//  PGMappingKit
//
//  Created by Justin Jia on 7/23/15.
//  Copyright (c) 2015 Plot Guru. All rights reserved.
//

#import "NSManagedObjectContext+PGNetworkMapping.h"

@interface PGNetworkHandler : NSObject

@property (strong, nonatomic, readonly) NSURL *baseURL;
@property (nonatomic, getter=isCanceled) BOOL canceled;

- (instancetype)initWithBaseURL:(NSURL *)baseURL NS_DESIGNATED_INITIALIZER;

- (NSMutableDictionary *)dataFromObject:(id)object mapping:(PGNetworkMapping *)mapping;

- (void)POST:(NSString *)URLString from:(id)object mapping:(PGNetworkMapping *)mapping success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)POST:(NSString *)URLString from:(NSDictionary *)data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)PUT:(NSString *)URLString from:(id)object mapping:(PGNetworkMapping *)mapping success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)PUT:(NSString *)URLString from:(NSDictionary *)data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)GET:(NSString *)URLString to:(NSManagedObjectContext *)context mapping:(PGNetworkMapping *)mapping success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)GET:(NSString *)URLString success:(void (^)(id results))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username password:(NSString *)password;
- (void)clearAuthorizationHeader;

@end
