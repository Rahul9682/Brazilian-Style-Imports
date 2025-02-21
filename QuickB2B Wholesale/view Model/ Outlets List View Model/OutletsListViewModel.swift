//  OutletsListViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 05/06/23.

import Foundation
import UIKit
import SwiftyJSON

class OutletsListViewModel {
    //MARK: -> Properties
    var arrOutletsListData = [GetOutletsListData]()
    var appType = ""
    let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
    let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
    let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserDefaultLoginID) as? String ?? ""

    
    //MARK: -> Params
    func param() -> [String: Any] {
        if (customerType == "Wholesale Customer") {
            appType = KeyConstants.app_TypeDual
        } else {
            appType = KeyConstants.app_TypeRetailer
        }
        let param =  [
            GetOutletList.type.rawValue:KeyConstants.appType ,
            GetOutletList.app_type.rawValue:KeyConstants.app_Type,
            GetOutletList.client_code.rawValue:KeyConstants.clientCode ,
            //GetOutletList.client_code.rawValue:"develop" ,
            GetOutletList.user_code.rawValue:userID,
            GetOutletList.device_id.rawValue:Constants.deviceId,
            
        ] as [String : Any]
        print(param)
        return param
    }
}

//MARK: -> Api-Integration
extension OutletsListViewModel {
     func getOutletsList(with param: [String: Any], view: UIView, completionHandler: @escaping((Result<OutletsListModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getOutletsList) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<OutletsListModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        DispatchQueue.main.async { CustomActivityIndicator.showIndicator()
            view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { [self] result in
            DispatchQueue.main.async { CustomActivityIndicator.hideIndicator()
                view.isUserInteractionEnabled = true
            }
            switch result{
            case .success(_):
                completionHandler(result)
            case .failure(_):
                completionHandler(result)
            }
        }
    }
    
    func getPushNotification(with param: [String: Any],completionHandler: @escaping ((Result<GetPushNotificationModel?, NetworkError>?) -> ())) {
       print(JSON(param))
       guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getPushNotification) else { fatalError("URL is incorrect.") }
       print(url)
       guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
       var resource = Resource<GetPushNotificationModel?>(url: url)
       resource.httpMethods = .post
       resource.body = data
        DispatchQueue.main.async { CustomActivityIndicator.showIndicator()}
       WebService().load(resource: resource) { [self] result in
           DispatchQueue.main.async {CustomActivityIndicator.hideIndicator()}
           switch result{
           case .success(_):
             completionHandler(result)
           case .failure(_):
               completionHandler(result)
           }
       }
   }
}
