//
//  PGNetworkMapping.m
//  PlotGuru
//
//  Created by Justin Jia on 7/16/15.
//  Copyright (c) 2015 Plot Guru. All rights reserved.
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
