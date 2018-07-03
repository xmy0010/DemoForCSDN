//
//  TYPersonModel.m
//  TYDemoEffective-ObjC
//
//  Created by T_yun on 2018/6/6.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "TYPersonModel.h"
#import <objc/runtime.h>
#import "TYSmithPerson.h"


@interface TYPersonModel()

//储存一些备用属性
@property(nonatomic, strong) NSMutableDictionary *backingStore;


@property(nonatomic, strong) NSMutableArray *friends;

//类中持有一个子类对象
@property(nonatomic, strong) TYSmithPerson  *smith;

@end

@implementation TYPersonModel

//声明之后 编译器不会为其自动生成实例变量存取方法
@dynamic string,number,date,opaqueObject;


+ (void)load{
    
    NSLog(@"%@  %s",[self class], __func__);
}

+ (void)initialize{
    
    NSLog(@"%@  %s",[self class], __func__);
}

- (instancetype)initWithLastName:(NSString *)lastName{
    
    if (self = [super init]) {
        
        _lastName = lastName;
    }
    
    return self;
}

- (void)setObj:(id)obj{
    
    _obj = obj;
}

// （EOC例子 完整例子重实现） 消息转发机制1.动态添加方法   (2.备援接受者 3.完整转发的例子在本类 另外完整实现)
//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//    
//    NSString *selectorString = NSStringFromSelector(sel);
//    if ([selectorString hasPrefix:@"set"]) {
//        
//        class_addMethod(self, sel, (IMP)autoDictionarySetter, "v@:@");
//    } else{
//        class_addMethod(self, sel, (IMP)autoDictionaryGetter, "@@:");
//    }
//    
//    return YES;
//}





//动态添加getter函数在字典backingStore里面取
id autoDictionaryGetter(id self,SEL _cmd){
    
    //Get the backing store from the object
    TYPersonModel *typedSelf = (TYPersonModel *)self;
    NSMutableDictionary *backingStore = typedSelf.backingStore;
    
    //The key is simply the selector name
    NSString *key = NSStringFromSelector(_cmd);
    
    //Return the value
    return [backingStore objectForKey:key];
}
//动态添加setter 存在字典backingStore里面
void autoDictionarySetter(id self, SEL _cmd, id value){
    
    //Get the backing store from the object
    TYPersonModel *typedSelf = (TYPersonModel *)self;
    NSMutableDictionary *backingStore = typedSelf.backingStore;
    
    /** The selector will be for example,"setOpaqueObject:"
     *  We need to remova the "set",":"and lowercase the first letter
     *  of remainder
     *
     */
    
    NSString *selectorString = NSStringFromSelector(_cmd);
    NSMutableString *key = [selectorString mutableCopy];
    
    //remove the ":" at the end
    [key deleteCharactersInRange:NSMakeRange(key.length - 1, 1)];
    
    //remove the "set" prefix
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    
    //lowercase the first character
    NSString *lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];
    
    if (value) {
        [backingStore setObject:value forKey:key];
    } else{
        [backingStore removeObjectForKey:key];
    }
}


#pragma MARK 完整消息转发例子
-(void)work{
    
    NSLog(@"work");
}

- (void)beFriendWith:(TYPersonModel *)otherPerson{
    
    NSLog(@"开始成为朋友....");
    [self.friends addObject:otherPerson];
    NSLog(@"已经成为朋友");
}

//
//void gotoSchool(id self,SEL _cmd, id value){
//
//    printf("go to school");
//}
////第一步：对象收到无法解读的消息，首先调用此方法（一般在里面动态添加处理方法）
//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//
//    NSString *selectorString = NSStringFromSelector(sel);
//    if ([selectorString isEqualToString:@"gotoSchool"]) {
//
//        class_addMethod(self, sel, (IMP)gotoSchool, "@@:");
//        return YES; //此处返回yes中断消息转发链 若不返回 执行到后面父类方法里面 最后不会走第二步 应该是因为在此处动态添加了方法能响应。 但是返回yes 直接不用去走父类方法
//    }
//
//    return [super resolveInstanceMethod:sel];
//}

////第二步：备援接收者 让其他对象来进行处理
//- (id)forwardingTargetForSelector:(SEL)aSelector{
//
//    NSString *selectorString = NSStringFromSelector(aSelector);
//    if([selectorString isEqualToString:@"gotoSchool"]){
//
//        return self.smith;
//    }
//
//    return nil;
//}

//第三步  完整的消息转发 将消息包装起来
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    
    NSMethodSignature *sign = [NSMethodSignature signatureWithObjCTypes:"@@:"];
    return sign;
}
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    
    NSLog(@"%@ can't handle by People", NSStringFromSelector([anInvocation selector]));
}


//这样做之后，类的实例对象就可以当作key传到NSDictionary中去了
-(id)copyWithZone:(NSZone *)zone
{
    TYPersonModel *aCopy = [[TYPersonModel allocWithZone:zone] init];
    if(aCopy)
    {
        [aCopy setAtomicNumber:[self.atomicNumber copyWithZone:zone]];
        [aCopy setNonatomicNumber:[self.nonatomicNumber copyWithZone:zone]];
        [aCopy setLastName:[self.lastName copyWithZone:zone]];
        [aCopy setObj:[self.obj copyWithZone:zone]];
    }
    return aCopy;
}



//重写等同性方法
- (BOOL)isEqual:(id)object{

    //如果指向同样内存地址  则指向对一个对象
    if (self == object) {

        return YES;
    }
    //此处 注意  == isKindOfClass(本类和子类) isMemberOfClass（本类 相当于下面提取类对象出来比较）
    if ([self class] != [object class]) {

        return NO;
    }

    return [self isEqualToPerson:(TYPersonModel *)object];
}

- (BOOL)isEqualToPerson:(TYPersonModel *)person{
    
    //判断为空时
    if (!person) {
        
        return NO;
    }
    
    //默认所有属性相同则相同
    if (![self.nonatomicNumber isEqualToNumber:person.nonatomicNumber]) {
        
        return NO;
    }
    if (![self.atomicNumber isEqualToNumber:person.atomicNumber]) {
        
        return NO;
    }
    if (![self.obj isEqual:person.obj]) {
        
        return NO;
    }
    if (![self.lastName isEqualToString:person.lastName]) {
        
        return NO;
    }
    
    return YES;
}

//重写hash  相等的对象返回相同的哈希码  但返回相同的哈希码不一定是相同的对象
- (NSUInteger)hash{
    
    NSUInteger nonatomicHash = [_nonatomicNumber hash];
    NSUInteger atomicHash = [_atomicNumber hash];
    NSUInteger lastnameHash = [_lastName hash];
    NSUInteger objHash = [_obj hash];
    
    NSUInteger hash = nonatomicHash ^ atomicHash ^ lastnameHash ^ objHash;
    NSLog(@"hash = %ld", hash);

    return hash;
}

#pragma mark - Lazy load
-(TYSmithPerson *)smith{
    
    if (!_smith) {
        
        _smith = [[TYSmithPerson alloc] init];
    }
    return _smith;
}
- (NSMutableArray *)friends {
    if (!_friends) {
        _friends = [NSMutableArray array];
    }
    return _friends;
}

@end
