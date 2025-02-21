//  ChangePasswordViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 05/06/23.

import Foundation
import SwiftyJSON
import UIKit

class ChangePasswordViewModel {
    //MARK: -> Properties
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var isPopToAnotherViewController = false
    var oldPassword = ""
    var newPassword = ""
    var confirmPassword = ""
    
    //MARK: -> Params
    func param() -> [String: Any] {
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        var appType = ""
        let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
        if (customerType == "Wholesale Customer") {
            appType = KeyConstants.app_TypeDual
        } else {
            appType = KeyConstants.app_TypeRetailer
        }
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
        let param = [
            ChangePasswordParam.type.rawValue:KeyConstants.appType ,
            ChangePasswordParam.app_type.rawValue:appType,
            ChangePasswordParam.client_code.rawValue:KeyConstants.clientCode ,
            ChangePasswordParam.user_code.rawValue:userID ,
            ChangePasswordParam.current_password.rawValue:oldPassword,
            ChangePasswordParam.new_password.rawValue:newPassword,
            ChangePasswordParam.confirm_password.rawValue:confirmPassword,
            ChangePasswordParam.device_id.rawValue:Constants.deviceId
        ] as [String : Any]
        print(param)
        return param
    }
    
    //MARK: - Validations
    func validations() -> String? {
        if oldPassword.count == 0 {
            return passMsgEn
        } else if newPassword.count == 0 {
            return newPassMsgEn
        } else if newPassword.count < 6 {
            return newPassLength
        } else if confirmPassword.count == 0 {
            return cnfPassMsgEn
        } else if(newPassword != confirmPassword) {
            return passwordAndConfirmMatchEn
        }
        return nil
    }
}

//MARK: -> Api-Integration
extension ChangePasswordViewModel {
     func changePassword(with param: [String: Any], view: UIView,completionHandler: @escaping ((Result<ChangePasswordModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.changePassword) else { fatalError("URL is incorrect.") }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<ChangePasswordModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        DispatchQueue.main.async { CustomActivityIndicator.showIndicator()
            view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { result in
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
}
