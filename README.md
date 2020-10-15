# XLog

----
## Log
<br/>

Disable log to file (default true)
``` Swift
XLog.Configuration.logToFile = false
```
<br/>

Let’s log!
``` Swift
XLog.log("1/ Default category = .app, type = .default - Message")
XLog.log(type: .default, "2/ Default category = .app, - Message")
XLog.log(category: .app, type: .default, "3/ Message")

XLog.log(category: .auth, type: .debug, "4/ Without options")
XLog.log(category: .api, type: .info, "5/ Without options", options: [])
XLog.log(category: .auth, type: .fault, "6/ With function", options: [.function])
XLog.log(category: .api, type: .error, "7/ With fileAndLine", options: [.fileAndLine])
XLog.log(category: .app, type: .default, "8/ With all options", options: [.all])
```
``` HTML
2020-10-15 09:32:54.428037+0700 XLog[51738:16352794] [APP] ✍️ DEFAULT: 1/ Default category = .app, type = .default - Message
2020-10-15 09:32:54.429086+0700 XLog[51738:16352794] [APP] ✍️ DEFAULT: 2/ Default category = .app, - Message
2020-10-15 09:32:54.430019+0700 XLog[51738:16352794] [APP] ✍️ DEFAULT: 3/ Message

2020-10-15 09:32:54.430935+0700 XLog[51738:16352794] [AUTH] 💬 DEBUG: 4/ Without options
2020-10-15 09:32:54.431844+0700 XLog[51738:16352794] [API] ℹ️ INFO: 5/ Without options
2020-10-15 09:32:54.433889+0700 XLog[51738:16352794] [AUTH] 🔥 FAULT: [testLog()] - 6/ With function
2020-10-15 09:32:54.435216+0700 XLog[51738:16352794] [API] ❌ ERROR: [ViewController.swift:63] - 7/ With fileAndLine
2020-10-15 09:32:54.436309+0700 XLog[51738:16352794] [APP] ✍️ DEFAULT: [ViewController.swift:64 testLog()] - 8/ With all options
```
<br/>

Quick log app info
``` Swift
XLog.logAppInfo()
```
``` HTML
2020-10-15 09:32:54.368109+0700 XLog[51738:16352794] [APP] ℹ️ INFO: ==============================
2020-10-15 09:32:54.412519+0700 XLog[51738:16352794] [APP] ℹ️ INFO: ✳️ Time : 2020-10-15 02:32:54 +0000
2020-10-15 09:32:54.413888+0700 XLog[51738:16352794] [APP] ℹ️ INFO: ✳️ Device Name : iPhone 11 - MODEL : iPhone
2020-10-15 09:32:54.414755+0700 XLog[51738:16352794] [APP] ℹ️ INFO: ✳️ Environment : DEBUG
2020-10-15 09:32:54.420426+0700 XLog[51738:16352794] [APP] ℹ️ INFO: ✳️ UUID : A635E689-2C01-420D-862D-FB36380D87F7
2020-10-15 09:32:54.424407+0700 XLog[51738:16352794] [APP] ℹ️ INFO: ✳️ App Name : XLog - Version : 1.0 (Build : 1)
2020-10-15 09:32:54.425681+0700 XLog[51738:16352794] [APP] ℹ️ INFO: ✳️ Sub System : ER.XLog
2020-10-15 09:32:54.426799+0700 XLog[51738:16352794] [APP] ℹ️ INFO: ==============================
```

Config more category log
``` Swift
extension XLog.Category {
    static let auth = XLog.Category("AUTH")
    static let socket = XLog.Category("SOCKET")
}
```
<br/>

## Debug menu
<br/>

Let's debug
``` Swift
XDebug.Configuration.debugMenuEnable = true
```
<br/>

Config more row
``` Swift
extension DebugMenuRow.RowID {
    static let test1 = DebugMenuRow.RowID("test1")
    static let test2 = DebugMenuRow.RowID("test2")
    static let test3 = DebugMenuRow.RowID("test3")
}
```
``` Swift
XDebug.Configuration.debugMenuDelegate = self

XDebug.Configuration.debugMenuTableRows.append(DebugMenuRow(id: .test1,
                                                            title: "Test 1"))
XDebug.Configuration.debugMenuTableRows.append(DebugMenuRow(id: .test2 ,
                                                            title: "Test 2",
                                                            type: .defaultRow(detailText: "Detail")))
XDebug.Configuration.debugMenuTableRows.append(DebugMenuRow(id: .test3,
                                                            title: "Test 3",
                                                            type: .switchRow(isOn: false, target: self, selfAction: #selector(self.switchAction))))
```
``` Swift
extension ViewController: DebugMenuDelegate {
    
    func didSelectRow(_ id: DebugMenuRow.RowID, on vc: UIViewController) {
        switch id {
        case .test1:
            vc.navigationController?.pushViewController(DebugInfoViewController(), animated: true)
        case .test2:
            let alertController = UIAlertController(title: "Title",
                                                    message: "Message!",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            vc.present(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
    
}
```
