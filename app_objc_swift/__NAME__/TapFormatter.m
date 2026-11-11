//
//  TapFormatter.m
//  __NAME__
//
//  Created on __DATE__.
//

#import "TapFormatter.h"

@implementation TapFormatter

- (NSString *)messageForCount:(NSInteger)count {
    return [NSString stringWithFormat:@"Tapped %ld time%@", (long)count, count == 1 ? @"" : @"s"];
}

@end
