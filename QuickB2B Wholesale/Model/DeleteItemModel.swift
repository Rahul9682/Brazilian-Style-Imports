//  DeleteItemModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/24/21.

import Foundation

struct DeleteItemModel: Codable {
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

struct ConfirmOrderModel: Codable {
    var status: Int?
    var message: String?
    let data: [GetItemsData]?
    
    enum codingKeys: String, CodingKey{
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent([GetItemsData].self,forKey: .data))
    }
}


