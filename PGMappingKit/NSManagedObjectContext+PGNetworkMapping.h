//
//  NSManagedObjectContext+PGNetworkMapping.h
//  PlotGuru
//
//  Created by Justin Jia on 7/16/15.
//  Copyright (c) 2015 Plot Guru. All rights reserved.
//

@import CoreData;

#import "PGNetworkMapping.h"

@interface NSManagedObjectContext (PGNetworkMapping)

- (id)save:(NSString *)type with:(NSDictionary *)data mapping:(PGNetworkMapping *)mapping error:(NSError *__autoreleasing *)error;
- (id)save:(NSDictionary *)data to:(id)object mapping:(PGNetworkMapping *)mapping error:(NSError *__autoreleasing *)error;

@end
