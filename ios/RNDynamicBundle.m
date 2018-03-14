
#import "RNDynamicBundle.h"

static NSString * const kBundleRegistryStoreFilename = @"_RNDynamicBundle.plist";

@implementation RNDynamicBundle

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(reloadBundle) {
    [self.delegate dynamicBundle:self
        requestsReloadForBundleURL:[self resolveBundleURL]];
}

- (NSURL *)resolveBundleURL {
    NSMutableDictionary *dict = [self loadRegistry];
    NSString *activeBundle = dict[@"activeBundle"];
    if ([activeBundle isEqualToString:@""]) {
        activeBundle = @"__default";
    }
    NSString *bundleURLString = dict[@"bundles"][activeBundle];
    if (bundleURLString == nil) {
        bundleURLString = dict[@"bundles"][@"__default"];
    }
    
    return [NSURL URLWithString:bundleURLString];
}

RCT_EXPORT_METHOD(registerBundle:(NSString *)bundleId atRelativePath:(NSString *)relativePath) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:relativePath];
    NSURL *URL = [NSURL fileURLWithPath:path];
    
    NSMutableDictionary *dict = [self loadRegistry];
    dict[@"bundles"][bundleId] = URL.absoluteString;
    [self storeRegistry:dict];
}

RCT_EXPORT_METHOD(unregisterBundle:(NSString *)bundleId) {
    NSMutableDictionary *dict = [self loadRegistry];
    NSMutableDictionary *bundlesDict = dict[@"bundles"];
    [bundlesDict removeObjectForKey:bundleId];
    [self storeRegistry:dict];
}

RCT_EXPORT_METHOD(setActiveBundle:(NSString *)bundleId) {
    NSMutableDictionary *dict = [self loadRegistry];
    dict[@"activeBundle"] = bundleId;

    [self storeRegistry:dict];
}

- (void)registerBundle:(NSString *)bundleId atURL:(NSURL *)URL {    
    NSMutableDictionary *dict = [self loadRegistry];
    dict[@"bundles"][bundleId] = URL.absoluteString;
    [self storeRegistry:dict];
}

- (NSMutableDictionary *)loadRegistry {
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

- (void)storeRegistry:(NSDictionary *)dict {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:kBundleRegistryStoreFilename];
    
    [dict writeToFile:path atomically:YES];
}

RCT_EXPORT_MODULE()

@end
  
