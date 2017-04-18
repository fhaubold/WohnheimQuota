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
        NSApplication.shared().activate(ignoringOtherApps: true)
    }
    
    // Reloads data in background
    func refreshData() {
        loadingIndicator.isHidden = false
        refreshButton.isHidden = true
        loadingIndicator.startAnimation(self)
        
        let backgroundQueue = OperationQueue()
        backgroundQueue.addOperation {
            
            self.quotaData.scrapeUrl() { response in
                if response {
                    self.updateUi(success: true)
                } else {
                    self.updateUi(success: false)
                }
            }
        }
    }
    
    func updateUi(success: Bool) {
            if (success){
                self.setData()
                self.appDelegate.setData(success: success)
                self.errorLabel.stringValue = ""
            } else {
                self.errorLabel.stringValue = "Sorry, keine Verbindung!"
            }
            
            self.loadingIndicator.stopAnimation(self)
            self.loadingIndicator.isHidden = true
            self.refreshButton.isHidden = false;
    }
    
    // Sets loaded data to view
    func setData() {
        downloadLabel.stringValue = quotaData.download
        downloadProgress.doubleValue = quotaData.downPercents
        uploadLabel.stringValue = quotaData.upload
        uploadProgress.doubleValue = quotaData.upPercents
        timeProgress.doubleValue = quotaData.timePercents
    }
    
    @IBAction func pressedRefreshButton(_ sender: AnyObject) {
        refreshData()
    }
    
    @IBAction func pressedInfoButton(_ sender: AnyObject) {
        let alert = NSAlert()
        alert.messageText = "Copyright by Florian Haubold 2017. No commercial use!"
        alert.addButton(withTitle: "Ok")
        let result = alert.runModal()
        switch(result) {
            case NSAlertFirstButtonReturn:
                break
            default:
                break
        }
    }
    
    @IBAction func pressedQuitButton(_ sender: AnyObject) {
        let alert = NSAlert()
        alert.messageText = "QuotaApp beenden?"
        alert.addButton(withTitle: "Nein")
        alert.addButton(withTitle: "Ja")
        let result = alert.runModal()
        switch(result) {
            case NSAlertFirstButtonReturn:
                break
            case NSAlertSecondButtonReturn:
                NSApplication.shared().terminate(sender)
            default:
                break
        }
        
    }
}
