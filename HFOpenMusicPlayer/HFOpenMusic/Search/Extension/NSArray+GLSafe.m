//
//  NSArray+GLSafe.m
//  HFVMusicKit
//
//  Created by 郭亮 on 2020/12/4.
//

#import "NSArray+GLSafe.h"
#import <objc/runtime.h>

@implementation NSArray (GLSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /**
         数组越界
         */
        //--空数组--
        Method oldEmptyObjectAtIndex =class_getInstanceMethod(objc_getClass("__NSArray0"),@selector(objectAtIndex:));
        Method newEmptyObjectAtIndex =class_getInstanceMethod(objc_getClass("__NSArray0"),@selector(gl_emptyObjectAtIndex:));
        method_exchangeImplementations(oldEmptyObjectAtIndex, newEmptyObjectAtIndex);
        //--不可变数组--
        //1.objectAtIndex
        Method oldObjectAtIndex =class_getInstanceMethod(objc_getClass("__NSArrayI"),@selector(objectAtIndex:));
        Method newObjectAtIndex =class_getInstanceMethod(objc_getClass("__NSArrayI"),@selector(gl_objectAtIndex:));
        method_exchangeImplementations(oldObjectAtIndex, newObjectAtIndex);
        //2.[]
        Method oldObjectAtIndexSubscript =class_getInstanceMethod(objc_getClass("__NSArrayI"),@selector(objectAtIndexedSubscript:));
        Method newObjectAtIndexSubscript =class_getInstanceMethod(objc_getClass("__NSArrayI"),@selector(gl_objectAtIndexedSubscript:));
        method_exchangeImplementations(oldObjectAtIndexSubscript, newObjectAtIndexSubscript);
        //--可变数组--
        //1.objectAtIndex
        Method oldMutableObjectAtIndex =class_getInstanceMethod(objc_getClass("__NSArrayM"),@selector(objectAtIndex:));
        Method newMutableObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayM"),@selector(gl_mutableObjectAtIndex:));
        method_exchangeImplementations(oldMutableObjectAtIndex, newMutableObjectAtIndex);
        //2.[]
        Method oldMutableObjectAtIndexSubscript =class_getInstanceMethod(objc_getClass("__NSArrayM"),@selector(objectAtIndexedSubscript:));
        Method newMutableObjectAtIndexSubscript =class_getInstanceMethod(objc_getClass("__NSArrayM"),@selector(gl_mutableObjectAtIndexedSubscript:));
        method_exchangeImplementations(oldMutableObjectAtIndexSubscript, newMutableObjectAtIndexSubscript);
        /**
         数组添加对象
         */
        //addObject:
        Method oldMutableAddObject =class_getInstanceMethod(objc_getClass("__NSArrayM"),@selector(addObject:));
        Method newMutableAddObject = class_getInstanceMethod(objc_getClass("__NSArrayM"),@selector(gl_mutableAddObject:));
        method_exchangeImplementations(oldMutableAddObject, newMutableAddObject);
        
        
    });
    [super load];
}

-(id)gl_emptyObjectAtIndex:(NSUInteger)index {
    if (index >self.count -1 || !self.count){
        @try {
            return [self gl_emptyObjectAtIndex:index];
        } @catch (NSException *exception) {
            //__throwOutException  抛出异常
            //LPLog(@"空数组越界...");
            return nil;
        } @finally {

        }
    }
    else{
        return [self gl_emptyObjectAtIndex:index];
    }
}

- (id)gl_objectAtIndex:(NSUInteger)index{
    if (index >self.count -1 || !self.count){
        @try {
            return [self gl_objectAtIndex:index];
        } @catch (NSException *exception) {
            //__throwOutException  抛出异常
            //LPLog(@"数组越界---objectAtIndex");
            return nil;
        } @finally {

        }
    }
    else{
        return [self gl_objectAtIndex:index];
    }
}

-(id)gl_objectAtIndexedSubscript:(NSUInteger)index {
    if (index >self.count -1 || !self.count){
        @try {
            return [self gl_objectAtIndexedSubscript:index];
        } @catch (NSException *exception) {
            //__throwOutException  抛出异常
            //LPLog(@"数组越界---[]");
            return nil;
        } @finally {

        }
    }
    else{
        return [self gl_objectAtIndexedSubscript:index];
    }
}

- (id)gl_mutableObjectAtIndex:(NSUInteger)index{
    if (index >self.count -1 || !self.count){
        @try {
            return [self gl_mutableObjectAtIndex:index];
        } @catch (NSException *exception) {
            //__throwOutException  抛出异常
            //LPLog(@"可变数组越界---objectAtIndex");
            return nil;
        } @finally {

        }
    }
    else{
        return [self gl_mutableObjectAtIndex:index];
    }
}

-(id)gl_mutableObjectAtIndexedSubscript:(NSUInteger)index {
    if (index >self.count -1 || !self.count){
        @try {
            return [self gl_mutableObjectAtIndexedSubscript:index];
        } @catch (NSException *exception) {
            //__throwOutException  抛出异常
            //LPLog(@"可变数组越界---[]");
            return nil;
        } @finally {

        }
    }
    else{
        return [self gl_mutableObjectAtIndexedSubscript:index];
    }
}

-(void)gl_mutableAddObject:(NSObject *)obj {
    if (obj) {
        [self gl_mutableAddObject: obj];
    } else {
        @try {
           [self gl_mutableAddObject: obj];
        } @catch (NSException *exception) {
            //__throwOutException  抛出异常
            //LPLog(@"添加空对象至可变数组");
            
        } @finally {

        }
    }
}
@end
