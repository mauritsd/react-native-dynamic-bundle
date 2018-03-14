
# react-native-dynamic-bundle

## Getting started

`$ npm install react-native-dynamic-bundle --save`

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

// TODO: What to do with the module?
RNDynamicBundle;
```
  