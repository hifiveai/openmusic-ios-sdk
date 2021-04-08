//
//  NSMutableDictionary+SafeAccess.m
//  HFVMusic
//
//  Created by 灏 孙  on 2020/11/3.
//

#import "NSMutableDictionary+SafeAccess.h"

@implementation NSMutableDictionary (SafeAccess)
- (id)hfv_objectForKey_Safe:(id)aKey
{
    id object = nil;
    @try {
        object = [self objectForKey:aKey];
        if (object == [NSNull null]) {
            object = nil;
        }
    } @catch (NSException *exception) {

    } @finally {
        return object;
    }
}

- (void)hfv_setObject_Safe:(id)anObject forKey:(id)aKey{
    //如果是空字符串也不能设置
    if ([anObject isKindOfClass:[NSString class]]) {
        if ([HFVLibUtils isBlankString: anObject]) {
            return;
        }
    }
    @try {
         [self setObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)hfv_removeObjectForKey_Safe:(id)aKey {
    @try {
        [self removeObjectForKey:aKey];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
@end
