//
//  AppDelegate.swift
//  LwWallpapers
//
//  Created by 李伟 on 2017/12/3.
//  Copyright © 2017年 liwei. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var status = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var item = NSStatusItem()
    var timer: Timer?
    var userdefault: UserDefaults? = nil
    var temp = 0
    var em: EventMonitor?
    
    lazy var bvc: BarViewController = {
        let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "bvc"))
        return vc as! BarViewController
    }()
    
    lazy var popover: NSPopover = {
        let po = NSPopover()
        po.contentViewController = bvc
        po.behavior = .semitransient
        return po
    }()
    
    var isShow = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if status.button != nil {
            status.button?.image = NSImage(imageLiteralResourceName: "bar_black_Template")
//            status.button?.alternateImage = NSImage(imageLiteralResourceName: "bar_white")
            status.button?.target = self
            status.button?.action = #selector(showView(_:))
        }
        userdefault = UserDefaults.standard
        item = status
        
        em = EventMonitor(mask: [.leftMouseUp,.rightMouseUp], handler: { (event) in
            self.closePopover()
        })
        
        timerImage()
    }
    
    
    func closePopover(){
        popover.close()
        isShow = false
        em?.stop()
    }
    
    @IBAction func showView(_ sender: NSStatusBarButton){
        if isShow {
            closePopover()
        }else{
            isShow = true
            popover.show(relativeTo: NSZeroRect, of: sender, preferredEdge: .minY)
            em?.start()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    
    func timerImage(){
        let tag = userdefault?.object(forKey: "updateTime")
        if tag != nil {
            let newtag = tag as! Int
            var time = 0
            switch newtag {
            case 1:
                time = 60 * 60 * 24
                break
            case 2:
                time = 60 * 60 * 24 * 7
                break
            case 3:
                time = 60 * 60 * 24 * 30
                break
            default:
                break
            }
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(self.setImage), userInfo: nil, repeats: true)
        } else {
            let time = 60 * 60 * 24
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(self.setImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func setImage() {
        self.temp = Int(arc4random()%UInt32((ImageURL.image_url.count - 1)))+1
        
        userdefault?.set(self.temp, forKey: "temp_numder")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update_image"), object: nil)
        let down_image_url = ImageURL.image_url[self.temp]
        DownImage.shared().urlSessionDownloadFileTest(urlStr: down_image_url)
    }


}

