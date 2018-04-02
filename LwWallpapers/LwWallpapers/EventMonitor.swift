//
//  EventMonitor.swift
//  LwWallpapers
//
//  Created by 李伟 on 2017/12/12.
//  Copyright © 2017年 liwei. All rights reserved.
//

import Cocoa

class EventMonitor{
    private var monitor: AnyObject?
    private var mask: NSEvent.EventTypeMask
    private var handler: (NSEvent?) -> ()
    
    init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> ()) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    func start(){
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject?
    }
    
    func stop(){
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}

