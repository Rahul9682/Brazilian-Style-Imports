//  ForgotPasswordViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 05/06/23.

import Foundation
import SwiftyJSON

class ForgotPasswordViewModel {
    //MARK: -> Properties
    var customerID = ""
    
    //MARK: -> Params
    func param() -> [String: Any] {
        let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String  ?? ""
        let param = [
            ForgotPasswordParam.type.rawValue:KeyConstants.appType ,
            ForgotPasswordParam.app_type.rawValue:KeyConstants.app_Type,
            ForgotPasswordParam.client_code.rawValue:KeyConstants.clientCode ,
            ForgotPasswordParam.username.rawValue:customerID,
            ForgotPasswordParam.device_id.rawValue:Constants.deviceId] as [String : Any]
        print("Request Param:: ",JSON(param))
        return param
    }
    
    //MARK: -> Validations
    func validation() -> String? {
        if customerID.count == 0 {
            return customerIDMsgg
        }
        return nil
    }
}

// MARK: API Integration
extension ForgotPasswordViewModel {
     func resetPassword(with param: [String: Any], view: UIView,completionHandler: @escaping ((Result<ForgotPasswordModel?, NetworkError>?) -> ())) {
        print(JSON(param))
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.forgotPassword) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<ForgotPasswordModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { Constants.showIndicator()
            view.isUserInteractionEnabled = false
        }
        
        WebService().load(resource: resource) { result in
            DispatchQueue.main.async { Constants.hideIndicator()
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
