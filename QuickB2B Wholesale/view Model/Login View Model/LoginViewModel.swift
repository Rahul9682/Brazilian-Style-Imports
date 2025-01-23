//  LoginViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 05/06/23.

import Foundation
import SwiftyJSON

class LoginViewModel {
    //MARK: -> Properties
    var db:DBHelper = DBHelper()
    var logoutString = ""
    var arrSuppliers = [[String:Any]]()
    var strCustomerID = ""
    var strPassword = ""
    let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
    
    //MARK: -> Params
    func param() -> [String: Any] {
        let param = [
            login.type.rawValue:KeyConstants.appType ,
            login.app_type.rawValue:KeyConstants.app_Type,
            login.client_code.rawValue:KeyConstants.clientCode,
            login.username.rawValue:strCustomerID,
            login.password.rawValue:strPassword,
            login.device_id.rawValue:Constants.deviceId] as [String : Any]
        print(param)
        return param
    }
    
    //MARK: - Validations
    func validations() -> String? {
        let id = strCustomerID.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = strPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        if id.count == 0 {
            return customerIDMsgg
        } else if password.count == 0 {
            return passwordMsgg
        }
        return nil
    }
}

// MARK: API Integration
extension LoginViewModel {
     func loginUser(with param: [String: Any], view: UIView,completionHandler: @escaping ((Result<Login?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.login) else { fatalError("URL is incorrect.") }
        print(JSON(param))
        print(url)
        
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<Login?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { Constants.showIndicator()
            view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { result in
            DispatchQueue.main.async { Constants.hideIndicator()
                view.isUserInteractionEnabled = true
            }
            switch result {
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
        WebService().load(resource: resource) { [self] result in
            switch result{
            case .success(let getPushNotificationData):
              completionHandler(result)
            case .failure(let error):
                completionHandler(result)
            }
        }
    }
}
