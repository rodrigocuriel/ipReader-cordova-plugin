# Install IP (Infinite Peripheral) iOS plugin for PhoneGap.

##### 1) Add plugin to project
1. in the project root
 ```sh
 $ phonegap plugin add <url_to_plugin_repository>
 ```
 
##### 2) Include “DTDevices.h” and “libdtdev.a” in your project under Library folder.
##### 3) “Add existing frameworks” in your project:
1. In the project navigator, select your project
2. Select the ```Build Phases``` tab
3. Open ```Link Binaries With Libraries``` expander
4. Click the ```+``` button
5. Add ```ExternalAccessory.framework```
6. Add ```MediaPlayer.framework```
7. Add ```AudioToolbox.framework```

##### 4) Edit your project .plist file 
1.right click .plist file ```open as > source code``` and add this
```
<key>UISupportedExternalAccessoryProtocols</key>
<array>
    <string>com.datecs.pinpad</string>
    <string>com.datecs.iserial.communication</string>
    <string>com.datecs.linea.pro.msr</string>
    <string>com.datecs.linea.pro.bar</string>
</array>
```