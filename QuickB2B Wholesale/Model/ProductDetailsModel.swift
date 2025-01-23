//  ProductDetailsModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 28/07/23.

import Foundation

// MARK: - ProductDetailsModel
struct ProductDetailsModel: Codable {
    let message: String?
    let data: GetItemsData?
    
    enum codingKeys: String, CodingKey{
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent(GetItemsData.self,forKey: .data))
    }
}
