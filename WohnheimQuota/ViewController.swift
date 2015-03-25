//
//  ViewController.swift
//  WohnheimQuota
//
//  Created by Florian Haubold on 06.01.15.
//  Copyright (c) 2015 Florian Haubold. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var downloadProgress: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let quotaData = QuotaData()
        downloadProgress.doubleValue = quotaData.downPercents
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

