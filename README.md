# JsonToXmlConverter
This class can be used to convert json to xml. 

The converter has the handler method to validate xml characters:
<table>
  <tr>
    <td>Invalid character</td>
    <td><</td>
    <td>></td>
    <td>"</td>
    <td>'</td>
    <td>&</td>
  </tr>
</table>

You can setup your own tag for array items. By default this tag name is **“item”**

**# Some example:**
```objective-c
NSArray *array = @[ @{ @"id":@1, @"name":@"Johnson, Smith, and Jones Co.", @"amount":@345.33, @"Remark":@"Pays on time" },@{ @"id":@2, @"name":@"Sam Smith", @"amount":@993.44, @"Remark":@""}, @{ @"id":@3, @"name":@"Barney & Company", @"amount":@0, @"Remark":@"Great to work with\nand always pays with cash."}, @{@"id":@4, @"name":@"Johnson's Automotive", @"amount":@2344, @"Remark":@""}];
NSError *error;
NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
NSData *xmlData = [XmlConverter getXmlDataFromJsonData:jsonData arrayItemTag:@""];
```
**result is**
```xml
<?xml version="1.0" encoding="UTF-8"?><container><><amount>345.33</amount><id>1</id><Remark>Pays on time</Remark><name>Johnson, Smith, and Jones Co.</name></><><amount>993.4400000000001</amount><id>2</id><Remark></Remark><name>Sam Smith</name></><><amount>0</amount><id>3</id><Remark>Great to work with
and always pays with cash.</Remark><name>Barney &amp; Company</name></><><amount>2344</amount><id>4</id><Remark></Remark><name>Johnson&apos;s Automotive</name></></container>
```

