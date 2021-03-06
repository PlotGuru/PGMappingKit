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

#import "NSManagedObjectContext+PGObject.h"
#import "PGMappingDescription.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSManagedObjectContext (PGObject)

- (nullable id)objectWithType:(NSString *)type identifier:(nullable id)identifier forKey:(NSString *)key error:(NSError **)error
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:type];

    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, identifier];

    return [self executeFetchRequest:fetchRequest error:error].firstObject;
}

- (nullable NSArray *)objectsWithType:(NSString *)type error:(NSError **)error
{
    return [self executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:type] error:error];
}

- (nullable id)objectWithMapping:(PGMappingDescription *)mapping data:(nullable NSDictionary *)data error:(NSError **)error
{
    return [self objectWithType:mapping.localName identifier:data ? data[mapping.remoteIDKey] : nil forKey:mapping.localIDKey error:error];
}

- (nullable id)objectWithMapping:(PGMappingDescription *)mapping identifier:(nullable id)identifier error:(NSError **)error
{
    return [self objectWithType:mapping.localName identifier:identifier forKey:mapping.remoteIDKey error:error];
}

- (nullable NSArray *)objectsWithMapping:(PGMappingDescription *)mapping error:(NSError **)error
{
    return [self objectsWithType:mapping.localName error:error];
}

@end

NS_ASSUME_NONNULL_END
