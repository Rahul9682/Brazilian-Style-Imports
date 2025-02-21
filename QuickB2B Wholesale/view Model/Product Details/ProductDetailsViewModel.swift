//  ProductDetailsViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 16/06/23.

import Foundation
import SwiftyJSON

class ProductDetailsViewModel {
    var itemCode = ""
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var arrayOfLocalStorageItems = LocalStorage.getItemsData()
    var floatTotalPrice :Float! = 0.0

   
    //MARK: -> Param
    func AddProductParam() -> [String: Any?] {
        let userCode = UserDefaults.standard.value(forKey:UserDefaultsKeys.UserLoginID) as? String
        let param = [addProductParam.user_code.rawValue: userCode,
                     addProductParam.client_code.rawValue: KeyConstants.clientCode,
                     addProductParam.item_code.rawValue: itemCode,
                     addProductParam.device_id.rawValue: Constants.deviceId] as [String : Any?]
        print(JSON(param))
        return param
    }
}

//MARK: -> Api- Calling
extension ProductDetailsViewModel {
    //AddProduct
    func addProduct(with param: [String: Any] ,view: UIView,completionHandler: @escaping ((Result<AddProductModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.addProduct) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<AddProductModel?>(url: url)
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
    
    //update-Product-List
    func updateProductList(with param: [String: Any], view: UIView,completionHandler: @escaping ((Result<DeleteItemModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.updateUserProductList) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<DeleteItemModel?>(url: url)
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
    
    //Get-Product-Details
    func getProductDetails(with itemCode:String, view: UIView,completionHandler: @escaping ((Result<ProductDetailsModel?, NetworkError>?) -> ())){
        let clientCode = KeyConstants.clientCode//UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
           let userCode = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""//"20TANK"
           let deviceId = Constants.deviceId
           let itemCode = itemCode
       var testUrl = (GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.productDetailV3 + "?client_code=" + "\(clientCode)" + "&user_code=" + userCode + "&device_id=" + deviceId + "&itemCode=" + itemCode)
        print(testUrl)
        var resource = Resource<ProductDetailsModel?>(url: URL(string: testUrl)!)
        resource.httpMethods = .get
        
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
    
    
    //Delete-Item
    func deleteItem(with param: [String: Any],view:UIView,itemCode:String, completionHandler: @escaping ((Result<DeleteItemModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.deleteItemAPI) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<DeleteItemModel?>(url: url)
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
            case .failure(let error):
                completionHandler(result)
            }
        }
    }
}

