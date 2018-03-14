/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>

#import <RNDynamicBundle.h>

@class RCTRootView;

@interface AppDelegate : UIResponder <UIApplicationDelegate, RNDynamicBundleDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSDictionary *launchOptions;

- (RCTRootView *)getRootViewForBundleURL:(NSURL *)bundleURL;

@end
