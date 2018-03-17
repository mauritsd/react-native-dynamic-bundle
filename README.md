
# react-native-dynamic-bundle

## What is this?

react-native-dynamic-bundle is a library, similar to react-native-auto-updater
and CodePush, that allows you to change the React Native bundle loaded by
an application without updating the application itself (i.e. through the App
Store or Google Play). You could use this functionality to, for example:
* Get app updates to users quicker.
* Make A/B-testing or gradual rollouts as easy as on the web.

react-native-dynamic-bundle differs from react-native-auto-updater and
alternatives in that it does not attempt to be a complete solution, only
providing the bare necessities for switching bundles and reloading the app. This
requires you to implement the logic to download and keep track of the bundles
yourself, but does give you complete freedom in how you implement your updater
or A/B testing logic.

## To do's
* Explanations of how to set it up on the native side. In the meanwhile have
  a look at AppDelegate.m for iOS and MainActivity.java / MainApplication.java
  for Android.


## Getting started

`$ npm install react-native-dynamic-bundle --save`

or

`$ yarn add react-native-dynamic-bundle`


### Mostly automatic installation

`$ react-native link react-native-dynamic-bundle`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-dynamic-bundle` and add `RNDynamicBundle.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNDynamicBundle.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import org.mauritsd.reactnativedynamicbundle.RNDynamicBundlePackage;` to the imports at the top of the file
  - Add `new RNDynamicBundlePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-dynamic-bundle'
  	project(':react-native-dynamic-bundle').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-dynamic-bundle/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-dynamic-bundle')
  	```


## Usage
```javascript
import {
  setActiveBundle,
  registerBundle,
  unregisterBundle,
  reloadBundle
} from 'react-native-dynamic-bundle';

/* Register a bundle in the documents directory of the app. This could be
 * pre-packaged in your app, downloaded over http, etc. Paths are relative
 * to your documents directory.
 */
registerBundle('a_b_test', 'bundles/a_b_test.bundle');

/* Set the active bundle to a_b_test. This means that on the next load
 * this bundle will be loaded instead of the default.
 */
setActiveBundle('a_b_test');

/* Unregister a bundle once you're done with it. Note that you will have to
 * remove the file yourself.
 */
unregisterBundle('a_b_test');

/* In some circumstances (e.g. the user consents to an update) we want to
 * force a bundle reload instead of waiting until the next app restart.
 * Note that this will have to result in the destruction of the current
 * RCTBridge and its recreation with the new bundle URL. It is therefore
 * recommended to sync data and let actions complete before calling this.
 */
reloadBundle();
```
