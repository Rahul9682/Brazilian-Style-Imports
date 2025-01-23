//  GetInformationModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/19/21.


import UIKit

struct GetInformationModel: Codable {
    var status: Int?
    var message: String?
    var data: GetInformationData?
    
    enum codingKeys: String, CodingKey{
        case status = "status"
        case message = "message"
        case data = "data"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent(GetInformationData.self,forKey: .data))
    }
}

struct GetInformationData: Codable {
    var CmsPage: GetCMSInformation?
   
    enum codingKeys: String, CodingKey{
        case CmsPage = "CmsPage"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        CmsPage = try? (values.decodeIfPresent(GetCMSInformation.self,forKey: .CmsPage))
    }
}

struct GetCMSInformation: Codable {
    var id: String?
    var title: String?
    var text: String?
   
    enum codingKeys: String, CodingKey{
        case id = "id"
        case title = "title"
        case text = "text"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        id = try? (values.decodeIfPresent(String.self,forKey: .id))
        title = try? (values.decodeIfPresent(String.self,forKey: .title))
        text = try? (values.decodeIfPresent(String.self,forKey: .text))
    }
}
