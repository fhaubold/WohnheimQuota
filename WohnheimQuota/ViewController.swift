//
//  ViewController.swift
//  WohnheimQuota
//
//  Created by Florian Haubold on 06.01.15.
//  Copyright (c) 2015 Florian Haubold. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var html: NSString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://quota.wohnheim.uni-kl.de")
        
        var html = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: nil)!
        
        html = html.stringByReplacingOccurrencesOfString("<!--Wohnheime_incoming-->", withString: "")
        html = html.stringByReplacingOccurrencesOfString("<!--Wohnheime_outgoing-->", withString: "")
        html = html.stringByReplacingOccurrencesOfString(" <!--end-->", withString: "")

        var err : NSError?
        var parser = HTMLParser(html: html, error: &err)
        if err != nil {
            println(err)
            exit(1)
        }
        
        var bodyNode   = parser.body
        
        var results = NSMutableArray()
        var percents = NSMutableArray()
        
        if let inputNodes = bodyNode?.findChildTags("td") {
            for node in inputNodes {
                results.addObject(node.contents)
                if (node.getAttributeNamed("title") as NSString != "") {
                    percents.addObject(node.getAttributeNamed("title"))
                }
            }
        }

        let indexSet = NSMutableIndexSet()
        for var j=0; j<6; j++ {
            indexSet.addIndex(j)
        }
        indexSet.addIndex(7)
        indexSet.addIndex(8)
        
        results.removeObjectsAtIndexes(indexSet)
        
        let download: String = results[0] as String
        let upload: String = results[1] as String
        
        for percent in percents {
            (percent as String).stringByReplacingOccurrencesOfString("%", withString: "")
        }
        
        let downpercents: Int = (percents[0] as String).toInt()!
        let uppercents: Int = (percents[1] as String).toInt()!
        let timepercents: Int = (percents[2] as String).toInt()!
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

