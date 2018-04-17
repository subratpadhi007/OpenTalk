//
//  Education.swift
//  OpenTalk
//
//  Created by SUBRAT on 4/16/18.
//  Copyright © 2018 Open Talk. All rights reserved.
//

import Foundation
import ObjectMapper
class Education : Mappable {
    
    var id = 0
    var ref = "null"
    var status = 0
    var user_id = 0
    var institute_id = 0
    var is_student = "null"
    var passing_year = "null"
    var location = "null"
    var institute_name = "null"
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        ref <- map["ref"]
        status <- map["status"]
        user_id <- map["user_id"]
        institute_id <- map["institute_id"]
        is_student <- map["is_student"]
        passing_year <- map["passing_year"]
        location <- map["location"]
        institute_name <- map["institute_name"]
    }
}
