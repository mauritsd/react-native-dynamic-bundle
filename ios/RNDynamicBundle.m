
#import "RNDynamicBundle.h"

static NSString * const kBundleRegistryStoreFilename = @"_RNDynamicBundle.plist";

@implementation RNDynamicBundle

static NSURL *_defaultBundleURL = nil;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (NSMutableDictionary *)loadRegistry
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:kBundleRegistryStoreFilename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSDictionary *defaults = @{
                                   @"bundles": [NSMutableDictionary dictionary],
                                   @"activeBundle": @"",
                                   };
        return [defaults mutableCopy];
    } else {
        return [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
}

+ (void)storeRegistry:(NSDictionary *)dict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:kBundleRegistryStoreFilename];
    
    [dict writeToFile:path atomically:YES];
}

+ (NSURL *)resolveBundleURL
{
    NSMutableDictionary *dict = [RNDynamicBundle loadRegistry];
    NSString *activeBundle = dict[@"activeBundle"];
    if ([activeBundle isEqualToString:@""]) {
        return _defaultBundleURL;
    }
    NSString *bundleRelativePath = dict[@"bundles"][activeBundle];
    if (bundleRelativePath == nil) {
        return _defaultBundleURL;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:bundleRelativePath];
    
    return [NSURL fileURLWithPath:path];
}

+ (void)setDefaultBundleURL:(NSURL *)URL
{
    _defaultBundleURL = URL;
}

- (void)reloadBundle
{
    [self.delegate dynamicBundle:self
      requestsReloadForBundleURL:[RNDynamicBundle resolveBundleURL]];
}

- (void)registerBundle:(NSString *)bundleId atRelativePath:(NSString *)relativePath
{
    NSMutableDictionary *dict = [RNDynamicBundle loadRegistry];
    dict[@"bundles"][bundleId] = relativePath;
    [RNDynamicBundle storeRegistry:dict];
}

- (void)unregisterBundle:(NSString *)bundleId
{
    NSMutableDictionary *dict = [RNDynamicBundle loadRegistry];
    NSMutableDictionary *bundlesDict = dict[@"bundles"];
    [bundlesDict removeObjectForKey:bundleId];
    [RNDynamicBundle storeRegistry:dict];
}

- (void)setActiveBundle:(NSString *)bundleId
{
    NSMutableDictionary *dict = [RNDynamicBundle loadRegistry];
    dict[@"activeBundle"] = bundleId == nil ? @"" : bundleId;

    [RNDynamicBundle storeRegistry:dict];
}

- (NSDictionary *)getBundles
{
    NSMutableDictionary *bundles = [NSMutableDictionary dictionary];
    NSMutableDictionary *dict = [RNDynamicBundle loadRegistry];
    for (NSString *bundleId in dict[@"bundles"]) {
        NSString *relativePath = dict[bundleId];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths firstObject];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:relativePath];
        NSURL *URL = [NSURL fileURLWithPath:path];
        
        bundles[bundleId] = [URL absoluteString];
    }
    
    return bundles;
}

- (NSString *)getActiveBundle
{
    NSMutableDictionary *dict = [RNDynamicBundle loadRegistry];
    NSString *activeBundle = dict[@"activeBundle"];
    if ([activeBundle isEqualToString:@""]) {
        return nil;
    }
    
    return activeBundle;
}

/* Make wrappers for everything that is exported to the JS side. We want this
 * because we want to call some of the methods in this module from the native side
 * as well, which requires us to put them into the header file. Since RCT_EXPORT_METHOD
 * is largely a black box it would become rather brittle and unpredictable which method
 * definitions exactly to put in the header.
 */
RCT_REMAP_METHOD(reloadBundle, exportedReloadBundle)
{
    [self reloadBundle];
}

RCT_REMAP_METHOD(registerBundle, exportedRegisterBundle:(NSString *)bundleId atRelativePath:(NSString *)path)
{
    [self registerBundle:bundleId atRelativePath:path];
}

RCT_REMAP_METHOD(unregisterBundle, exportedUnregisterBundle:(NSString *)bundleId)
{
    [self unregisterBundle:bundleId];
}

RCT_REMAP_METHOD(setActiveBundle, exportedSetActiveBundle:(NSString *)bundleId)
{
    [self setActiveBundle:bundleId];
}

RCT_REMAP_METHOD(getBundles,
                 exportedGetBundlesWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve([self getBundles]);
}

RCT_REMAP_METHOD(getActiveBundle,
                 exportedGetActiveBundleWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *activeBundle = [self getActiveBundle];
    if (activeBundle == nil) {
        resolve([NSNull null]);
    } else {
        resolve(activeBundle);
    }
}

RCT_EXPORT_MODULE()

@end
  
