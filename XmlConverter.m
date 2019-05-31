//
//  XmlConverter.m
//  ConvertToXml
//


#import "XmlConverter.h"
#import "NSString+Array.h"

@implementation XmlConverter

NSString *const defaultXMLHeader = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
NSString *const defaultConainerTag = @"<container>%@</container>";
NSString * const closeTag = @"</%@>";
NSString * const openTag = @"<%@>";

/**
 Retruns dictionary each key is prohibited character and value is valid replacement
 */
+ (NSDictionary *)prohibitedCharacters {
    return @{@"<": @"&lt;", @">":@"&gt;", @"\"": @"&quot;", @"'": @"&apos;", @"&":@"&amp;"};
}

/**
 Returns xml data from json data
 Parameters:
 - jsonData: data of json
 - itemTag: name of tag for json array items
 */
+ (NSData *)getXmlDataFromJsonData:(NSData *)jsonData arrayItemTag:(NSString *)itemTag {
    return [[self getXmlStringFromJsonData:jsonData arrayItemTag:itemTag] dataUsingEncoding:kCFStringEncodingUTF8];
}

/**
 Returns converted XML string from json object
 - Parameters:
 - jsonData: data of json
 - itemTag: name of tag for json array items
 */
+ (NSString *)getXmlStringFromJsonData:(NSData *)jsonData arrayItemTag:(NSString *)itemTag {
    NSError *serializationError;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&serializationError];
    NSString *tempXmlString = @"";
    if (!serializationError) {
        tempXmlString = [self parseJsonToXml:json arrayItemTag:itemTag];
        if ([json isKindOfClass:[NSArray class]]) {
            tempXmlString = [NSString stringWithFormat:defaultConainerTag, tempXmlString];
        }
        tempXmlString = [defaultXMLHeader stringByAppendingString:tempXmlString];
    }
    return tempXmlString;
}

/**
 Returns parsed XML string from json object
 - Parameters:
 - object: any json object value
 - itemTag: name of tag for json array items
 */
+ (NSString *)parseJsonToXml:(id)object arrayItemTag:(NSString *)itemTag {
    NSString * tempXmlString = @"";
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)object;
        for (NSString *key in dictionary.allKeys) {
            if ([dictionary[key] isKindOfClass:[NSArray class]]) {
                NSArray *array = (NSArray *)dictionary[key];
                for (NSObject *item in array) {
                    tempXmlString = [self addXmlItemWithTag:key andObject:item];
                }
                continue;
            }
            tempXmlString = [tempXmlString stringByAppendingString:[self addXmlItemWithTag:key andObject:dictionary]];
        }
    } else if ([object isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)object;
        for (NSObject *object in array) {
            NSString *tag = @"item";
            if (itemTag) {
                tag = itemTag;
            }
            tempXmlString = [tempXmlString stringByAppendingString:[self addXmlItemWithTag:tag andObject:object]];
        }
    }
    return tempXmlString;
}

/**
 Add new xml item with tag name and object
 Parameters:
 - tag: tag name
 - object: xml object
 */
+ (NSString *)addXmlItemWithTag:(NSString *)tag andObject:(id)object {
    NSString *tempXmlString = @"";
    tempXmlString = [tempXmlString stringByAppendingString:[NSString stringWithFormat:openTag, tag]];
    if ([object isKindOfClass:[NSDictionary class]] && ([object[tag] isKindOfClass:[NSString class]] || [object[tag] isKindOfClass:[NSNumber class]])) {
        id validatedObject = [self validate:object[tag]];
        tempXmlString = [tempXmlString stringByAppendingString:[NSString stringWithFormat:@"%@", validatedObject]];
    } else {
        tempXmlString = [tempXmlString stringByAppendingString:[self parseJsonToXml:object arrayItemTag:tag]];
    }
    tempXmlString = [tempXmlString stringByAppendingString:[NSString stringWithFormat:closeTag, tag]];
    return tempXmlString;
}

/**
 Returns validated xml object. Replace prohibited characters
 Parameters:
 - object: xml object
 */
+ (id)validate:(id)object {
    id filteredObject = object;
    if ([filteredObject isKindOfClass: [NSString class]]) {
        NSString *stringObject = (NSString *)filteredObject;
        NSArray *stringArray = [stringObject arrayFromString];
        NSMutableArray *updatedStringArray = [NSMutableArray array];
        for (NSString *letter in stringArray) {
            NSString *replacedString = [self prohibitedCharacters][letter];
            [updatedStringArray addObject:replacedString ? replacedString : letter];
        }
        return [updatedStringArray componentsJoinedByString:@""];
    }
    return object;
}

@end
