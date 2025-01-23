//  ReOrderModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 20/07/23.

import Foundation

// MARK: - SaveCartsModel
struct ReOrderModel: Codable {
    let message: String?
    let all_inventories: [GetItemsData]?
    let multi_items:[GetItemsData]?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case all_inventories = "all_inventories"
        case multi_items = "multi_items"
    }
}
