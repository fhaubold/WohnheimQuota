//
//  ViewController.swift
//  WohnheimQuota
//
//  Created by Florian Haubold on 06.01.15.
//  Copyright (c) 2015 Florian Haubold. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var quotaData: QuotaData = QuotaData()
    
    @IBOutlet var downloadProgress: NSProgressIndicator!
    @IBOutlet var uploadProgress: NSProgressIndicator!
    @IBOutlet var timeProgress: NSProgressIndicator!
    @IBOutlet var downloadLabel: NSTextField!
    @IBOutlet var uploadLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    func refreshData() {
        quotaData.loadData()
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
        setData()
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

