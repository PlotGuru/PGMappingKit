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

typedef NS_ENUM(NSInteger, PGSaveOption) {
    PGSaveOptionUpdate,
    PGSaveOptionReplace,
    PGSaveOptionReplaceAll,
};

@interface PGNetworkHandler : NSObject

/**
 * baseURL is the name for the URL related to the request
 */
@property (strong, nonatomic, readonly) NSURL *baseURL;

/**
 *  determine whether the request is canceled or not
 */
@property (nonatomic, getter=isCanceled) BOOL canceled;

/**
 *  intialize the object with the baseURL
 */
- (instancetype)initWithBaseURL:(NSURL *)baseURL NS_DESIGNATED_INITIALIZER;

/**
 *  instance method dataFromObject maps the object with 'PGNetworkMapping' and stores the data in a dictionary and returns the data.
 */
- (NSMutableDictionary *)dataFromObject:(id)object mapping:(PGNetworkMapping *)mapping;

/**
 *  HTTP Method to create
 */
- (void)POST:(NSString *)URLString from:(id)object mapping:(PGNetworkMapping *)mapping success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)POST:(NSString *)URLString from:(NSDictionary *)data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

/**
 *  HTTP Method to update
 */
- (void)PUT:(NSString *)URLString from:(id)object mapping:(PGNetworkMapping *)mapping success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)PUT:(NSString *)URLString from:(NSDictionary *)data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

/**
 *  HTTP Method to read for RESTful services
 */
- (void)GET:(NSString *)URLString to:(NSManagedObjectContext *)context mapping:(PGNetworkMapping *)mapping option:(PGSaveOption)saveOption success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

- (void)GET:(NSString *)URLString success:(void (^)(id results))success failure:(void (^)(NSError *error))failure finish:(void (^)())finish;

/**
 *  HTTP Method to delete for RESTful services
 * 404 (Not Found), unless you want to delete the whole collection—not often desirable.	
 
 -(void)DELETE:(NSString *)URLString from:(id)object mapping:(PGNetworkMapping *)mapping success:(void (^)(id responseObject))sucess failure:(void (^)(NSError *error))failure finish:(void (^)())finish;
 */

/**
 *  This method handles the authorization of the user
 */
- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username password:(NSString *)password;
- (void)clearAuthorizationHeader;

@end
