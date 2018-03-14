
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

@class RNDynamicBundle;

@protocol RNDynamicBundleDelegate <NSObject>

- (void)dynamicBundle:(RNDynamicBundle *)dynamicBundle requestsReloadForBundleURL:(NSURL *)bundleURL;

@end

@interface RNDynamicBundle : NSObject <RCTBridgeModule>

@property (weak) id<RNDynamicBundleDelegate> delegate;

- (void)reloadBundle;
- (void)registerBundle:(NSString *)bundleId atRelativePath:(NSString *)path;
- (void)unregisterBundle:(NSString *)bundleId;
- (void)setActiveBundle:(NSString *)bundleId;

- (NSURL *)resolveBundleURL;
- (void)registerBundle:(NSString *)bundleId atURL:(NSURL *)URL;
- (NSMutableDictionary *)loadRegistry;
- (void)storeRegistry:(NSDictionary *)dict;

@end
  
