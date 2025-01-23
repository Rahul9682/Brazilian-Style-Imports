//  AppDetailsModel.swift
//  QuickB2BWholesale
//Created by Sazid Saifi on 20/07/21.


struct AppDetailsModel: Codable {
    
    var status: Int?
    var data: GetAppDetails?
    var message: String?
    
    enum codingKeys: String, CodingKey{
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent(GetAppDetails.self,forKey: .data))
    }
}


struct GetAppDetails: Codable {
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
   
