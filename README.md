
# react-native-dynamic-bundle

## What is this?

react-native-dynamic-bundle is a library, similar to react-native-auto-updater
and CodePush, that allows you to change the React Native bundle loaded by
an application without updating the application itself (i.e. through the App
Store or Google Play). You could use this functionality to, for example:
* Get app updates to users quicker.
* Make A/B-testing or gradual rollouts less cumbersome.

react-native-dynamic-bundle differs from react-native-auto-updater and
alternatives in that it does not attempt to be an end-to-end solution for
updates or A/B testing, only providing the bare necessities for switching
bundles and reloading the app. This means you will have to implement things
like the update UI, a bundle downloader and fallback/safety mechanisms yourself.

## To do's
* Make an npm package out of this project.
* Implement Android version of native code.
* Have API calls to query the bundle registry from the JS side.
* API docs. In the meanwhile, have a look at AppDelegate.{h,m} of the example.
* Don't export the NativeModules directly, but have a simple JS wrapper around
  them.
* Have the example do more than just reload the current bundle.

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
import RNDynamicBundle from 'react-native-dynamic-bundle';

/* Register a bundle in the documents directory of the app. This could be
 * pre-packaged in your app, downloaded over http, etc. Paths are relative
 * to your documents directory.
 */
RNDynamicBundle.registerBundle('a_b_test', 'bundles/a_b_test.bundle');

/* Set the active bundle to a_b_test. This means that on the next load
 * this bundle will be loaded instead of the default.
 */
RNDynamicBundle.setActiveBundle('a_b_test');

/* Unregister a bundle once you're done with it. Note that you will have to
 * remove the file yourself.
 */
RNDynamicBundle.unregisterBundle('a_b_test');

/* In some circumstances (e.g. the user consents to an update) we want to
 * force a bundle reload instead of waiting until the next app restart.
 * Note that this will have to result in the destruction of the current
 * RCTBridge and its recreation with the new bundle URL. It is therefore
 * recommended to sync data and let actions complete before calling this.
 */
RNDynamicBundle.reloadBundle();
```
