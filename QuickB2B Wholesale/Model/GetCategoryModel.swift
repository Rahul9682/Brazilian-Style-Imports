//  GetCategoryModel.swift
//  QuickB2B Wholesale
//  Created by Brain Tech on 5/14/21.

import Foundation

struct GetCategoryModel: Codable {
    var status: Int?
    var categories: [CategoryData]?
    var message:String?
    
    enum codingKeys: String, CodingKey{
       case status = "status"
       case categories = "categories"
       case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        categories = try? (values.decodeIfPresent([CategoryData].self,forKey: .categories))
    }
}

struct CategoryData: Codable {
    
    var id: String?
    var name: String?
    var isExpanded = false
    var isSlected: Bool  = false

    enum codingKeys: String, CodingKey{
        case id = "id"
        case name = "name"
   }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        id = try? (values.decodeIfPresent(String.self,forKey: .id))
        name = try? (values.decodeIfPresent(String.self,forKey: .name))
    }
    
    init () {}
}
