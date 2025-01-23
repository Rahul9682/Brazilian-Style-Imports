//  GetFeaturedImageModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 6/1/21.

import UIKit

struct FeaturedImageModel: Codable {
    var status: Int?
    var featured_item_image:String?
    
    enum codingKeys: String, CodingKey{
        case status = "status"
        case featured_item_image = "featured_item_image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        featured_item_image = try? (values.decodeIfPresent(String.self,forKey: .featured_item_image))
    }
}

