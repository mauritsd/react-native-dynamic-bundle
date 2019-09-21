/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>

#import <RNDynamicBundle.h>

@class RCTRootView;

@interface AppDelegate : UIResponder <UIApplicationDelegate, RNDynamicBundleDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSDictionary *launchOptions;

- (RCTRootView *)getRootViewForBundleURL:(NSURL *)bundleURL;

@end
