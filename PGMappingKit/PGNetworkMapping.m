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

#import "PGNetworkMapping.h"

@interface PGNetworkMapping ()

@property (strong, nonatomic) NSString *entityName;
@property (strong, nonatomic) NSString *mappedKey;

@property (strong, nonatomic) NSString *uniqueIdentifierKey;
@property (strong, nonatomic) NSString *mappedUniqueIdentifierKey;

@property (strong, nonatomic) NSMutableDictionary *mapping;

@end

@implementation PGNetworkMapping

+ (instancetype)mappingFromDescription:(NSArray *)entityArray mapping:(NSDictionary *)mappingDictionary
{
    return [[self alloc] initWithDescription:entityArray mapping:mappingDictionary];
}

- (instancetype)init
{
    return [self initWithDescription:nil mapping:nil];
}

- (instancetype)initWithDescription:(NSArray *)entityArray mapping:(NSDictionary *)mappingDictionary
{
    self = [super init];

    if (self) {
        if ([entityArray.firstObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *firstObject = entityArray.firstObject;
            self.mappedKey = firstObject.allKeys.firstObject;
            self.entityName = firstObject.allValues.firstObject;
        }

        if ([entityArray.lastObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *lastObject = entityArray.lastObject;
            self.mappedUniqueIdentifierKey = lastObject.allKeys.firstObject;
            self.uniqueIdentifierKey = lastObject.allValues.firstObject;
        }

        if (self.mappedUniqueIdentifierKey) {
            self.mapping[self.mappedUniqueIdentifierKey] = self.uniqueIdentifierKey;
        }

        for (NSString *key in mappingDictionary.allKeys) {
            self.mapping[key] = mappingDictionary[key];
        }
    }

    return self;
}

- (id)mappingForKey:(NSString *)key
{
    return self.mapping.count ? self.mapping[key] : key;
}

- (NSString *)keyForMapping:(id)mapping
{
    return self.mapping.count ? [self.mapping allKeysForObject:mapping].firstObject : mapping;
}

#pragma mark - Setter & Getter Methods

- (NSMutableDictionary *)mapping
{
    if (!_mapping) {
        _mapping = [NSMutableDictionary dictionary];
    }

    return _mapping;
}

@end
