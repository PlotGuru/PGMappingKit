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

#import "NSManagedObjectContext+PGMapping.h"
#import "PGMappingDescription.h"
#import "NSObject+PGKeyValueCoding.h"

@implementation NSManagedObjectContext (PGMappingDescription)

- (id)save:(nullable NSDictionary *)data description:(PGMappingDescription *)mapping error:(NSError **)error
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:mapping.localName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", mapping.localIDKey, data[mapping.remoteIDKey]];

    NSManagedObject *object = [self executeFetchRequest:fetchRequest error:error].firstObject;

    if (!object) {
        object = [NSEntityDescription insertNewObjectForEntityForName:mapping.localName inManagedObjectContext:self];
    }

    return [self save:data to:object description:mapping error:error];
}

- (id)save:(nullable NSDictionary *)data to:(id)object description:(PGMappingDescription *)mapping error:(NSError **)error
{
    for (NSString *key in data.allKeys) {
        id remoteKey = [mapping localKeyForRemoteKey:key];
        id value = data[key];

        if ([remoteKey isKindOfClass:[PGMappingDescription class]]) {
            PGMappingDescription *mappedMapping = remoteKey;

            if ([value isKindOfClass:[NSDictionary class]]) {
                [object safelySetValue:[self save:value description:mappedMapping error:error] forKey:mappedMapping.remoteName];
            } else if ([value isKindOfClass:[NSArray class]]) {
                NSArray *dataArray = value;
                for (id data in dataArray) {
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        [object safelyAddValue:[self save:data description:mappedMapping error:error] forKey:mappedMapping.remoteName];
                    }
                }
            } else {
                NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:mappedMapping.localName];
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", mappedMapping.localIDKey, value];

                NSManagedObject *relatedObject = [self executeFetchRequest:fetchRequest error:error].firstObject;
                [object safelySetValue:relatedObject forKey:mappedMapping.remoteName];
            }
        } else if ([remoteKey isKindOfClass:[NSString class]]) {
            [object safelySetValue:value forKey:remoteKey];
        }
    }
    
    return object;
}

@end
