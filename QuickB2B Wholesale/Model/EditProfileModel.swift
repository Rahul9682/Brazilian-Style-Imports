//  EditProfileModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/17/21.

import UIKit

struct EditProfileModel: Codable {
    var status: Int?
    var message: String?
    var data: EditProfileData?
    
    enum codingKeys: String, CodingKey{
        case status = "status"
        case message = "message"
        case data = "data"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent(EditProfileData.self,forKey: .data))
    }
}

struct EditProfileData: Codable {
    var APP_NAME: String?
    var user_code: String?
   
    enum codingKeys: String, CodingKey{
        case APP_NAME = "APP_NAME"
        case user_code = "user_code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        APP_NAME = try? (values.decodeIfPresent(String.self,forKey: .APP_NAME))
        user_code = try? (values.decodeIfPresent(String.self,forKey: .user_code))
    }
}
