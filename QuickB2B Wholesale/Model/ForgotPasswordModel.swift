//  ForgotPasswordModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on  5/19/21.

import UIKit

struct ForgotPasswordModel: Codable {
    
    var status: Int?
    var message: String?
    var data: ForgotPasswordData?
    
    enum codingKeys: String, CodingKey{
        
        case status = "status"
        case message = "message"
        case data = "data"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent(ForgotPasswordData.self,forKey: .data))
    }
}


struct ForgotPasswordData: Codable {
    
    var password: String?
    var user_code: String?
   
    enum codingKeys: String, CodingKey{
        case password = "password"
        case user_code = "user_code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        password = try? (values.decodeIfPresent(String.self,forKey: .password))
        user_code = try? (values.decodeIfPresent(String.self,forKey: .user_code))
  
    }
}
