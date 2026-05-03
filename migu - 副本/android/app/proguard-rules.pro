## Flutter 基本规则
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

## 保持Hive数据库
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes Exceptions

## Hive
-keep class **$HiveFields { *; }
-keep class * extends io.flutter.plugins.hiveadapter.Adapter { *; }
-keep @io.flutter.plugins.hive.HiveType class *
-keep @io.flutter.plugins.hive.HiveField class *

## 保持模型类
-keep class com.nongduan.app.models.** { *; }
-keep class nongduan.models.** { *; }

## 保持Dio和网络请求
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes Exceptions
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions

## 保持视频播放
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**
-keep class com.shuyu.gsyvideoplayer.** { *; }
-dontwarn com.shuyu.gsyvideoplayer.**

## 保持视频库
-keep class com.arthenica.mobileffmpeg.** { *; }
-dontwarn com.arthenica.mobileffmpeg.**

## 保持缓存网络图片
-keep class com.bumptech.glide.** { *; }
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep @com.bumptech.glide.annotation.GlideModule class *
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep @com.bumptech.glide.annotation.GlideExtension class *

## 保持位置服务
-keep class com.google.android.gms.location.** { *; }
-keep class io.flutter.plugins.googlemaps.** { *; }

## 保持序列化
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes Exceptions
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes Exceptions
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes Exceptions
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes Exceptions

## 保持反射
-keepclassmembers class * {
   @com.fasterxml.jackson.annotation.* *;
}

## 避免混淆枚举
-keepclassmembers enum * {
    **[] $VALUES;
    public *;
}

## 保持本地存储
-keep class androidx.preference.** { *; }

## 保持Websocket
-keep class org.java_websocket.** { *; }
-dontwarn org.java_websocket.**

## 保持日期格式化
-keep class java.text.** { *; }

## 保持UUID生成
-keep class java.util.UUID { *; }

## 保持日志（如果需要在生产环境）
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}
