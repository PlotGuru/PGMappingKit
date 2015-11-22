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

@import Foundation;
@import CoreData;

#import "PGNetworkMapping.h"
#import "NSObject+PGPropertyName.h"
#import "NSManagedObjectContext+PGObject.h"
#import "NSManagedObjectContext+PGNetworkMapping.h"

typedef NS_ENUM(NSInteger, PGSaveMethod) {
    PGSaveMethodUpdate,
    PGSaveMethodReplace,
    PGSaveMethodReplaceAll,
};

@interface PGNetworkHandler : NSObject

@property (strong, nonatomic, readonly) NSURL *baseURL;
@property (nonatomic, getter=isCanceled) BOOL canceled;

- (instancetype)initWithBaseURL:(NSURL *)baseURL NS_DESIGNATED_INITIALIZER;

- (NSMutableDictionary *)dataFromObject:(id)object mapping:(PGNetworkMapping *)mapping;

- (void)POST:(NSString *)URLString from:(id)object mapping:(PGNetworkMapping *)mapping success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)POST:(NSString *)URLString from:(NSDictionary *)data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)PUT:(NSString *)URLString from:(id)object mapping:(PGNetworkMapping *)mapping success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)PUT:(NSString *)URLString from:(NSDictionary *)data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)GET:(NSString *)URLString to:(NSManagedObjectContext *)context mapping:(PGNetworkMapping *)mapping update:(PGSaveMethod)saveMethod success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)GET:(NSString *)URLString success:(void (^)(id results))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username password:(NSString *)password;
- (void)clearAuthorizationHeader;

@end
