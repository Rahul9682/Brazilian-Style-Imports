//  CreateAnAccountViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 07/06/23.

import Foundation
import UIKit

class CreateAnAccountViewModel {
    //MARK: -> Properties
    var deliveryType = SelectDeliveryType.Business
    var isPostalAddressSame = false
    var arrSuppliers = [[String:Any]]()
    var db:DBHelper = DBHelper()
}

//MARK: -> Api-Integration
extension CreateAnAccountViewModel {
    //Get-App-Data
    func getAppData(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<AppDetailModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getAppData) else { fatalError("URL is incorrect.") }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<AppDetailModel?>(url: url)
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
    
    //get-Push-Notification
    func getPushNotification(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<GetPushNotificationModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getPushNotification) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<GetPushNotificationModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        WebService().load(resource: resource) { [self] result in
            
            switch result{
            case .success(_):
                completionHandler(result)
            case .failure(_):
                completionHandler(result)
            }
        }
    }
    
    //sign-Up
    func signUp(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<SignUpModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.signUp) else { fatalError("URL is incorrect.") }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<SignUpModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { Constants.showIndicator()
            view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { [self] result in
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
