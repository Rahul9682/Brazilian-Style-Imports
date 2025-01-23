//  FetchLinksModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/19/21.


import UIKit

struct FetchLinksModel: Codable {
    var status: Int?
    var message: String?
    var data: GetFetchLinksData?
    
    enum codingKeys: String, CodingKey{
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent(GetFetchLinksData.self,forKey: .data))
    }
}

struct GetFetchLinksData: Codable {
    var repFlag: String?
    var representatives:GetRepresentatives?
    var websites:[GetWebsitesData]?
    var pdf:[GetPdfData]?
    var links:[GetLinksData]?
    var statementEmail: String?
    
    enum codingKeys: String, CodingKey{
        case repFlag = "repFlag"
        case representatives = "representatives"
        case websites = "websites"
        case pdf = "pdf"
        case links = "links"
        case statementEmail = "statementEmail"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        repFlag = try? (values.decodeIfPresent(String.self,forKey: .repFlag))
        representatives = try? (values.decodeIfPresent(GetRepresentatives.self,forKey: .representatives))
        websites = try? (values.decodeIfPresent([GetWebsitesData].self,forKey: .websites))
        pdf = try? (values.decodeIfPresent([GetPdfData].self,forKey: .pdf))
        links = try? (values.decodeIfPresent([GetLinksData].self,forKey: .links))
        statementEmail = try? (values.decodeIfPresent(String.self,forKey: .statementEmail))
    }
}

struct GetRepresentatives: Codable {
    var email: String?
    var phone: String?
    
    enum codingKeys: String, CodingKey{
        case email = "email"
        case phone = "phone"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        email = try? (values.decodeIfPresent(String.self,forKey: .email))
        phone = try? (values.decodeIfPresent(String.self,forKey: .phone))
    }
}

struct GetWebsitesData: Codable {
    var type: String?
    var title: String?
    var link: String?
    
    enum codingKeys: String, CodingKey{
        case type = "type"
        case title = "title"
        case link = "link"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        type = try? (values.decodeIfPresent(String.self,forKey: .type))
        title = try? (values.decodeIfPresent(String.self,forKey: .title))
        link = try? (values.decodeIfPresent(String.self,forKey: .link))
    }
}

struct GetPdfData: Codable {
    var type: String?
    var title: String?
    var link: String?
    
    enum codingKeys: String, CodingKey{
        case type = "type"
        case title = "title"
        case link = "link"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        type = try? (values.decodeIfPresent(String.self,forKey: .type))
        title = try? (values.decodeIfPresent(String.self,forKey: .title))
        link = try? (values.decodeIfPresent(String.self,forKey: .link))
    }
}

struct GetLinksData: Codable {
    var type: String?
    var title: String?
    var link: String?
    
    enum codingKeys: String, CodingKey{
        case type = "type"
        case title = "title"
        case link = "link"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        type = try? (values.decodeIfPresent(String.self,forKey: .type))
        title = try? (values.decodeIfPresent(String.self,forKey: .title))
        link = try? (values.decodeIfPresent(String.self,forKey: .link))
    }
}
