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
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    var quotaData: QuotaData = QuotaData()

    @IBOutlet weak var statusMenu: NSMenu!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        refreshData()
        
        if let button = statusItem.button {
            button.action = Selector("togglePopover:")
            button.title = "Q "
        }
        
        popover.contentViewController = QuotaViewController(nibName: "QuotaViewController", bundle: nil)
        let popoverViewController:QuotaViewController = popover.contentViewController as! QuotaViewController
        popoverViewController.quotaData = quotaData
        popoverViewController.appDelegate = self
        
        _ = NSTimer.scheduledTimerWithTimeInterval(900.0, target: self, selector: "refreshData", userInfo: nil, repeats: true)
        
        eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) { [unowned self] event in
            if self.popover.shown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
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
        let backgroundQueue = NSOperationQueue()
        backgroundQueue.addOperationWithBlock {
            
            let success = self.quotaData.loadData()
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.setData(success)
            }
        }

    }


}

