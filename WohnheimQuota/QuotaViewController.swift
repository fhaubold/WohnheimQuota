//
//  QuotaViewController.swift
//  WohnheimQuota
//
//  Created by Florian Haubold on 24.11.15.
//  Copyright © 2015 Florian Haubold. All rights reserved.
//

import Cocoa

class QuotaViewController: NSViewController {

    var quotaData: QuotaData = QuotaData()
    
    @IBOutlet var downloadProgress: NSProgressIndicator!
    @IBOutlet var uploadProgress: NSProgressIndicator!
    @IBOutlet var timeProgress: NSProgressIndicator!
    @IBOutlet var downloadLabel: NSTextField!
    @IBOutlet var uploadLabel: NSTextField!
    @IBOutlet var loadingIndicator: NSProgressIndicator!
    @IBOutlet var errorLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }
    
    override func viewDidAppear() {
    }
    
    func refreshData() {
        loadingIndicator.hidden = false
        loadingIndicator.startAnimation(self)
        
        if (quotaData.loadData()) {
            setData()
            errorLabel.stringValue = ""
        } else {
            errorLabel.stringValue = "Sorry, keine Verbindung!"
        }
        
        loadingIndicator.stopAnimation(self)
        loadingIndicator.hidden = true
    }
    
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
    
}
