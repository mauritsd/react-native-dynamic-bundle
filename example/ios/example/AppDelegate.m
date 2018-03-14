/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  /* We need to keep track of these because we may want to reinit the bridge later and
   * will need them then.
   */
  self.launchOptions = launchOptions;
  
  NSURL *jsCodeLocation;
  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
  
  /* Need this for the initial init since RCTBridge will init RNDynamicBundle for us, leading
   * to a circular dependency problem. We could init RNDynamicBundle for the bridge ourselves
   * to sidestep this problem in a nicer way, but let's keep this example simple.
   */
  RNDynamicBundle *tempDynamicBundle = [RNDynamicBundle new];
  [tempDynamicBundle registerBundle:@"__default" atURL:jsCodeLocation];

  RCTBridge *bridge = [[RCTBridge alloc] initWithBundleURL:[tempDynamicBundle resolveBundleURL]
                                            moduleProvider:nil
                                             launchOptions:self.launchOptions];
  RNDynamicBundle *dynamicBundle = [bridge moduleForClass:[RNDynamicBundle class]];
  dynamicBundle.delegate = self;
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"example"
                                            initialProperties:nil];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)dynamicBundle:(RNDynamicBundle *)dynamicBundle requestsReloadForBundleURL:(NSURL *)bundleURL
{
  RCTBridge *bridge = [[RCTBridge alloc] initWithBundleURL:[dynamicBundle resolveBundleURL]
                                            moduleProvider:nil
                                             launchOptions:self.launchOptions];
  RNDynamicBundle *newDynamicBundle = [bridge moduleForClass:[RNDynamicBundle class]];
  newDynamicBundle.delegate = self;
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"example"
                                            initialProperties:nil];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  
  self.window.rootViewController.view = rootView;
}

@end
