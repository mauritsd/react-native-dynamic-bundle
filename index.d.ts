declare module 'react-native-dynamic-bundle' {
  /**
   * Set the active Javascript bundle to the bundle with the given bundle ID in
   * the registry. This will cause the given bundle to be loaded on the next app
   * startup or invocation of `reloadBundle()`.
   */
  export function setActiveBundle(bundleId: string | null): void

  /**
   * Register a Javascript bundle in the bundle registry. The path to the bundle
   * should be relative to the documents directory on iOS and to the internal app
   * storage directory on Android, i.e. the directory returned by `getFilesDir()`.
   */
  export function registerBundle(bundleId: string, relativePath: string): void

  /**
   * Unregister a bundle from the bundle registry.
   */
  export function unregisterBundle(bundleId: string): void

  /**
   * Reload the bundle that is used by the app immediately. This can be used to
   * apply a new bundle that was set by `setActiveBundle()` immediately.
   */
  export function reloadBundle(): void

  /**
   * Returns a promise that resolves to the currently active bundle identifier.
   * if the default bundle (i.e. the bundle that was packaged into the native app)
   * is active this method will resolve to `null`.
   */
  export function getActiveBundle(): Promise<string>

  /**
   * Returns a promise that resolves to the currently active bundle identifier.
   * if the default bundle (i.e. the bundle that was packaged into the native app)
   * is active this method will resolve to `null`.
   */
  export function getBundles(): Promise<{ [key: string]: string }>
}
