//
//  UserActivity.swift
//  OpenTalk
//
//  Created by SUBRAT on 4/17/18.
//  Copyright © 2018 Open Talk. All rights reserved.
//

import Foundation
import ObjectMapper

class UserActivity : Mappable{
    var userId = 0
    var total_talktime = 0
    var total_call = 0
    var thumb_up = 0
    var thumb_down = 0
    var minutes_1_of_call = 0
    var minutes_5_of_call = 0
    var total_cookies_earned = 0
    var total_gems_used = 0
    var minutes_of_call = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        total_talktime <- map["total_talktime"]
        total_call <- map["total_call"]
        thumb_up <- map["thumb_up"]
        thumb_down <- map["thumb_down"]
        minutes_1_of_call <- map["1_minutes_of_call"]
        minutes_5_of_call <- map["5_minutes_of_call"]
        total_cookies_earned <- map["total_cookies_earned"]
        total_gems_used <- map["total_gems_used"]
        minutes_of_call <- map["minutes_of_call"]
    }
}

class Compliments: Mappable{
    var icon = ""
    var color = ""
    var rating_id = 0
    var rating_text = ""
    var rating_count = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        icon <- map["icon"]
        color <- map["color"]
        rating_id <- map["rating_id"]
        rating_text <- map["rating_text"]
        rating_count <- map["rating_count"]
    }

}
