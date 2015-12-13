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

/**
 *  `PGMappingDescription` can be used to describe the relationship between a Core Data entity and its related data. It also support nested mapping and can work with `NSManagedObjectContext+PGSaveWithMapping.h` category to save any data into a Core Data database without the need to manually write any custom saving methods.
 */
@interface PGMappingDescription : NSObject

/**
 *  The name for the Core Data entity.
 */
@property (strong, nonatomic, readonly) NSString *entityName;

/**
 *  The mapped key for the Core Data entity used in nested mapping.
 */
@property (strong, nonatomic, readonly) NSString *mappedKey;

/**
 *  The unique identifier attribute's name for the Core Data entity.
 */
@property (strong, nonatomic, readonly) NSString *uniqueIdentifierKey;

/**
 *  The mapped unique identifier key for the Core Data entity.
 */
@property (strong, nonatomic, readonly) NSString *mappedUniqueIdentifierKey;

/**
 *  Creates and returns a `PGMappingDescription` object.
 *
 *  @param entityArray It is used to specify entity information. It should contain two dictionaries. The first dictionary is used to define `entityName` and `mappedKey` properties where `mappedKey` is the key and `entityName` is the object. The second dictionary is used to define `uniqueIdentifierKey` and and `mappedUniqueIdentifierKey` properties where `mappedUniqueIdentifierKey` is the key and `uniqueIdentifierKey` is the object. They don't need to be included again in `mappingDictionary`. Example: `@[@{@"user_infos": @"userInfo"}, @{@"id": @"uniqueID"}]`
 *  @param mappingDictionary It is used to create the mapping relationships between attributes and their related data where data's keys are keys and attributes' names are objects. Example: `@{@"first_name": @"firstName", @"image_url": @"imageURL"}` When nil is passed in, `mappingForKey:` will always return the key,
 *
 *  @return Created `PGMappingDescription` object.
 */
+ (instancetype)mappingFromDescription:(NSArray *)entityArray description:(NSDictionary *)mappingDictionary;

/**
 *  Creates and returns a `PGMappingDescription` object.
 *
 *  @param entityArray It is used to specify entity information. It should contain two dictionaries. The first dictionary is used to define `entityName` and `mappedKey` properties where `mappedKey` is the key and `entityName` is the object. The second dictionary is used to define `uniqueIdentifierKey` and and `mappedUniqueIdentifierKey` properties where `mappedUniqueIdentifierKey` is the key and `uniqueIdentifierKey` is the object. They don't need to be included again in `mappingDictionary`. Example: `@[@{@"user_infos": @"userInfo"}, @{@"id": @"uniqueID"}]`
 *  @param mappingDictionary It is used to create the mapping relationships between attributes and their related data where data's keys are keys and attributes' names are objects. Example: `@{@"first_name": @"firstName", @"image_url": @"imageURL"}` When nil is passed in, `mappingForKey:` will always return the key,
 *
 *  @return Created `PGMappingDescription` object.
 */
- (instancetype)initWithDescription:(NSArray *)entityArray description:(NSDictionary *)mappingDictionary NS_DESIGNATED_INITIALIZER;

/**
 *  Returns a attribute's name or another `PGMappingDescription` object if is nested.
 *
 *  @param key The key used to represent the attribute.
 *
 *  @return The attribute's name or another `PGMappingDescription` object (if nested) represented by the key. Will return `nil` if no value is represented by the key.
 */
- (id)mappingForKey:(NSString *)key;

/**
 *  Returns a key.
 *
 *  @param mapping The attribute's name or another `PGMappingDescription` object if is nested.
 *
 *  @return The key represents the attribute or another `PGMappingDescription` object (if nested). Will return `nil` if no key represents the value.
 */
- (NSString *)keyForMapping:(id)mapping;

@end
