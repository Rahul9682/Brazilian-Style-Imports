//  AppDetailsModel.swift
//  QuickB2BWholesale
//Created by Sazid Saifi on 20/07/21.

// MARK: - Welcome
struct AppDetailsModel: Codable {
    let status: Int?
    let message: String?
    let data: GetAppDetails?
}

// MARK: - DataClass
struct GetAppDetails: Codable {
    let appName, enableRetailFeature: String?
    let enableRegionSystem: Int?
    let regions: [ClientRegion]?

    enum CodingKeys: String, CodingKey {
        case appName = "APP_NAME"
        case enableRetailFeature = "ENABLE_RETAIL_FEATURE"
        case enableRegionSystem = "ENABLE_REGION_SYSTEM"
        case regions
    }
}

// MARK: - Region
struct ClientRegion: Codable {
    let clientCode, companyName: String?

    enum CodingKeys: String, CodingKey {
        case clientCode = "client_code"
        case companyName = "company_name"
    }
}
