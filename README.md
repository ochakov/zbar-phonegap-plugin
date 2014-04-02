zbar-phonegap-plugin
========================

Supported paltforms
------
* iOS
* Android

Android notices
------
### Libs
* https://github.com/dm77/barcodescanner

### Changes
1. Namespace of libs changed (changed at the begining of development, really, no reason).
2. Changed names of "res" files (to prevent possible conflicts).
3. Hidden "Title Bar" for camera activity.
4. Replaced res access (plugin has no access to Cordova application package).

For example, instead of
```java
R.color.viewfinder_mask
```
use
```java
String PACKAGE_NAME = context.getPackageName();
Resources resources = getResources();
resources.getIdentifier("viewfinder_mask", "color", PACKAGE_NAME);
```

License
------
Apache License, Version 2.0

Credits
------
(c) [Citronium](http://citronium.com), 2014

