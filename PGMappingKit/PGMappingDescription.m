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

#import "PGMappingDescription.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGMappingDescription ()

@property (strong, nonatomic) NSString *localName;

@property (strong, nonatomic) NSString *remoteName;

@property (strong, nonatomic) NSString *localIDKey;

@property (strong, nonatomic) NSString *remoteIDKey;

@property (strong, nonatomic) NSMutableDictionary *mapping;

@end

@implementation PGMappingDescription

+ (instancetype)name:(NSDictionary *)names ID:(NSDictionary *)IDs mapping:(NSDictionary *)mapping
{
    return [[self alloc] initWithLocalName:names.allValues.firstObject ?: @""
                                remoteName:names.allKeys.firstObject ?: @""
                                localIDKey:IDs.allValues.firstObject ?: @""
                               remoteIDKey:IDs.allKeys.firstObject ?: @""
                                   mapping:mapping];
}

- (instancetype)init
{
    return [self initWithLocalName:@"" remoteName:@"" localIDKey:@"" remoteIDKey:@"" mapping:@{}];
}

- (instancetype)initWithLocalName:(NSString *)localName
                       remoteName:(NSString *)remoteName
                       localIDKey:(NSString *)localIDKey
                      remoteIDKey:(NSString *)remoteIDKey
                          mapping:(NSDictionary *)mapping
{
    self = [super init];
    if (self) {
        self.localName = localName;
        self.remoteName = remoteName;
        self.localIDKey = localIDKey;
        self.remoteIDKey = remoteIDKey;

        self.mapping = mapping.mutableCopy;
        self.mapping[remoteIDKey] = localIDKey;
    }
    return self;
}

- (id)localKeyForRemoteKey:(NSString *)remoteKey;
{
    return self.mapping[remoteKey] ?: remoteKey;
}

- (NSString *)remoteKeyForLocalKey:(id)localKey
{
    return [self.mapping allKeysForObject:localKey].firstObject ?: localKey;
}

@end

NS_ASSUME_NONNULL_END
