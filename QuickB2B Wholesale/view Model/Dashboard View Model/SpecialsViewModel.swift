//  SpecialsViewModel.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 24/04/23.

import Foundation
import SwiftyJSON

class SpecialsViewModel {
    //MARK: -> Properties
    var homeData: HomeData?
    var arrayOfCategory = [AllCategory]()
    var arrayOfListItems = [GetItemsData]()
    var arrayOfNewListItems = [GetItemsData]()
    var showImage = "0"
    var floatTotalPrice :Float! = 0.0
    var showPrice = ""
    var isCategoryExist: Bool = false
    var arrayOfLocalStorageItems = LocalStorage.getItemsData()

    //MARK: Helpers
    func param() -> [String: Any?] {
        let userCode = UserDefaults.standard.value(forKey:UserDefaultsKeys.UserLoginID) as? String
        let param = [homeParam.user_code.rawValue: userCode,
                     homeParam.client_code.rawValue: KeyConstants.clientCode,
                     homeParam.device_id.rawValue: Constants.deviceId] as [String : Any?]
        print(JSON(param))
        return param
    }
}

//MARK: -> Api-Integration
extension SpecialsViewModel {
    func getHomeData(with param: [String: Any], completionHandler: @escaping ((HomeModel?, String?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.home) else { fatalError("URL is incorrect.") }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        print("url:-", url)
        var resource = Resource<HomeModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { Constants.showIndicator() }
        WebService().load(resource: resource) { result in
            DispatchQueue.main.async { Constants.hideIndicator() }
            
            switch result {
            case .success(let data):
                if let data = data {
                    completionHandler(data, nil)
                }
            case .failure(let error):
                let error = error.localizedDescription
                completionHandler(nil, error)
            }
        }
    }
    
    //update-Product-List
    func updateProductList(with param: [String: Any], view: UIView,completionHandler: @escaping ((Result<DeleteItemModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.updateUserProductList) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<DeleteItemModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
//        DispatchQueue.main.async { Constants.showIndicator()
//            view.isUserInteractionEnabled = false
//        }
        WebService().load(resource: resource) { [self] result in
//            DispatchQueue.main.async { Constants.hideIndicator()
//                view.isUserInteractionEnabled = true
//            }
            switch result{
            case .success(_):
                completionHandler(result)
            case .failure(_):
                completionHandler(result)
            }
        }
    }
}
