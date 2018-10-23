//
//  EncrytUtils.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/12.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "EncrytUtils.h"
#import "NetRSA.h"
#import "NSData+GZIP.h"

static NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAy/M1AxLZjZOyJToExpn1\nhudAWySRzS+aGwNVdX9QX6vK38O7WUA7h/bYqBu+6tTRC6RnL9BksMrIf5m6D3rt\nfaYYmxfe/FI4ZD5ybIhFuRUi95e/J2vQVElsSNqSz7ewXquZpKZAqlzH4hGgOqmO\nTHlrwiQwX66bS7x7kDmvxMd5ZRGhTvz62kpKb/orcnWQ1KElNc/bIzTtv3jsrMgH\nFVdFZfev91ew4Kf1YJbqGBGKslBsIoGsgTxI94T6d6XEFxSzdvrRwKhOobXIaOhZ\no3GBCZIA/1ZOwLK6RyrWdprz+60xifcYIkILdZ7yPazSfHCVHFY6o/fQjK4dxQDW\nGw0fxN9QX+v3+48nW7QIBx4KNYNIW/eetGhXpOwV4PjNt15fcwJkKsx2W3VQuh93\njdYB4xMyDUnRwb9np/QR1rmbzSm5ySGkmD7NAj03V+O82Nx4uxsdg2H7EQdVcY7e\n6dEdpLYp2p+VkDd9t/5y1D8KtC35yDwraaxXveTMfLk8SeI/Yz4QaX6dolZEuUWa\ntLaye2uA0w25Ee35irmaNDLhDr804B7U7M4kkbwY7ijvvhnfb1NwFY5lw/2/dZqJ\nx2gH3lXVs6AM4MTDLs4BfCXiq2WO15H8/4Gg/2iEk8QhOWZvWe/vE8/ciB2ABMEM\nvvSb829OOi6npw9i9pJ8CwMCAwEAAQ==\n-----END PUBLIC KEY-----";


static char *k = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ*!";
@implementation EncrytUtils

+ (NSString *)encode:(NSString *)str {
    if(str == nil) return @"";
    
    NSMutableString *result = [NSMutableString new];
    const char *carr = [[[str dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0] UTF8String];
    size_t length= strlen(carr);
    [result appendString:@"x"];
    for (int i = 0; i < length; i++) {
        [result appendString:[NSString stringWithFormat:@"%d", carr[i] + k[i%strlen(k)]]];
        if(i != length - 1){
            [result appendString:@"_"];
        }
    }
    [result appendString:@"y"];
    NSLog(@"%@", result);
    return result;
}

+ (NSString *)getPubKey {
    return pubkey;
}

+ (void)setPubKey:(NSString *)_pubkey {
    pubkey = _pubkey;
}

+ (NSString *)decode:(NSString *)str {
    if(str == nil) return @"";
    NSMutableString *result = [NSMutableString new];
    if([str hasPrefix:@"x"] && [str hasSuffix:@"y"]){
        NSRange range = NSMakeRange(1, str.length - 2);
        NSArray *sarr = [[str substringWithRange:range] componentsSeparatedByString:@"_"];
        for(int i = 0; i < [sarr count]; i++){
            [result appendString:[NSString stringWithFormat:@"%c", [sarr[i] intValue] - k[i%strlen(k)]]];
        }
    }
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:result options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}

+ (NSString *)rsaWithPublickey:(NSString *)publicKey data:(NSString *)jsonStr {
    return [NetRSA encryptString:jsonStr publicKey:publicKey];
}

+ (NSData *)gzipByRsa:(NSString *)jsonStr {
    if(jsonStr == nil) return nil;
    jsonStr = [EncrytUtils rsaWithPublickey:[EncrytUtils getPubKey] data:jsonStr];
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    return [jsonData gzippedData];
}

+ (NSString *)upgzipByResponse:(NSData *)data {
    if(data ==  nil) return nil;
    NSData *undata = [data gunzippedData];
    NSString *str = [[NSString alloc] initWithData:undata encoding:NSUTF8StringEncoding];
    return [EncrytUtils decode:str];
}


@end
