//
//  LSNSURLSessionHook.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 08/01/14.
//  Copyright (c) 2014 Luis Solano Bonet. All rights reserved.
//

#import "LSNSURLSessionHook.h"
#import "LSHTTPStubURLProtocol.h"
#import <objc/runtime.h>

@implementation LSNSURLSessionHook

- (void)load {
    [self swizzleSelector:@selector(protocolClasses) formClass:[NSURLSessionConfiguration class] toClass:[self class]];
}

- (void)unload {
    [self swizzleSelector:@selector(protocolClasses) formClass:[NSURLSessionConfiguration class] toClass:[self class]];
}

- (void)swizzleSelector:(SEL)selector formClass:(Class)original toClass:(Class)stub {

    Method originalMethod = class_getInstanceMethod(original, selector);
    Method stubMethod = class_getInstanceMethod(stub, selector);
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NSURLSession hook."];
    }
    IMP result = method_setImplementation(originalMethod, method_getImplementation(stubMethod));
//    method_exchangeImplementations(originalMethod, stubMethod);

    method_setImplementation(stubMethod, result);
}

- (NSArray *)protocolClasses {
    return @[[LSHTTPStubURLProtocol class]];
}


@end