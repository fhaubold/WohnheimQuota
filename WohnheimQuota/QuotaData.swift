//
//  QuotaData.swift
//  WohnheimQuota
//
//  Created by Florian Haubold on 25.03.15.
//  Copyright (c) 2015 Florian Haubold. All rights reserved.
//

import Foundation

class QuotaData {
    // Basic properties
    let url = NSURL(string: "https://quota.wohnheim.uni-kl.de")
    var download: String = ""
    var upload: String = ""
    var downPercents: Double = 0
    var upPercents: Int = 0
    var timePercents: Int = 0
    
    // constructor
    init() {
        loadData()
    }
    
    // function for loading data from Quota Website
    func loadData() {
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
        
        var bodyNode = parser.body
        
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
        
        download = results[0] as String
        upload = results[1] as String
        
        for percent in percents {
            (percent as String).stringByReplacingOccurrencesOfString("%", withString: "")
        }
        
        downPercents = (percents[0] as NSString).doubleValue
        upPercents = (percents[1] as String).toInt()!
        timePercents = (percents[2] as String).toInt()!
    }
}
