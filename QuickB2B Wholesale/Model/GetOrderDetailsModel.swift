//  GetOrderDetailsModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/18/21.

import Foundation

struct GetOrderDetailsModel: Codable {
    var status: Int?
    var message: String?
    var data: [GetOrderDetailsData]?
    
    enum codingKeys: String, CodingKey{
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent([GetOrderDetailsData].self,forKey: .data))
    }
}

struct GetOrderDetailsData: Codable {
    var order_id: String?
    var inventory_name: String?
    var quantity: String?
   
    enum codingKeys: String, CodingKey{
        case order_id = "order_id"
        case inventory_name = "inventory_name"
        case quantity = "quantity"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        
        order_id = try? (values.decodeIfPresent(String.self,forKey: .order_id))
        inventory_name = try? (values.decodeIfPresent(String.self,forKey: .inventory_name))
        quantity = try? (values.decodeIfPresent(String.self,forKey: .quantity))
    }
}
