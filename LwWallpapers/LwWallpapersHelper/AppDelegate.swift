//
//  AppDelegate.swift
//  LwWallpapersHelper
//
//  Created by 李伟 on 2017/12/4.
//  Copyright © 2017年 liwei. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        var compoents = (Bundle.main.bundlePath as NSString).pathComponents as NSArray
        compoents = compoents.subarray(with: NSMakeRange(0, compoents.count - 4)) as NSArray
        let path = NSString.path(withComponents: compoents as! [String])
        NSWorkspace.shared.launchApplication(path)
        terminate()
//        let LwWallpapersIdentifier = "liwei.LwWallpapers"
//        let running = NSWorkspace.shared.runningApplications
//        var alreadyRunning = false
//
//        for app in running {
//            if app.bundleIdentifier == LwWallpapersIdentifier {
//                alreadyRunning = true
//                break
//            }
//        }
//
//        if !alreadyRunning {
//            DistributedNotificationCenter.default().addObserver(self, selector: #selector(terminate), name: NSNotification.Name(rawValue: "killhelper"), object: LwWallpapersIdentifier)
//
//            let path = Bundle.main.bundlePath as NSString
//            var components = path.pathComponents
//            components.removeLast()
//            components.removeLast()
//            components.removeLast()
//
//            components.append("MacOS")
//            components.append("LwWallpapers")
//
//            let newPath = NSString.path(withComponents: components)
//            NSWorkspace.shared.launchApplication(newPath)
//        } else {
//            self.terminate()
//        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func terminate() {
        NSApp.terminate(nil)
    }


}

