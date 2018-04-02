//
//  BarViewController.swift
//  LwWallpapers
//
//  Created by 李伟 on 2017/12/4.
//  Copyright © 2017年 liwei. All rights reserved.
//

import Cocoa
import ServiceManagement

class BarViewController: NSViewController {

    @IBOutlet weak var bulrSlider: NSSlider!
    @IBOutlet weak var refreshImage: NSButton!
    @IBOutlet weak var bg_image: NSImageView!
    var isLoad = false
    @IBOutlet weak var load_pro: NSProgressIndicator!
    @IBOutlet weak var updataTimeButton: NSPopUpButton!
    @IBOutlet weak var ImageBlur: NSButton!
    @IBOutlet weak var dateLabel: NSTextField!
    
    @IBOutlet weak var checkBlur: NSButton!
    @IBOutlet weak var isLoginWhenCheckBox: NSButton!
    var userdefault: UserDefaults? = nil
    var down_image_url = "http://pic1.win4000.com/wallpaper/a/57807418f0b65.jpg"
    var temp = 0
    var showImage: NSImage!
    var showImageData: Data!
    
    lazy var context: CIContext = {
        return CIContext(options: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userdefault = UserDefaults.standard
        
        
        dateLabel.stringValue = "\(weekDay()) \(nowDay())"
        
        if userdefault?.object(forKey: "updateTime") == nil {
            userdefault?.set(1, forKey: "updateTime")
        } else {
            let tag = userdefault?.object(forKey: "updateTime") as! Int
            updataTimeButton.selectItem(at: tag - 1)
        }
        
        if userdefault?.object(forKey: "isblur") != nil {
            // tag 1  开启高斯模糊
            let tag = userdefault?.object(forKey: "isblur") as! Int
            if tag == 1 {
                checkBlur.state = .on
                bulrSlider.isHidden = false
            } else {
                checkBlur.state = .off
            }
        } else {
            checkBlur.state = .off
            userdefault?.set(0, forKey: "isblur")
        }
        
        if userdefault?.object(forKey: "isAppWhenLogin") != nil {
            
            let isAppWhenLogin = userdefault?.object(forKey: "isAppWhenLogin") as! Bool
            
            if isAppWhenLogin {
                isLoginWhenCheckBox.state = .on
            } else {
                isLoginWhenCheckBox.state = .off
            }
        }
        if userdefault?.object(forKey: "temp_numder") != nil {
            let temp_numder = userdefault?.object(forKey: "temp_numder") as! Int
            ShowImage(temp_numder, isPro: false)
        } else {
            ShowImage(0, isPro: false)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.setUpdataImage), name: NSNotification.Name(rawValue: "update_image"), object: nil)
    }
    
    func nowDay() -> String {
        let date = Date()
        let dateFor = DateFormatter()
        dateFor.dateFormat = "MM-dd"
        return dateFor.string(from: date)
    }
    
    func weekDay() -> String {
        let weekDays = [NSNull.init(),"星期日","星期一","星期二","星期三","星期四","星期五","星期六"] as [Any]
        let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        let timeZone = NSTimeZone.init(name: "Asia/Shanghai")
        calendar?.timeZone = timeZone! as TimeZone
        let calendarUnit = NSCalendar.Unit.weekday
        let theComponents = calendar?.components(calendarUnit, from: Date())
        return weekDays[(theComponents?.weekday)!] as! String
    }
    
    @IBAction func setImageUpdataTime(_ sender: NSPopUpButton) {
        userdefault?.set(sender.selectedItem?.tag, forKey: "updateTime")
    }
    @IBAction func setBgImageAction(_ sender: NSButton) {
        if self.checkBlur.state == .on {
            let fileManager = FileManager.default
            let saveDirectory = NSURL(fileURLWithPath: fileManager.homeDirectoryForCurrentUser.path+"/Pictures/LwWallpapersFile/") as URL
            do {
                try fileManager.createDirectory(at: saveDirectory, withIntermediateDirectories: true, attributes: [:])
            } catch let error {
                print(error)
            }
            //要保存的路径
            let downloadURL = saveDirectory.appendingPathComponent("\(Date()).jpg")
            do {
                try self.bg_image.image?.tiffRepresentation?.write(to: downloadURL)
            } catch let error {
                print(error)
            }
            DownImage.shared().setBg(fileName: downloadURL)
        } else {
            DownImage.shared().urlSessionDownloadFileTest(urlStr: down_image_url)
        }
    }
    
    @IBAction func refreshImageAction(_ sender: NSButton) {
        if !isLoad {
            isLoad = true
            self.load_pro.isHidden = false
            self.load_pro.startAnimation(nil)
            self.temp = Int(arc4random()%UInt32((ImageURL.image_url.count - 1)))+1
            
            userdefault?.set(self.temp, forKey: "temp_numder")
            ShowImage(self.temp, isPro: true)
        }
        
    }
    
    @objc func setUpdataImage() {
        if userdefault?.object(forKey: "temp_numder") != nil {
            let temp_numder = userdefault?.object(forKey: "temp_numder") as! Int
            ShowImage(temp_numder, isPro: false)
        } else {
            ShowImage(0, isPro: false)
        }
    }
    
    @IBAction func ImageBlurAction(_ sender: NSButton) {
        if sender.state == .on {
            setBlurImage(value: Int(bulrSlider.intValue))
            userdefault?.set(1, forKey: "isblur")
            bulrSlider.isHidden = false
        } else {
            setBlurImage(value: 0)
            bulrSlider.isHidden = true
            userdefault?.set(0, forKey: "isblur")
        }
    }
    @IBAction func BulrSliderAction(_ sender: NSSlider) {
        setBlurImage(value: Int(sender.intValue))
    }
    
    func setBlurImage(value: Int) {
        let oimage = CIImage(data: self.showImageData)
        
        let imageView1 = NSImageView()
        imageView1.image = NSImage(data: self.showImageData)
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(oimage, forKey: kCIInputImageKey)
        filter?.setValue(value, forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage
        let rect = CGRect(origin: .zero, size: imageView1.fittingSize)
        let cgImage = context.createCGImage(outputImage!, from: rect)
        
        self.bg_image.image = NSImage(cgImage: cgImage!, size: imageView1.fittingSize)
    }
    
    @IBAction func exitApp(_ sender: NSButton) {
        NSApp.terminate(nil)
    }
    func ShowImage(_ temp: Int, isPro: Bool) {
        self.down_image_url = ImageURL.image_url[temp]
        let request = URLRequest(url: URL(string: down_image_url)!)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                print(error.debugDescription)
            }else{
                //将图片数据赋予NSImage
                self.showImage = NSImage(data: data!)
                self.showImageData = data!
                
                // 这里需要改UI，需要回到主线程
                DispatchQueue.main.async {
                    self.bg_image.image = self.showImage
                    self.bg_image.imageScaling = .scaleAxesIndependently
                    if self.checkBlur.state == .on {
                        self.setBlurImage(value: Int(self.bulrSlider.intValue))
                    }
                    if isPro {
                        self.isLoad = false
                        self.load_pro.stopAnimation(nil)
                        self.load_pro.isHidden = true
                    }
                }
                
            }
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
    }
    
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
            self.userdefault?.set(startup, forKey: "isAppWhenLogin")
            if startup {
                NSLog("Successfully add login item.")
            } else {
                NSLog("Successfully remove login item.")
            }
        } else {
            NSLog("Failed to add login item.")
            self.userdefault?.set(false, forKey: "isAppWhenLogin")
        }
        
    }
    
}
