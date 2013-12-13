//
//  GlassNotificationKit.h
//  GlassNotificationKit
//
//  Created by Eric Lewis on 12/13/13.
//  Copyright (c) 2013 Eric Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GTLMirror.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface GlassNotificationKit : NSObject

@property (nonatomic, strong) GTLServiceMirror *mirrorService;

+ (GlassNotificationKit *)sharedInstanceWithClientID:(NSString *)clientID andSecret:(NSString *)secret;

+ (GlassNotificationKit *)sharedInstance;

- (instancetype)initWithClientID:(NSString *)identifier andSecret:(NSString *)secret;

- (void)presentSigninFromViewController:(UIViewController *)controller;

- (void)mirrorNotificationBasic:(NSDictionary *)notification;

@end
