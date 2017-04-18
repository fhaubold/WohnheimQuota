//
//  QuotaData.swift
//  WohnheimQuota
//
//  Created by Florian Haubold on 25.03.15.
//  Copyright (c) 2015 Florian Haubold. All rights reserved.
//

import Foundation
import Kanna
import Alamofire

class QuotaData {
    // Basic properties
    let url = URL(string: "https://quota.wohnheim.uni-kl.de")
    var download: String = ""
    var upload: String = ""
    var downPercents: Double = 0
    var upPercents: Double = 0
    var timePercents: Double = 0
    
    func scrapeUrl(completion: @escaping (Bool) -> ()) {
        Alamofire.request(url!).responseString { response in
            if let html = response.result.value {
                self.parseHTML(html)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func parseHTML(_ html: String) -> Void {
        let percents = NSMutableArray()
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            for result in doc.xpath("//node()[preceding-sibling::comment()[. = 'Wohnheime_incoming']][following-sibling::comment()[. = 'end']]") {
                download = result.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            for result in doc.xpath("//node()[preceding-sibling::comment()[. = 'Wohnheime_outgoing']][following-sibling::comment()[. = 'end']]") {
                upload = result.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            for percentage in doc.css("td[background^='bar']") {
                let showString = percentage["width"]?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "%", with: "")
                percents.add(showString!)
                
            }
            for percentage in doc.css("td[bgcolor^='#0000cc']") {
                let showString = percentage["width"]?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "%", with: "")
                percents.add(showString!)
            }
        }
        downPercents = (percents[0] as! NSString).doubleValue
        upPercents = (percents[1] as! NSString).doubleValue
        timePercents = (percents[2] as! NSString).doubleValue
    }
    
}
