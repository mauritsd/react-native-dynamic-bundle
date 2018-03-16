
package org.mauritsd.reactnativedynamicbundle;

import android.content.Context;
import android.content.SharedPreferences;
import android.net.Uri;
import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

import java.io.File;

public class RNDynamicBundleModule extends ReactContextBaseJavaModule {
  public interface OnReloadRequestedListener {
    void onReloadRequested();
  }

  private final ReactApplicationContext reactContext;
  private final SharedPreferences bundlePrefs;
  private final SharedPreferences extraPrefs;
  private OnReloadRequestedListener listener;

  /* Sadly need this to avoid a circular dependency in the ReactNativeHost
   * TODO: Refactor to avoid code duplication.
   */
  public static String launchResolveBundlePath(Context ctx) {
    SharedPreferences bundlePrefs = ctx.getSharedPreferences("_bundles", Context.MODE_PRIVATE);
    SharedPreferences extraPrefs = ctx.getSharedPreferences("_extra", Context.MODE_PRIVATE);

    String activeBundle = extraPrefs.getString("activeBundle", null);
    if (activeBundle == null) {
      return null;
    }
    return bundlePrefs.getString(activeBundle, null);
  }

  public RNDynamicBundleModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    this.bundlePrefs = reactContext.getSharedPreferences("_bundles", Context.MODE_PRIVATE);
    this.extraPrefs = reactContext.getSharedPreferences("_extra", Context.MODE_PRIVATE);
  }

  @Override
  public String getName() {
    return "RNDynamicBundle";
  }

  @ReactMethod
  public void setActiveBundle(String bundleId) {
    SharedPreferences.Editor editor = this.extraPrefs.edit();
    editor.putString("activeBundle", bundleId);
    editor.commit();
  }

  @ReactMethod
  public void registerBundle(String bundleId, String relativePath) {
    File absolutePath = new File(reactContext.getFilesDir(), relativePath);

    SharedPreferences.Editor editor = this.bundlePrefs.edit();
    editor.putString(bundleId, absolutePath.getAbsolutePath());
    editor.commit();
  }

  @ReactMethod
  public void unregisterBundle(String bundleId) {
    SharedPreferences.Editor editor = this.bundlePrefs.edit();
    editor.remove(bundleId);
    editor.commit();
  }

  @ReactMethod
  public void reloadBundle() {
    if (listener != null) {
      listener.onReloadRequested();
    }
  }

  public String resolveBundlePath() {
    String activeBundle = extraPrefs.getString("activeBundle", null);
    if (activeBundle == null) {
      return null;
    }
    return bundlePrefs.getString(activeBundle, null);
  }

  public OnReloadRequestedListener getListener() {
    return listener;
  }

  public void setListener(OnReloadRequestedListener listener) {
    this.listener = listener;
  }

}