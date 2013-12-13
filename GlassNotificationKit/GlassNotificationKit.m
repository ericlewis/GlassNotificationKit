//
//  GlassNotificationKit.m
//  GlassNotificationKit
//
//  Created by Eric Lewis on 12/13/13.
//  Copyright (c) 2013 Eric Lewis. All rights reserved.
//

#import "GlassNotificationKit.h"

@implementation GlassNotificationKit

static GlassNotificationKit *sharedInstance = nil;

static NSString *appID = nil;
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
    appID = [[NSBundle mainBundle] bundleIdentifier];
    clientID = identifier;
    clientSecret = secret;
    
    return self;
}

// easily mirror a notice from application:didReceiveRemoteNotification:fetchCompletionHandler
- (void)mirrorNotificationBasic:(NSDictionary *)notification{
    [self postNotificationWithHTML:[self buildTimelineCard:notification]];
}

# pragma mark - Google Auth

- (void)presentGoogleSigninFromViewController:(UIViewController *)controller{
    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:appID
                                                                                          clientID:clientID
                                                                                      clientSecret:clientSecret];
    if (auth == nil){
        GTMOAuth2ViewControllerTouch *vc = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:@"https://www.googleapis.com/auth/glass.timeline"
                                                                                      clientID:clientID
                                                                                  clientSecret:clientSecret
                                                                              keychainItemName:appID
                                                                             completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *_auth, NSError *error) {
                                                                                 
                                                                                 self.mirrorService.authorizer = auth;
                                                                                 
                                                                                 [controller dismissViewControllerAnimated:YES completion:nil];
                                                                             }];
        
        [controller presentViewController:vc animated:YES completion:nil];
    }
    else{
        self.mirrorService.authorizer = auth;
    }
}

# pragma mark - Card Builder

- (NSString *)buildTimelineCard:(NSDictionary*)userInfo{
    // build out the timeline card as an HTML string to be sent via postNotificationWithMessage
    // includes adding timestamp, app name, title of the card if possible, and message. external images are allowed too.
    // demo HTML from PostOffice
    // return [NSString stringWithFormat:@"<article><section><p class=\"blue\">%@:%@</h1><br><br><p>%@</p></section></article>", application, [view title] != nil ? [view title] : @"", message]
    return nil;
}

# pragma mark - Mirror API

- (void)postNotificationWithHTML:(NSString *)HTML{
    _mirrorService = [[GTLServiceMirror alloc] init];
    
    NSLog(@"POSTING NOTIFICATION");
    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:appID
                                                                                          clientID:clientID
                                                                                      clientSecret:clientSecret];
    self.mirrorService.authorizer = auth;
    
    GTLMirrorTimelineItem *item = [[GTLMirrorTimelineItem alloc] init];
    item.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    item.html = HTML;
    item.bundleId = @"com.1debit.GNK";
    GTLMirrorNotificationConfig *notificationConfig = [[GTLMirrorNotificationConfig alloc] init];
    notificationConfig.level = @"DEFAULT";
    item.notification = notificationConfig;
    
    GTLMirrorMenuItem *deleteButton = [[GTLMirrorMenuItem alloc] init];
    deleteButton.action = @"DELETE";
    item.menuItems = @[deleteButton];
    
    
    GTLQueryMirror *post = [GTLQueryMirror queryForTimelineInsertWithObject:item
                                                           uploadParameters:nil];
    
    [self.mirrorService executeQuery:post
                   completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                       NSLog(@"posted");
                       NSLog(@"ticket: %@", ticket);
                       NSLog(@"obj: %@", object);
                       NSLog(@"error: %@", error);
                       NSLog(@"%@", [(GTLMirrorTimelineItem *)object html]);
                   }];
}

@end
