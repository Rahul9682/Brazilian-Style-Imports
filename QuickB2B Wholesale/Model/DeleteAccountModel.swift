//  DeleteAccountModel.swift
//  THE ARTISAN BUTCHER TRADE
//  Created by Sazid Saifi on 16/08/23.

import Foundation

// MARK: - SuccessModel
struct DeleteAccountModel: Codable {
    let status: Int?
    let message: String?
    let data: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent(String.self,forKey: .data))
    }
}
