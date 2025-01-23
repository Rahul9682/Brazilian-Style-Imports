//  FirstViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 07/06/23.

import Foundation
import UIKit

class FirstViewModel {
    //MARK: -> Properties
    var arrCategory = [CategoryData]()
    var arrItemsCategoryData  = [SearchItemsByCategoryData]()
    var searchProductData = [SearchProductData]()
    var isSearchSectionExpanded = false
    var strSearchText = ""
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
}

//MARK: -> Api-Integtaion
extension FirstViewModel {
     func getCategories(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<GetCategoryModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getCategories) else { fatalError("URL is incorrect.") }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<GetCategoryModel?>(url: url)
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
    
    //Search-Product-Details
     func searchProductDetails(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<SearchProductModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.searchProductDetails) else { fatalError("URL is incorrect.") }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<SearchProductModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        DispatchQueue.main.async {Constants.showIndicator()
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
    
    //Get-Items-By-Category
     func getItemsByCategory(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<SearchItemsByCategory?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.searchItemByCategory) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<SearchItemsByCategory?>(url: url)
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
    
    //AddProduct
     func addProduct(with param: [String: Any] ,view: UIView,completionHandler: @escaping ((Result<AddProductModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.addProduct) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<AddProductModel?>(url: url)
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
