# MacAppAutoLogin

# 一、在项目的targets下再添加一个target

![](https://github.com/UOYO/MacAppAutoLogin/blob/master/sheet/2.png)

![](https://github.com/UOYO/MacAppAutoLogin/blob/master/sheet/3.png)

![](https://github.com/UOYO/MacAppAutoLogin/blob/master/sheet/4.png)

然后删除添加的target中Main.storyboard中的Main Menu和Window.

![](https://github.com/UOYO/MacAppAutoLogin/blob/master/sheet/5.png)

设置这个target的info和Build Setting

![](https://github.com/UOYO/MacAppAutoLogin/blob/master/sheet/6.png)

![](https://github.com/UOYO/MacAppAutoLogin/blob/master/sheet/7.png)
开启沙盒

![](https://github.com/UOYO/MacAppAutoLogin/blob/master/sheet/8.png)

在项目的target中的Build Phases中添加CopyFile到Contents/Library/LoginItems 

![](https://github.com/UOYO/MacAppAutoLogin/blob/master/sheet/9.png)

设置Build Setting

![](https://github.com/UOYO/MacAppAutoLogin/blob/master/sheet/10.png)

开启沙盒

![](https://github.com/UOYO/MacAppAutoLogin/blob/master/sheet/11.png)

# 二、添加代码
在AppDelegate或有设置按钮的地方添加代码

```
    @IBAction func appWhenLoginAction(_ sender: NSButton) {
        let state = sender.state
        
        if state == .on {
            self.startupAppWhenLogin(startup: true)
        } else {
            self.startupAppWhenLogin(startup: false)
        }
    }
    
    func startupAppWhenLogin(startup: Bool) {
        // 这里请填写你自己的Heler BundleID
        let launcherAppIdentifier = "liwei.LwWallpapersHelper"
        
        // 开始注册/取消启动项
        if SMLoginItemSetEnabled(launcherAppIdentifier as CFString, startup) {
            if startup {
                NSLog("添加登录项成功.")
            } else {
                NSLog("移除登录项成功.")
            }
        } else {
            NSLog("添加失败.")
        }
        
    
        
    }
```

在添加的target的AppDelegate添加代码

```
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        var compoents = (Bundle.main.bundlePath as NSString).pathComponents as NSArray
        compoents = compoents.subarray(with: NSMakeRange(0, compoents.count - 4)) as NSArray
        let path = NSString.path(withComponents: compoents as! [String])
        NSWorkspace.shared.launchApplication(path)
        terminate()
    }
    
    @objc func terminate() {
        NSApp.terminate(nil)
    }
```


然后导出APP运行一下，就可以了。

