//
//  NSObject+PGKeyValueCoding.m
//  PlotGuru
//
//  Created by Justin Jia on 7/17/15.
//  Copyright (c) 2015 Plot Guru. All rights reserved.
//

#import "NSObject+PGKeyValueCoding.h"

@implementation NSObject (PGKeyValueCoding)

- (void)safelySetValue:(id)value forKey:(NSString *)key
{
    if ([self respondsToSelector:NSSelectorFromString(key)]) {
        [self setValue:value forKey:key];
    }
}

- (void)safelyAddValue:(id)value forKey:(NSString *)key
{
    if ([self respondsToSelector:NSSelectorFromString(key)]) {
        id newValue = [[self valueForKey:key] mutableCopy];
        [newValue addObject:value];
        [self setValue:newValue forKey:key];
    }
}

@end
