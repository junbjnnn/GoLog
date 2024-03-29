# GoLog

## Installation
To install via CocoaPods add this lines to your Podfile.
```
pod 'GoLog', '0.0.4'
```
## Setup
Example setup
``` Swift
let menu = [
    GoLog.AddOnDebugMenu(menuId: .custom(key: "test1"), title: "Test 1"), 
    GoLog.AddOnDebugMenu(menuId: .custom(key: "test2"), title: "Test 2"),
    GoLog.AddOnDebugMenu(menuId: .custom(key: "test3"), title: "Test 3", style: .switchRow(isOn: false))
]
let userDefaults = [
    GoLog.LocalUserDefaultsKey(key: "ud_key_1"), 
    GoLog.LocalUserDefaultsKey(key: "ud_key_2")
]
let config = GoLog.Configuration(
    logToFile: true,
    debugAppInfoText: "Show more app info",
    addOnDebugMenu: menu,
    userDefaultsKeys: userDefaults
)
GoLog.setup(with: config, debugMenuDelegate: self)
```
## Debug menu
Let's debug
``` Swift
GoLog.showDebugMenu = true
```

### Let’s log!
``` Swift
GoLog.log("1/ Default category = .app, type = .default - Message")
GoLog.log(type: .default, "2/ Default category = .app, - Message")
GoLog.log(category: .app, type: .default, "3/ Message")

GoLog.log(category: .auth, type: .debug, "4/ Without options")
GoLog.log(category: .api, type: .info, "5/ Without options", options: [])
GoLog.log(category: .auth, type: .fault, "6/ With function", options: [.function])
GoLog.log(category: .api, type: .error, "7/ With fileAndLine", options: [.fileAndLine])
GoLog.log(category: .app, type: .default, "8/ With all options", options: [.all])
```
``` HTML
2020-10-15 09:32:54.428037+0700 GoLog[51738:16352794] [APP] ✍️ DEFAULT: 1/ Default category = .app, type = .default - Message
2020-10-15 09:32:54.429086+0700 GoLog[51738:16352794] [APP] ✍️ DEFAULT: 2/ Default category = .app, - Message
2020-10-15 09:32:54.430019+0700 GoLog[51738:16352794] [APP] ✍️ DEFAULT: 3/ Message

2020-10-15 09:32:54.430935+0700 GoLog[51738:16352794] [AUTH] 💬 DEBUG: 4/ Without options
2020-10-15 09:32:54.431844+0700 GoLog[51738:16352794] [API] ℹ️ INFO: 5/ Without options
2020-10-15 09:32:54.433889+0700 GoLog[51738:16352794] [AUTH] 🔥 FAULT: [testLog()] - 6/ With function
2020-10-15 09:32:54.435216+0700 GoLog[51738:16352794] [API] ❌ ERROR: [ViewController.swift:63] - 7/ With fileAndLine
2020-10-15 09:32:54.436309+0700 GoLog[51738:16352794] [APP] ✍️ DEFAULT: [ViewController.swift:64 testLog()] - 8/ With all options
```

Quick log app info
``` Swift
GoLog.logAppInfo()
```
``` HTML
2020-10-15 09:32:54.368109+0700 GoLog[51738:16352794] [APP] ℹ️ INFO: ==============================
2020-10-15 09:32:54.412519+0700 GoLog[51738:16352794] [APP] ℹ️ INFO: ✳️ Time : 2020-10-15 02:32:54 +0000
2020-10-15 09:32:54.413888+0700 GoLog[51738:16352794] [APP] ℹ️ INFO: ✳️ Device Name : iPhone 11 - MODEL : iPhone
2020-10-15 09:32:54.414755+0700 GoLog[51738:16352794] [APP] ℹ️ INFO: ✳️ Environment : DEBUG
2020-10-15 09:32:54.420426+0700 GoLog[51738:16352794] [APP] ℹ️ INFO: ✳️ UUID : A635E689-2C01-420D-862D-FB36380D87F7
2020-10-15 09:32:54.424407+0700 GoLog[51738:16352794] [APP] ℹ️ INFO: ✳️ App Name : GoLog - Version : 1.0 (Build : 1)
2020-10-15 09:32:54.425681+0700 GoLog[51738:16352794] [APP] ℹ️ INFO: ✳️ Sub System : ER.GoLog
2020-10-15 09:32:54.426799+0700 GoLog[51738:16352794] [APP] ℹ️ INFO: ==============================
```

Config more category log
``` Swift
extension GoLog.Category {
    static let auth = GoLog.Category("AUTH")
    static let socket = GoLog.Category("SOCKET")
}
```
