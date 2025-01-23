//  FetchUserOrderModel.swift
//  QuickB2B Wholesale
//  Created by Sazid Saifi on 5/18/23.


import Foundation

struct FetchUserOrderModel: Codable {
    var status: Int?
    var message: String?
    var data: [FetchUserData]?
    
    enum codingKeys: String, CodingKey{
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent([FetchUserData].self,forKey: .data))
    }
}

struct FetchUserData: Codable {
    var order_id: String?
    var order_date: String?
    var order_time: String?
    var isExpanded = false
    var delivery_date: String?
    var status: String?
    var shipped_Date: String?
   
    enum codingKeys: String, CodingKey{
        case order_id = "order_id"
        case order_date = "order_date"
        case order_time = "order_time"
        case delivery_date = "delivery_date"
        case status = "status"
        case shipped_Date = "shipped_date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        order_id = try? (values.decodeIfPresent(String.self,forKey: .order_id))
        order_date = try? (values.decodeIfPresent(String.self,forKey: .order_date))
        order_time = try? (values.decodeIfPresent(String.self,forKey: .order_time))
        delivery_date = try? (values.decodeIfPresent(String.self,forKey: .delivery_date))
        status = try? (values.decodeIfPresent(String.self,forKey: .status))
        shipped_Date = try? (values.decodeIfPresent(String.self,forKey: .shipped_Date))
    }
}
