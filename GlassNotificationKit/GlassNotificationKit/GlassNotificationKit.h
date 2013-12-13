//
//  GlassNotificationKit.h
//  GlassNotificationKit
//
//  Created by 1debit on 12/13/13.
//  Copyright (c) 2013 1debit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlassNotificationKit : NSObject

+ (GlassNotificationKit *)sharedInstanceWithClientID:(NSString *)clientID andSecret:(NSString *)secret;

+ (GlassNotificationKit *)sharedInstance;

- (instancetype)initWithClientID:(NSString *)identifier andSecret:(NSString *)secret;

@end
