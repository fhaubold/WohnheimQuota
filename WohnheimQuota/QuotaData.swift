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
    var available: Bool = false
    let url = NSURL(string: "https://quota.wohnheim.uni-kl.de")
    var download: String = ""
    var upload: String = ""
    var downPercents: Double = 0
    var upPercents: Double = 0
    var timePercents: Double = 0
    
    // constructor
    init() {
        available = loadData()
    }
    
    // function for loading data from Quota Website
    func loadData() -> Bool {
        if var html = try? NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding) {
            
            html = html.stringByReplacingOccurrencesOfString("<!--Wohnheime_incoming-->", withString: "")
            html = html.stringByReplacingOccurrencesOfString("<!--Wohnheime_outgoing-->", withString: "")
            html = html.stringByReplacingOccurrencesOfString(" <!--end-->", withString: "")
            
            var err : NSError?
            let parser = HTMLParser(html: html as String, error: &err)
            if err != nil {
                print(err)
                exit(1)
            }
           
            let headNode = parser.head
            
            if let titleNodes = headNode?.findChildTags("title") {
                for node in titleNodes {
                    if (node.contents == "403 Forbidden") {
                        return false;
                    }
                }
            }
        
            let bodyNode = parser.body
        
            let results = NSMutableArray()
            let percents = NSMutableArray()
        
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
        
            download = results[0] as! String
            upload = results[1] as! String
        
            for percent in percents {
                (percent as! String).stringByReplacingOccurrencesOfString("%", withString: "")
            }
        
            downPercents = (percents[0] as! NSString).doubleValue
            upPercents = (percents[1] as! NSString).doubleValue
            timePercents = (percents[2] as! NSString).doubleValue
            
            return true
            
        } else {
            return false
        }
    }
}
