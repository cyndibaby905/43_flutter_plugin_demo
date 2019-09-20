package com.hangchen.flutter_plugin_demo;

import android.content.Intent;
import android.net.Uri;

import java.lang.reflect.Array;
import java.lang.reflect.Method;
import java.util.ArrayList;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterPluginDemoPlugin */
public class FlutterPluginDemoPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public final Registrar registrar;

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_plugin_demo");
    channel.setMethodCallHandler(new FlutterPluginDemoPlugin(registrar));
  }

  private FlutterPluginDemoPlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("invoke")) {
      String method = call.argument("method");
      ArrayList params = call.argument("params");

      Object ret = null;

      try {
        Class<?> c = FlutterPluginDemoPlugin.class;

        Method m = null;
        if (params.size() > 0) {
          m = c.getMethod(method, ArrayList.class);
          ret = m.invoke(this,params);

        } else {
          m = c.getMethod(method);
          ret =m.invoke(this);
        }

      }
      catch(Exception e)
      {
        e.printStackTrace();
      }


      result.success(ret);
    } else {
      result.notImplemented();
    }
  }

  public String platformVersion() {
    return "Android " + android.os.Build.VERSION.RELEASE;
  }

  public void openAppStore(ArrayList param) {

    String appID = (String)param.get(0);
    Uri uri = Uri.parse("market://details?id=" + appID);
    Intent intent = new Intent(Intent.ACTION_VIEW, uri);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

    registrar.context().startActivity(intent);
  }
}
