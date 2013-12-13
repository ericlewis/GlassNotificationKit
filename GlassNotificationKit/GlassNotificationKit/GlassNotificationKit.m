//
//  GlassNotificationKit.m
//  GlassNotificationKit
//
//  Created by 1debit on 12/13/13.
//  Copyright (c) 2013 1debit. All rights reserved.
//

#import "GlassNotificationKit.h"

@implementation GlassNotificationKit

static GlassNotificationKit *sharedInstance = nil;

static NSString *clientID = nil;
static NSString *clientSecret = nil;

+ (GlassNotificationKit *)sharedInstanceWithClientID:(NSString *)clientID andSecret:(NSString *)secret{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] initWithClientID:clientID andSecret:secret];
    });
    return sharedInstance;
}

+ (GlassNotificationKit *)sharedInstance
{
    if (sharedInstance == nil) {
        NSLog(@"oops! called before sharedInstanceWithClientID:");
    }
    return sharedInstance;
}

- (instancetype)initWithClientID:(NSString *)identifier andSecret:(NSString *)secret{
    clientID = identifier;
    clientSecret = secret;
    
    return self;
}

# pragma mark - Google Auth Code

@end
