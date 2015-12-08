//
//  QuotaViewController.swift
//  WohnheimQuota
//
//  Created by Florian Haubold on 24.11.15.
//  Copyright © 2015 Florian Haubold. All rights reserved.
//

import Cocoa

class QuotaViewController: NSViewController {

    var quotaData: QuotaData!
    var appDelegate: AppDelegate!
    
    @IBOutlet var downloadProgress: NSProgressIndicator!
    @IBOutlet var uploadProgress: NSProgressIndicator!
    @IBOutlet var timeProgress: NSProgressIndicator!
    @IBOutlet var downloadLabel: NSTextField!
    @IBOutlet var uploadLabel: NSTextField!
    @IBOutlet var loadingIndicator: NSProgressIndicator!
    @IBOutlet var errorLabel: NSTextField!
    @IBOutlet var refreshButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        refreshData()
    }
    
    // Reloads data in background
    func refreshData() {
        loadingIndicator.hidden = false
        refreshButton.hidden = true
        loadingIndicator.startAnimation(self)
        
        let backgroundQueue = NSOperationQueue()
        backgroundQueue.addOperationWithBlock {
            
            let success = self.quotaData.loadData()
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                if (success){
                    self.setData()
                    self.appDelegate.setData(success)
                    self.errorLabel.stringValue = ""
                } else {
                    self.errorLabel.stringValue = "Sorry, keine Verbindung!"
                }
                
                self.loadingIndicator.stopAnimation(self)
                self.loadingIndicator.hidden = true
                self.refreshButton.hidden = false;
            }
        }
    }
    
    // Sets loaded data to view
    func setData() {
        downloadLabel.stringValue = quotaData.download
        downloadProgress.doubleValue = quotaData.downPercents
        uploadLabel.stringValue = quotaData.upload
        uploadProgress.doubleValue = quotaData.upPercents
        timeProgress.doubleValue = quotaData.timePercents
    }
    
    @IBAction func pressedRefreshButton(sender: AnyObject) {
        refreshData()
    }
    
    @IBAction func pressedInfoButton(sender: AnyObject) {
        let alert = NSAlert()
        alert.messageText = "Copyright by Florian Haubold 2015. No commercial use!"
        alert.addButtonWithTitle("Ok")
        let result = alert.runModal()
        switch(result) {
            case NSAlertFirstButtonReturn:
                break
            default:
                break
        }
    }
    
    @IBAction func pressedQuitButton(sender: AnyObject) {
        let alert = NSAlert()
        alert.messageText = "QuotaApp beenden?"
        alert.addButtonWithTitle("Nein")
        alert.addButtonWithTitle("Ja")
        let result = alert.runModal()
        switch(result) {
            case NSAlertFirstButtonReturn:
                break
            case NSAlertSecondButtonReturn:
                NSApplication.sharedApplication().terminate(sender)
            default:
                break
        }
        
    }
}
