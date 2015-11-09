//
//  NSObject+PGPropertyList.h
//  PlotGuru
//
//  Created by Justin Jia on 9/7/15.
//  Copyright (c) 2015 Plot Guru. All rights reserved.
//

@import Foundation;
@import ObjectiveC.runtime;

@interface NSObject (PGPropertyList)

+ (NSDictionary *)propertiesOfObject:(id)object;
+ (NSDictionary *)propertiesOfClass:(Class)class;
+ (NSDictionary *)propertiesOfSubclass:(Class)class;

@end
