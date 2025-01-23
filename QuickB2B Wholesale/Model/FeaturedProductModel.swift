//  FeaturedProductModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/20/21.

import UIKit

struct FeaturedProductModel: Codable {
    
    var status: Int?
    var message: String?
    var data: GetFeaturedProductData?
    
    enum codingKeys: String, CodingKey{
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent(GetFeaturedProductData.self,forKey: .data))
    }
}

struct GetFeaturedProductData: Codable {
    var image: String?
    var content: String?
    var content_url: String?
    var price:String?
    var date: String?
    var visibility: String?
    var show: String?
    var on_login:String?
    var on_launch: String?
    
    enum codingKeys: String, CodingKey{
        case image = "image"
        case content = "content"
        case content_url = "content_url"
        case price = "price"
        case date = "date"
        case visibility = "visibility"
        case show = "show"
        case on_login = "on_login"
        case on_launch = "on_launch"
     
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        image = try? (values.decodeIfPresent(String.self,forKey: .image))
        content = try? (values.decodeIfPresent(String.self,forKey: .content))
        content_url = try? (values.decodeIfPresent(String.self,forKey: .content_url))
        price = try? (values.decodeIfPresent(String.self,forKey: .price))
        date = try? (values.decodeIfPresent(String.self,forKey: .date))
        visibility = try? (values.decodeIfPresent(String.self,forKey: .visibility))
        show = try? (values.decodeIfPresent(String.self,forKey: .show))
        on_login = try? (values.decodeIfPresent(String.self,forKey: .on_login))
        on_launch = try? (values.decodeIfPresent(String.self,forKey: .on_launch))
    }
}
