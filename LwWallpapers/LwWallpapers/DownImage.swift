//
//  DownImage.swift
//  LwWallpapers
//
//  Created by 李伟 on 2017/12/12.
//  Copyright © 2017年 liwei. All rights reserved.
//

import Cocoa
import Foundation



class DownImage: NSObject {
    
    
    let defaultConfigObject = URLSessionConfiguration.default
    static let instance = DownImage()
    
    class func shared() -> DownImage{
        return instance
    }
    
    func urlSessionDownloadFileTest(urlStr: String) {
        //创建session 指定代理和任务队列
        let session = URLSession(configuration: defaultConfigObject, delegate: self, delegateQueue: OperationQueue.main)
        //指定需要下载的文件URL路径
        let url = URL(string: urlStr)!
        //创建Download任务
        let task = session.downloadTask(with: url)
        task.resume()
    }
    func setBg(fileName: URL){
        do {
            let workpace = NSWorkspace.shared
            if let screen = NSScreen.main {
                try workpace.setDesktopImageURL(fileName, for: screen, options: [:])
            }
        } catch  {
            print(error)
        }
    }
    
}

extension DownImage: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //获取原始的文件名
        let fileName = downloadTask.originalRequest?.url?.lastPathComponent

        let fileManager = FileManager.default
        let saveDirectory = NSURL(fileURLWithPath: fileManager.homeDirectoryForCurrentUser.path+"/Pictures/LwWallpapersFile/") as URL
        do {
            try fileManager.createDirectory(at: saveDirectory, withIntermediateDirectories: true, attributes: [:])
        } catch let error {
            print(error)
        }
        //要保存的路径
        let downloadURL = saveDirectory.appendingPathComponent(fileName!)

        //从下载的临时路径移动到期望的路径
        do {
            if !fileManager.fileExists(atPath: downloadURL.path) {
                try fileManager.moveItem(at: location, to: downloadURL)
            }
            setBg(fileName: downloadURL)
        } catch let error {
            print("error \(error)")
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        print("receive bytes \(bytesWritten) of totalBytes \(totalBytesExpectedToWrite)")
    }


    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {

//        print("resumeAtOffset  bytes \(fileOffset) of totalBytes \(expectedTotalBytes)")
    }
}

