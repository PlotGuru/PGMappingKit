//
//  NSMutableDictionary+PGSafeCheck.m
//  PGMappingKit
//
//  Created by Justin Jia on 7/15/15.
//  Copyright (c) 2015 Plot Guru. All rights reserved.
//

#import "NSMutableDictionary+PGSafeCheck.h"

@implementation NSMutableDictionary (PGSafeCheck)

- (void)setObjectIfExists:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject && aKey) {
        self[aKey] = anObject;
    } else if (aKey) {
        [self removeObjectForKey:aKey];
    }
}

@end
