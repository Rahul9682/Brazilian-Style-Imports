//  UserDefaultsHelper.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 18/07/23.

import Foundation

class LocalStorage {
    //*****************========********************//
    //MARK: -> save-Get-Items-Data
    static func saveItemsData(data: [GetItemsData]) {
      //  if data.count > 0 {
            do {
                let encodedData = try JSONEncoder().encode(data)
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(encodedData, forKey: UserDefaultsKeys.getItemsData)
                print("Successfully Saved")
            } catch {
                // Failed to encode Contact to Data
                print("Failed to encode [GetItemsData] to Data")
            }
       // }
    }
    
    
    static func saveRegionData(data: [ClientRegion]) {
      //  if data.count > 0 {
            do {
                let encodedData = try JSONEncoder().encode(data)
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(encodedData, forKey: UserDefaultsKeys.clientRegion)
                print("Successfully Saved")
            } catch {
                // Failed to encode Contact to Data
                print("Failed to encode [GetItemsData] to Data")
            }
       // }
    }
    
    static func saveMultiData(data: [GetItemsData]) {
      //  if data.count > 0 {
            do {
                let encodedData = try JSONEncoder().encode(data)
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(encodedData, forKey: UserDefaultsKeys.showList)
                print("Successfully Saved")
            } catch {
                // Failed to encode Contact to Data
                print("Failed to encode [GetItemsData] to Data")
            }
       // }
    }
    
    //MARK: -> get-GetItemsData
//    static func getItemsData() -> [GetItemsData] {
//        let userDefaults = UserDefaults.standard
//        var getItemsData: [GetItemsData]?
//        if let savedData = userDefaults.value(forKey: UserDefaultsKeys.getItemsData) as? Data {
//            do {
//                let savedgetItemsData = try JSONDecoder().decode([GetItemsData].self, from: savedData)
//                getItemsData = savedgetItemsData
//                print("Successfully Retrievd")
//            } catch {
//                print("Failed to Convert to Data")
//            }
//        }
//        return getItemsData ?? []
//    }
    
    //MARK: -> get-GetItemsData
    static func getItemsData() -> [GetItemsData] {
        let userDefaults = UserDefaults.standard
        var getItemsData = [GetItemsData]()
        if let savedData = userDefaults.value(forKey: UserDefaultsKeys.getItemsData) as? Data {
            do {
                let savedgetItemsData = try JSONDecoder().decode([GetItemsData].self, from: savedData)
                getItemsData = savedgetItemsData
                print("Successfully Retrievd")
            } catch {
                print("Failed to Convert to Data")
            }
            return getItemsData
        } else {
            return []
        }
    }
    
    //MARK: -> getClientRegionData
    static func getClientRegionData() -> [ClientRegion] {
        let userDefaults = UserDefaults.standard
        var getItemsData = [ClientRegion]()
        if let savedData = userDefaults.value(forKey: UserDefaultsKeys.clientRegion) as? Data {
            do {
                let savedgetItemsData = try JSONDecoder().decode([ClientRegion].self, from: savedData)
                getItemsData = savedgetItemsData
                print("Successfully Retrievd")
            } catch {
                print("Failed to Convert to Data")
            }
            return getItemsData
        } else {
            return []
        }
    }
    
    //MARK: -> get-GetItemsData
    static func getShowItData() -> [GetItemsData] {
        let userDefaults = UserDefaults.standard
        var getItemsData = [GetItemsData]()
        if let savedData = userDefaults.value(forKey: UserDefaultsKeys.showList) as? Data {
            do {
                let savedgetItemsData = try JSONDecoder().decode([GetItemsData].self, from: savedData)
                getItemsData = savedgetItemsData
                print("Successfully Retrievd")
            } catch {
                print("Failed to Convert to Data")
            }
            return getItemsData
        } else {
            return []
        }
    }
    
    //MARK: -> Delete-Get-Items-Data
    static func clearItemsData(){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: UserDefaultsKeys.getItemsData)
    }
    
    static func clearMultiItemsData(){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: UserDefaultsKeys.showList)
        
    }
    
//    //MARK: -> Delete-Get-Items-Data
    static func deleteGetItemsIndex(itemCode: String) {
        var localData = self.getItemsData()
        if let index = localData.firstIndex(where: {$0.item_code == itemCode}) {
            localData.remove(at: index)
        }
        self.saveItemsData(data: localData)
    }
    static func deleteMultiItemsIndex(itemCode: String) {
        var localData = self.getShowItData()
        localData.removeAll(where: { $0.item_code == itemCode })
        self.saveMultiData(data: localData)
    }
    
    
    
    //MARK: -> Get-Filtered-Data
    static func getFilteredData() -> [GetItemsData] {
        let data = LocalStorage.getItemsData()
        var filteredData = data.filter({ $0.originQty != "" && $0.originQty != "0" && $0.originQty != "0.0" && $0.originQty != "0.00"})
        return filteredData
    }
    
    //MARK: -> Get-Filtered-Multi-Data
    static func getFilteredMultiData() -> [GetItemsData] {
        let data = LocalStorage.getShowItData()
        var filteredData = data.filter({ $0.originQty != "" && $0.originQty != "0" && $0.originQty != "0.0" && $0.originQty != "0.00"})
        return filteredData
    }
}



//MARK: -> Save Outlets List
extension LocalStorage {
    static func saveOutletsListData(data: [GetOutletsListData]) {
        if data.count > 0 {
            do {
                let encodedData = try JSONEncoder().encode(data)
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(encodedData, forKey: UserDefaultsKeys.outletsListData)
                print("Successfully Saved")
            } catch {
                // Failed to encode Contact to Data
                print("Failed to encode [GetItemsData] to Data")
            }
        }
    }
    
    //MARK: -> get-OutletsListData
    static func getOutletsListData() -> [GetOutletsListData] {
        let userDefaults = UserDefaults.standard
        var getItemsData = [GetOutletsListData]()
        if let savedData = userDefaults.value(forKey: UserDefaultsKeys.outletsListData) as? Data {
            do {
                let savedgetItemsData = try JSONDecoder().decode([GetOutletsListData].self, from: savedData)
                getItemsData = savedgetItemsData
                print("Successfully Retrievd")
            } catch {
                print("Failed to Convert to Data")
            }
            return getItemsData
        } else {
            return []
        }
    }
}
