//
//  NSManagedObjectContext+PGNetworkMapping.m
//  PlotGuru
//
//  Created by Justin Jia on 7/16/15.
//  Copyright (c) 2015 Plot Guru. All rights reserved.
//

#import "NSManagedObjectContext+PGNetworkMapping.h"
#import "NSObject+PGKeyValueCoding.h"

@implementation NSManagedObjectContext (PGNetworkMapping)

- (id)save:(NSString *)type with:(NSDictionary *)data mapping:(PGNetworkMapping *)mapping error:(NSError *__autoreleasing *)error
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:type];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", mapping.uniqueIdentifierKey, data[mapping.mappedUniqueIdentifierKey]];

    NSManagedObject *object = [self executeFetchRequest:fetchRequest error:error].firstObject;

    if (!object) {
        object = [NSEntityDescription insertNewObjectForEntityForName:type inManagedObjectContext:self];
    }

    return [self save:data to:object mapping:mapping error:error];
}

- (id)save:(NSDictionary *)data to:(id)object mapping:(PGNetworkMapping *)mapping error:(NSError *__autoreleasing *)error
{
    if (!object) {
        *error = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:1 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"The operation couldn't be completed.", nil)}];
        return nil;
    }

    for (NSString *key in data.allKeys) {
        id mappedKey = [mapping mappingForKey:key];
        id value = data[key];

        if ([mappedKey isKindOfClass:[PGNetworkMapping class]]) {
            PGNetworkMapping *mappedMapping = mappedKey;

            if ([value isKindOfClass:[NSDictionary class]]) {
                [object safelySetValue:[self save:mappedMapping.entityName with:value mapping:mappedMapping error:error] forKey:mappedMapping.mappedKey];
            } else if ([value isKindOfClass:[NSArray class]]) {
                NSArray *dataArray = value;
                for (id data in dataArray) {
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        [object safelyAddValue:[self save:mappedMapping.entityName with:data mapping:mappedMapping error:error] forKey:mappedMapping.mappedKey];
                    }
                }
            } else {
                NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:mappedMapping.entityName];
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", mappedMapping.uniqueIdentifierKey, value];

                NSManagedObject *relatedObject = [self executeFetchRequest:fetchRequest error:error].firstObject;
                [object safelySetValue:relatedObject forKey:mappedMapping.mappedKey];
            }
        } else if ([mappedKey isKindOfClass:[NSString class]]) {
            [object safelySetValue:value forKey:mappedKey];
        }
    }
    
    return object;
}

@end
