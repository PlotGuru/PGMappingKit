//
//  NSMutableDictionary+PGSafeCheck.h
//  PGMappingKit
//
//  Created by Justin Jia on 7/15/15.
//  Copyright (c) 2015 Plot Guru. All rights reserved.
//

@import Foundation;

@interface NSMutableDictionary (PGSafeCheck)

- (void)setObjectIfExists:(id)anObject forKey:(id<NSCopying>)aKey;

@end
