//
//  Profile.swift
//  OpenTalk
//
//  Created by SUBRAT on 4/16/18.
//  Copyright © 2018 Open Talk. All rights reserved.
//

import Foundation
import ObjectMapper
class Profile: Mappable {
    var tags = "null"
    var name = "null"
    var is_student = "null"
    var profile_pic = "null"
    var email = "null"
    var level = 0
    var language = "null"
    var display_location = "null"
    var un_points = 0
    var unique_id = "null"
    var opentalk_id = "null"
    var opentalk_id_url = "null"
    var opentalk_id_request_url = "null"
    var total_gems = 0
    var total_cookies = "null"
    var gender = "null"
    var notification = 0
    var user_activity_analysis : UserActivity?
    var compliments: Array<Compliments>?
    var level_name = "null"
    var education : Array<Education>?
    var map_data : MapData?
    var profile_attributes = "null"
    var groups : Array<Groups>?
    var is_opentalk_id_enabled = "null"
    var is_linkedin_connected = "null"
    var professional_box = "null"
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    

    func mapping(map: Map) {
        tags <- map["tags"]
        name <- map["name"]
        is_student <- map["is_student"]
        profile_pic <- map["profile_pic"]
        email <- map["email"]
        level <- map["level"]
        language <- map["language"]
        display_location <- map["display_location"]
        un_points <- map["un_points"]
        unique_id <- map["unique_id"]
        opentalk_id <- map["opentalk_id"]
        opentalk_id_url <- map["opentalk_id_url"]
        opentalk_id_request_url <- map["opentalk_id_request_url"]
        total_gems <- map["total_gems"]
        total_cookies <- map["total_cookies"]
        gender <- map["gender"]
        notification <- map["notification"]
        user_activity_analysis <- map["user_activity_analysis"]
        compliments <- map["compliments"]
        level_name <- map["level_name"]
        education <- map["education"]
        map_data <- map["map_data"]
        profile_attributes <- map["profile_attributes"]
        groups <- map["groups"]
        is_opentalk_id_enabled <- map["is_opentalk_id_enabled"]
        is_linkedin_connected <- map["is_linkedin_connected"]
        professional_box <- map["professional_box"]
        
    }
}

class MapData: Mappable{
    var country_count = 0
    var geo_chart = ""
    var total_call = 0
    
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        country_count <- map["country_count"]
        geo_chart <- map["geo_chart"]
        total_call <- map["total_call"]
    }
}
