//  GetAppDetail.swift
//  QuickB2B Wholesale
//  Created by Sazid Saifi on 07/06/23.

import UIKit

import Foundation

struct AppDetailModel: Codable {
    
    var status: Int?
    var message: String?
    var data: AppData?
    
    enum codingKeys: String, CodingKey{
        
        case status = "status"
        case message = "message"
        case data = "data"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent(AppData.self,forKey: .data))
    }
}
struct AppData: Codable {
    
    var APP_NAME: String?
    var ENABLE_RETAIL_FEATURE: String?
   
    enum codingKeys: String, CodingKey{
        case APP_NAME = "APP_NAME"
        case ENABLE_RETAIL_FEATURE = "ENABLE_RETAIL_FEATURE"
    
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        
        APP_NAME = try? (values.decodeIfPresent(String.self,forKey: .APP_NAME))
        ENABLE_RETAIL_FEATURE = try? (values.decodeIfPresent(String.self,forKey: .ENABLE_RETAIL_FEATURE))
    }
}
