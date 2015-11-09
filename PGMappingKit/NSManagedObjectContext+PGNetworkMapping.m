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
