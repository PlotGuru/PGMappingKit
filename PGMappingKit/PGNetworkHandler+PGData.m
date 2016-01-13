//
//  PGNetworkHandler+PGData.m
//  PGMappingKit
//
//  Created by Justin Jia on 1/13/16.
//  Copyright © 2016 Plot Guru. All rights reserved.
//

#import "PGNetworkHandler+PGData.h"
#import "PGMappingDescription.h"
#import "NSMutableDictionary+PGSafeCheck.h"
#import "NSObject+PGPropertyList.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PGNetworkHandler (PGData)

- (NSMutableDictionary *)dataFromObject:(nullable id)object mapping:(PGMappingDescription *)mapping;
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    NSDictionary *properties = [NSObject propertiesOfObject:object];
    for (NSString *propertyName in properties.allKeys) {
        NSString *key = [mapping keyForMapping:propertyName];
        [data setObjectIfExists:[object valueForKey:propertyName] forKey:key];
    }
    
    return data;
}

@end

NS_ASSUME_NONNULL_END
