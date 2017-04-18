//
//  AppDelegate.swift
//  WohnheimQuota
//
//  Created by Florian Haubold on 06.01.15.
//  Copyright (c) 2015 Florian Haubold. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    var quotaData: QuotaData = QuotaData()

    @IBOutlet weak var statusMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        refreshData()
        
        if let button = statusItem.button {
            button.action = #selector(AppDelegate.togglePopover(_:))
            button.title = "Q "
        }
        
        popover.contentViewController = QuotaViewController(nibName: "QuotaViewController", bundle: nil)
        let popoverViewController:QuotaViewController = popover.contentViewController as! QuotaViewController
        popoverViewController.quotaData = quotaData
        popoverViewController.appDelegate = self
        
        _ = Timer.scheduledTimer(timeInterval: 900.0, target: self, selector: #selector(AppDelegate.refreshData), userInfo: nil, repeats: true)
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
    }
    
    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func setData(success: Bool) {
        if let button = statusItem.button {
            if (success) {
                button.title = "Q " + String(format:"%.0f", quotaData.downPercents) + "%"
            } else {
                button.title = "Q ?%"
            }
        }
    }
    
    func refreshData() {
        let backgroundQueue = OperationQueue()
        backgroundQueue.addOperation {
            self.quotaData.scrapeUrl() { response in
                if response {
                    self.setData(success: true)
                } else {
                    self.setData(success: false)
                }
            }
        }
    }
}

