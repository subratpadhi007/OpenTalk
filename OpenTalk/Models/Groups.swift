//
//  Groups.swift
//  OpenTalk
//
//  Created by SUBRAT on 4/17/18.
//  Copyright © 2018 Open Talk. All rights reserved.
//

import Foundation
import ObjectMapper
class Groups : Mappable {
    
    var group_name = ""
    var group_id = 0
    var group_logo = ""
    var group_category_id = 0
    var group_description = ""
    var who_can_verify = 0
    var group_type = 0
    var status = 0
    var user_role = 0
    var user_type = ""
    var tags : Array<Tag>?
    var answers : Array<Answers>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_name <- map["group_name"]
        group_id <- map["group_id"]
        group_logo <- map["group_logo"]
        group_category_id <- map["group_category_id"]
        group_description <- map["group_description"]
        who_can_verify <- map["who_can_verify"]
        group_type <- map["group_type"]
        status <- map["status"]
        user_role <- map["user_role"]
        user_type <- map["user_type"]
        tags <- map["tags"]
        answers <- map["answers"]

    }
}


class Tag: Mappable{
    var status = 0
    var tag_id = 0
    var tag_name = ""
    var is_common = true
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        tag_id <- map["tag_id"]
        tag_name <- map["tag_name"]
        is_common <- map["is_common"]
        
    }
}

class Answers: Mappable{
    var id = 0
    var groupId = 0
    var answer = ""
    var question = ""
    var type = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        groupId <- map["groupId"]
        answer <- map["answer"]
        question <- map["question"]
        type <- map["type"]
    }
}
