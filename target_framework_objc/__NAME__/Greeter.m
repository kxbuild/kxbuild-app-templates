//
//  Greeter.m
//  __NAME__
//
//  Created on __DATE__.
//

#import "Greeter.h"

@implementation Greeter

- (NSString *)greetingForName:(NSString *)name {
    return [NSString stringWithFormat:@"Hello, %@! — from __NAME__", name];
}

@end
