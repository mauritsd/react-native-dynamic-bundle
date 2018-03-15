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
  [RNDynamicBundle setDefaultBundleURL:jsCodeLocation];
  
  RCTRootView *rootView = [self getRootViewForBundleURL:[RNDynamicBundle resolveBundleURL]];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)dynamicBundle:(RNDynamicBundle *)dynamicBundle requestsReloadForBundleURL:(NSURL *)bundleURL
{
  self.window.rootViewController.view = [self getRootViewForBundleURL:bundleURL];
}

- (RCTRootView *)getRootViewForBundleURL:(NSURL *)bundleURL
{
  RCTBridge *bridge = [[RCTBridge alloc] initWithBundleURL:bundleURL
                                            moduleProvider:nil
                                             launchOptions:self.launchOptions];
  RNDynamicBundle *dynamicBundle = [bridge moduleForClass:[RNDynamicBundle class]];
  dynamicBundle.delegate = self;
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"example"
                                            initialProperties:nil];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  
  return rootView;
}

@end
