//  AccountDetailsVCViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 07/06/23.

import Foundation
import UIKit

class AccountDetailsVCViewModel {
    //MARK: -> Properties
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var profileData:GetProfileData?
    var arrayOfChips = [AccountChipsData]()
    var floatTotalPrice :Float! = 0.0
    var arrayOfLocalStorageItems = LocalStorage.getItemsData()
}

//MARK: -> Api-Integration
extension AccountDetailsVCViewModel {
    //Get-Profile-Details
    func getProfileDetails(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<GetProfileModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getProfile) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<GetProfileModel?>(url: url)
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
    
    //save-Delivery-Details
    func saveDeliveryDetails(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<EditProfileModel?, NetworkError>?) -> ())) {
        view.endEditing(true)
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.editBusinessDetails) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<EditProfileModel?>(url: url)
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
    
    //Save-Postal-Details
    func savePostalDetails(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<EditProfileModel?, NetworkError>?) -> ())) {
        view.endEditing(true)
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.editPostalDetails) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<EditProfileModel?>(url: url)
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
    
    //save-Business-Details
    func saveBusinessDetails(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<EditProfileModel?, NetworkError>?) -> ())) {
        view.endEditing(true)
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.editProfileContactDetails) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<EditProfileModel?>(url: url)
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
