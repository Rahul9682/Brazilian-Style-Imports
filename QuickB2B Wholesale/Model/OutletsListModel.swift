//  OutletsListModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/27/21.

import UIKit

struct OutletsListModel: Codable {
    var status: Int?
    var data: [GetOutletsListData]?
    var message: String?
    
    enum codingKeys: String, CodingKey{
        case status = "status"
        case data = "data"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        data = try? (values.decodeIfPresent([GetOutletsListData].self,forKey: .data))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
    }
}


struct GetOutletsListData: Codable {
    var user_code: String?
    var name: String?
    var isSelected: Bool = false
   
    enum codingKeys: String, CodingKey{
        case user_code = "user_code"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        user_code = try? (values.decodeIfPresent(String.self,forKey: .user_code))
        name = try? (values.decodeIfPresent(String.self,forKey: .name))
    }
}

