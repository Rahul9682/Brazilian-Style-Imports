//  ChangePasswordModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/18/21.

import Foundation

struct ChangePasswordModel : Codable {
    var status: Int?
    var message: String?
     
    enum codingKeys: String, CodingKey{
        case status = "status"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
    }
}
