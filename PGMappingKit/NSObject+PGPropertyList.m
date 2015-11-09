//
//  NSObject+PGPropertyList.m
//  PlotGuru
//
//  Created by Justin Jia on 9/7/15.
//  Copyright (c) 2015 Plot Guru. All rights reserved.
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
