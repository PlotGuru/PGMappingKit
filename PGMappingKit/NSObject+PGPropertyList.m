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

#import "NSObject+PGPropertyList.h"

@implementation NSObject (PGPropertyList)

+ (NSDictionary *)propertiesOfObject:(id)object
{
    return [self propertiesOfClass:[object class]];
}

+ (NSDictionary *)propertiesOfClass:(Class)class
{
    return [self propertiesForHierarchyOfClass:class onDictionary:[NSMutableDictionary dictionary]];
}

+ (NSDictionary *)propertiesOfSubclass:(Class)class
{
    if (class == NULL) {
        return nil;
    }

    return [self propertiesForSubclass:class onDictionary:[NSMutableDictionary dictionary]];
}

+ (NSMutableDictionary *)propertiesForHierarchyOfClass:(Class)class onDictionary:(NSMutableDictionary *)properties
{
    if (class == NULL) {
        return nil;
    }

    if (class == [NSObject class]) {
        return properties;
    }

    [self propertiesForSubclass:class onDictionary:properties];

    return [self propertiesForHierarchyOfClass:[class superclass] onDictionary:properties];
}

+ (NSMutableDictionary *)propertiesForSubclass:(Class)class onDictionary:(NSMutableDictionary *)properties
{
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyList = class_copyPropertyList(class, &numberOfProperties);
    for (unsigned int i = 0; i < numberOfProperties; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyName = property_getName(property);
        if(propertyName) {
            const char *propertyType = getPropertyType(property);
            properties[@(propertyName)] = @(propertyType);
        }
    }
    free(propertyList);

    return properties;
}

static const char *getPropertyType(objc_property_t property)
{
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') { // C primitive type (search "Objective-C Property Attribute Description Examples" for examples)
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        } else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) { // Objective-C id type
            return "id";
        } else if (attribute[0] == 'T' && attribute[1] == '@') { // Another Objective-C id type
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

@end
