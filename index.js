/**
 * react-native-dynamic-bundle
 * @flow
 */

// $FlowExpectedError: library code, so RN is not in node_modules
import { NativeModules } from 'react-native';

const { RNDynamicBundle } = NativeModules;

/**
 * Set the active Javascript bundle to the bundle with the given bundle ID in
 * the registry. This will cause the given bundle to be loaded on the next app
 * startup or invocation of `reloadBundle()`.
 */
export function setActiveBundle(bundleId: string) {
  RNDynamicBundle.setActiveBundle(bundleId);
}

/**
 * Register a Javascript bundle in the bundle registry. The path to the bundle
 * should be relative to the documents directory on iOS and to the internal app
 * storage directory on Android, i.e. the directory returned by `getFilesDir()`.
 */
export function registerBundle(bundleId: string, relativePath: string) {
  RNDynamicBundle.registerBundle(bundleId, relativePath);
}

/**
 * Unregister a bundle from the bundle registry.
 */
export function unregisterBundle(bundleId: string) {
  RNDynamicBundle.unregisterBundle(bundleId);
}

/**
 * Reload the bundle that is used by the app immediately. This can be used to
 * apply a new bundle that was set by `setActiveBundle()` immediately.
 */
export function reloadBundle() {
  RNDynamicBundle.reloadBundle();
}

/**
 * Returns a promise that resolves to an object with the contents of the bundle
 * registry, where the keys are the bundle identifiers and values are the
 * bundle locations encoded as a file URL.
 */
export function getBundles(): Promise<{ [string]: string }> {
  return RNDynamicBundle.getBundles();
}

/**
 * Returns a promise that resolves to the currently active bundle identifier.
 * if the default bundle (i.e. the bundle that was packaged into the native app)
 * is active this method will resolve to `null`.
 */
 export function getActiveBundle(): Promise<?string> {
   return RNDynamicBundle.getActiveBundle();
 }
