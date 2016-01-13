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

NS_ASSUME_NONNULL_BEGIN

/**
 *  `PGMappingDescription` is used to describe the relationship between a Core Data entity and its related JSON response. It supports one-way nested mapping description.
 */
@interface PGMappingDescription : NSObject

/**
 *  The name of the represented entity.
 */
@property (strong, nonatomic, readonly) NSString *localName;

/**
 *  The outmost key of the represented JSON response. Will be ignored if this `PGMappingDescription` is not nested.
 */
@property (strong, nonatomic, readonly) NSString *remoteName;

/**
 *  The unique ID key of the represented entity.
 */
@property (strong, nonatomic, readonly) NSString *localIDKey;

/**
 *  The unique ID key of the represented JSON response.
 */
@property (strong, nonatomic, readonly) NSString *remoteIDKey;

/**
 *  Creates and returns a `PGMappingDescription` object.
 *
 *  @param names A dictionary with only one value. Key is the outmost key of the represented JSON response and value is the name of the represented entity.
 *  @param IDs A dictionary with only one value. Key is the unique ID key of the represented JSON response and value is the unique ID key of the represented entity.
 *  @param mapping The relationship between the represented entity and JSON response. Keys are keys of the represented JSON reponse and values are attributes' names of the represented entity. Don't need to include `localIDKey` and `remoteIDKey` again.
 *
 *  @return Created `PGMappingDescription` object.
 */
+ (instancetype)name:(NSDictionary *)names ID:(NSDictionary *)IDs mapping:(NSDictionary *)mapping;

/**
 *  Creates and returns a `PGMappingDescription` object.
 *
 *  @param localName The name of the represented entity.
 *  @param remoteName The outmost key of the represented JSON response.
 *  @param localIDKey The unique ID key of the represented entity.
 *  @param remoteIDKey The unique ID key of the represented JSON response.
 *  @param mapping The relationship between the represented entity and JSON response. Keys are keys of the represented JSON reponse and values are attributes' names of the represented entity. Don't need to include `localIDKey` and `remoteIDKey` again.
 *
 *  @return Created `PGMappingDescription` object.
 */
- (instancetype)initWithLocalName:(NSString *)localName
                       remoteName:(NSString *)remoteName
                       localIDKey:(NSString *)localIDKey
                      remoteIDKey:(NSString *)remoteIDKey
                          mapping:(NSDictionary *)mapping NS_DESIGNATED_INITIALIZER;

/**
 *  Returns an attribute's name or another `PGMappingDescription` object.
 *
 *  @param remoteKey A key in the represented JSON response.
 *
 *  @return An attribute's name in the represented entity or another `PGMappingDescription` object. Will return the input is nothing is found.
 */
- (id)localKeyForRemoteKey:(NSString *)remoteKey;

/**
 *  Returns a key.
 *
 *  @param localKey An attribute's name in the represented entity or another `PGMappingDescription` object.
 *
 *  @return A key in the represented JSON response or another `PGMappingDescription` object. Will return the input if nothing is found.
 */
- (NSString *)remoteKeyForLocalKey:(id)localKey;

@end

NS_ASSUME_NONNULL_END
