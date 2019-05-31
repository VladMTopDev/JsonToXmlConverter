//
//  XmlConverter.h
//  ConvertToXml
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XmlConverter : NSObject

+ (NSData *)getXmlDataFromJsonData:(NSData *)jsonData arrayItemTag:(NSString *)itemTag;
+ (NSString *)getXmlStringFromJsonData:(NSData *)jsonData arrayItemTag:(NSString *)itemTag;

@end

NS_ASSUME_NONNULL_END
