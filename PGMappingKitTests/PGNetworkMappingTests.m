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

@import XCTest;

#import "PGMappingDescription.h"

@interface PGMappingDescriptionTests : XCTestCase

@property (strong, nonatomic) NSArray *userInfoDescriptionArray;
@property (strong, nonatomic) NSDictionary *userInfoMappingDictionary;

@property (strong, nonatomic) NSString *userInfoEntityName;
@property (strong, nonatomic) NSString *userInfoMappedKey;

@property (strong, nonatomic) NSString *userInfoUniqueIdentifierKey;
@property (strong, nonatomic) NSString *userInfoMappedUniqueIdentifierKey;

@property (strong, nonatomic) NSString *imageURLAttributeName;
@property (strong, nonatomic) NSString *imageURLKey;

@property (strong, nonatomic) NSString *usernameAttributeName;
@property (strong, nonatomic) NSString *usernameKey;

@end

@implementation PGMappingDescriptionTests

- (void)setUp
{
    [super setUp];

    self.userInfoEntityName = @"PGUserInfo";
    self.userInfoMappedKey = @"user_info";

    self.userInfoUniqueIdentifierKey = @"uniqueID";
    self.userInfoMappedUniqueIdentifierKey = @"id";

    self.imageURLAttributeName = @"imageURL";
    self.imageURLKey = @"image_url";

    self.usernameAttributeName = @"username";
    self.usernameKey = @"username";

    self.userInfoDescriptionArray = @[@{self.userInfoMappedKey: self.userInfoEntityName}, @{self.userInfoMappedUniqueIdentifierKey: self.userInfoUniqueIdentifierKey}];
    self.userInfoMappingDictionary = @{self.imageURLKey: self.imageURLAttributeName, self.usernameKey: self.usernameAttributeName};
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInit
{
    PGMappingDescription *mappingA = [PGMappingDescription mappingFromDescription:self.userInfoDescriptionArray description:self.userInfoMappingDictionary];
    PGMappingDescription *mappingB = [[PGMappingDescription alloc] initWithDescription:self.userInfoDescriptionArray description:self.userInfoMappingDictionary];

    XCTAssertEqualObjects(mappingA.entityName, mappingB.entityName);
    XCTAssertEqualObjects(mappingA.mappedKey, mappingB.mappedKey);
    XCTAssertEqualObjects(mappingA.uniqueIdentifierKey, mappingB.uniqueIdentifierKey);
    XCTAssertEqualObjects(mappingA.mappedUniqueIdentifierKey, mappingB.mappedUniqueIdentifierKey);
    XCTAssertEqualObjects([mappingA mappingForKey:self.imageURLKey], [mappingB mappingForKey:self.imageURLKey]);
    XCTAssertEqualObjects([mappingA mappingForKey:self.usernameKey], [mappingB mappingForKey:self.usernameKey]);

    XCTAssertNoThrow([PGMappingDescription mappingFromDescription:nil description:nil]);
    XCTAssertNoThrow([PGMappingDescription new]);
}

- (void)testSimpleMapping
{
    PGMappingDescription *mapping = [PGMappingDescription mappingFromDescription:self.userInfoDescriptionArray description:self.userInfoMappingDictionary];

    XCTAssertEqualObjects(mapping.entityName, self.userInfoEntityName);
    XCTAssertEqualObjects(mapping.mappedKey, self.userInfoMappedKey);
    XCTAssertEqualObjects(mapping.uniqueIdentifierKey, self.userInfoUniqueIdentifierKey);
    XCTAssertEqualObjects(mapping.mappedUniqueIdentifierKey, self.userInfoMappedUniqueIdentifierKey);

    XCTAssertEqualObjects([mapping mappingForKey:self.imageURLKey], self.imageURLAttributeName, @"Attribute name and the key are different.");
    XCTAssertEqualObjects([mapping mappingForKey:self.usernameKey], self.usernameAttributeName, @"Attribute name and the key are the same.");
    XCTAssertEqualObjects([mapping mappingForKey:self.userInfoMappedUniqueIdentifierKey], self.userInfoUniqueIdentifierKey, @"Mapped unique identifier is the key.");

    XCTAssertNil([mapping mappingForKey:self.imageURLAttributeName], @"Use attribute's name as the key.");
    XCTAssertNil([mapping mappingForKey:nil], @"No key is specified.");
}

- (void)testNestedMapping
{
    PGMappingDescription *userInfoMapping = [PGMappingDescription mappingFromDescription:self.userInfoDescriptionArray description:self.userInfoMappingDictionary];
    PGMappingDescription *userListMapping = [PGMappingDescription mappingFromDescription:@[@{@"user_lists": @"PGUserList"}, @{@"list_id": @"listID"}] description:@{@"list_name": @"listName", @"users": userInfoMapping}];

    XCTAssertEqualObjects(userListMapping.entityName, @"PGUserList");

    XCTAssertEqualObjects([userListMapping mappingForKey:@"users"], userInfoMapping);
    XCTAssertEqualObjects([userListMapping mappingForKey:@"list_id"], @"listID");

    XCTAssertNil([userListMapping mappingForKey:self.usernameKey], @"Use one of user info mapping's key.");
}

@end
