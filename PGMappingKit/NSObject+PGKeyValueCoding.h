//
//  NSObject+PGKeyValueCoding.h
//  PlotGuru
//
//  Created by Justin Jia on 7/17/15.
//  Copyright (c) 2015 Plot Guru. All rights reserved.
//

@import Foundation;

@interface NSObject (PGKeyValueCoding)

- (void)safelySetValue:(id)value forKey:(NSString *)key;
- (void)safelyAddValue:(id)value forKey:(NSString *)key;

@end
