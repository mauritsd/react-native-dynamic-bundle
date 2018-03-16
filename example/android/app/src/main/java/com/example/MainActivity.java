package com.example;

import android.content.Intent;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.ReactActivity;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.bridge.ReactContext;

import org.mauritsd.reactnativedynamicbundle.RNDynamicBundleModule;

public class MainActivity extends ReactActivity implements RNDynamicBundleModule.OnReloadRequestedListener {
    private RNDynamicBundleModule module;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        MainApplication app = (MainApplication)this.getApplicationContext();
        app.getReactNativeHost().getReactInstanceManager().addReactInstanceEventListener(new ReactInstanceManager.ReactInstanceEventListener() {
            @Override
            public void onReactContextInitialized(ReactContext context) {
                MainActivity.this.module = context.getNativeModule(RNDynamicBundleModule.class);
                module.setListener(MainActivity.this);
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();

        if (module != null) {
            module.setListener(this);
        }
    }

    /**
     * Returns the name of the main component registered from JavaScript.
     * This is used to schedule rendering of the component.
     */
    @Override
    protected String getMainComponentName() {
        return "example";
    }


    @Override
    public void onReloadRequested() {
        this.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                MainActivity.this.getReactNativeHost().clear();
                MainActivity.this.recreate();
            }
        });
    }
}
