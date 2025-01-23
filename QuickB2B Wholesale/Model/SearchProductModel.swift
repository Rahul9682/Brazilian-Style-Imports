//  SearchProductModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/15/21.

import UIKit

struct SearchProductModel: Codable {
    
    var status: Int?
    var show_price: String?
    var message: String?
    var data: [SearchProductData]?
    
    enum codingKeys: String, CodingKey{
        
        case status = "status"
        case show_price = "show_price"
        case message = "message"
        case data = "data"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        show_price = try? (values.decodeIfPresent(String.self,forKey: .show_price))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent([SearchProductData].self,forKey: .data))
    }
}

struct SearchProductData: Codable {
    
    var id: String?
    var item_code: String?
    var item_name: String?
    var item_price: String?
    var status: String?
    var image_description: String?
    var image: String?
    var thumb_image: String?


    enum codingKeys: String, CodingKey{
        case id = "id"
        case item_code = "item_code"
        case item_name = "item_name"
        case item_price = "item_price"
        case status = "status"
        case image_description = "image_description"
        case image = "image"
        case thumb_image = "thumb_image"
  
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        
        id = try? (values.decodeIfPresent(String.self,forKey: .id))
        item_code = try? (values.decodeIfPresent(String.self,forKey: .item_code))
        item_name = try? (values.decodeIfPresent(String.self,forKey: .item_name))
        item_price = try? (values.decodeIfPresent(String.self,forKey: .item_price))
        status = try? (values.decodeIfPresent(String.self,forKey: .status))
        image_description = try? (values.decodeIfPresent(String.self,forKey: .image_description))
        image = try? (values.decodeIfPresent(String.self,forKey: .image))
        thumb_image = try? (values.decodeIfPresent(String.self,forKey: .thumb_image))
    
    }
}
