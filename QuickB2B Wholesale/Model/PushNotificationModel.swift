//  PushNotificationModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 6/3/21.


struct GetPushNotificationModel: Codable {
    var result: Int?
    var message:String?
    
    enum codingKeys: String, CodingKey{
        case message = "message"
        case result = "result"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        result = try? (values.decodeIfPresent(Int.self,forKey: .result))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
    }
}
