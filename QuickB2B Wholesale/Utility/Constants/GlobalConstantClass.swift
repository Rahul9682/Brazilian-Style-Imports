
import Foundation
import UIKit
//import MBProgressHUD
import SwiftyJSON

class GlobalConstantClass: NSObject {
    static let sharedInstance = GlobalConstantClass()
    //MARK: - Date Formatters
    let dateFormatter1 = "yyyy-MM-dd HH:mm:ss Z"
    let dateFormatter2 = "dd-MM-yyyy"
    //var arrOfPageData = [ServicesData]()
    
    struct APIConstantNames {
        // MARK: - Testing-Url
      //  static let baseUrl = "https://develop.quickb2b.com/v3/apis/"
        
        // MARK: - APPStore-Live-Url
        static let baseUrl = "https://go.quickb2b.com/v3/apis/"
        
        //MARK: - API
        static let getPushNotification = "get_device.json"
        static let getCountries = "api/country-list"
        static let signUp = "ac/customer/registration"
        static let getFeaturedItem = "getFeaturedItem.json"
        static let login = "ac/loginNew"
        static let getAppData  =  "getCompanydetails.json"
        static let getCategories = "GetCategories.json"
        static let searchItemByCategory = "search_product_bycategory.json"
        static let searchProductDetails = "search_product_detaill.json"
        static let addProduct = "user_item_add_v6.json"
        static let getProfile = "get_profile.json"
        static let editProfileContactDetails = "edit_profile_contact_detail.json"
        static let editBusinessDetails = "update_business_detail.json"
        static let editPostalDetails = "update_postal_detail.json"
        static let changePassword = "change_password.json"
        static let forgotPassword = "forgot_password.json"
        static let fetchUserOrder = "get_user_order.json"
        static let getOrderDetails = "get_user_order_detail.json"
        static let getInformation = "app_cms.json"
        static let fetchLinks = "linksPost.json"
        static  let featuredProduct = "feature_product.json"
        static let getItems  = "get_user_items_v3_4"//"get_user_items.json"
        static let deleteItemAPI = "user_item_delete_v6.json"
        static let getOutletsList = "get_outlets.json"
        static let confirmOrder = "order.json"
        static let getCompanyDetails = "getCompanydetails.json"
        static let deleteAccount = "delete-account"
        //********/////
        static let V3 = "v3/"
        static let home = "get_home_items_v6.json"
        static let searchItemByCategoryNew = "search_product_bycategory_new.json"
        static let searchItemByCategoryV3 = "search_product_bycategory_v3_4.json"
        static let cartItemsV3 = "cart_list_v6"
        static let reOrder = "reorder_v6"
        static let productDetailV3 = "product_detail_v3"
        static let getCategoriesV3 = "GetCategories_v3_4.json"
        static let fetchUserOrderV3 = "get_user_order_v3.json"
        static let updateUserProductList = "update_user_inventory_v6.json"
        static let confirmOrderV3 = "order_v6.json"
        static let AppStoreUrl = "https://apps.apple.com/au/app/quickb2b/id1413748196"//"https://apps.apple.com/us/app/thaizzle/id1464113241"
        static let customerList = "ac/customerList"
        static let customerDetails = "ac/customerDetails"
        static let emailApiForMunja = "email_api_for_munja"
    }
}

//MARK: - Key Constants
struct KeyConstants {
    static let appType = "Dual"
    static let app_Type = "Dual"
    static let app_TypeDual = "Dual"
    static let app_TypeRetailer = "Retailer"
    static let app_code = "app_code"
    
    //MARK: - Testing-Client-Code
    //static let clientCode = "DEVELOP"
    //    static let clientCode = UserDefaults.standard.string(forKey: UserDefaultsKeys.clientRegionCode) ?? "b2bdev"
    static var clientCode: String {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.clientRegionCode) ?? "XX3955"  // "ZP5986"
    }
    //static let clientCode = "TK3757"
    //static let clientCode = "PEZZANO"
    //static let clientCode = "MC5739"
    //MARK: - QUICKB2B-Cleint-Code-Live
    //static let clientCode = "quickb2b"
    //static let clientCode = "TZ2129"
    
    
    
}

struct UserDefaultsKeys {
    //static let homeData = "homeData"
    static let getItemsData = "getItemsData"
    static let showRegion = "showRegion"
    static let showList = "ShowList"
    static let clientRegion = "clientRegion"
    static let clientRegionCode = "clientRegionCode"
    static let showPrice = "showPrice"
    static let AppName = "AppName"  
    static let business_name = "business_name"
    
    static let UserDefaultLoginID = "UserDefaultLoginID"
    static let acmLoginID = "acmLoginID"
    static let CustomerType = "CustomerType"
    static let UserLoginID = "UserLoginID"
    static let CurrencySymbol = "CurrencySymbol"
    static let orderFlag = "orderFlag"
    static let isShowFeaturedImageOnDashboard = "isShowFeaturedImageOnDashboard"
    static let CurrentDate = "CurrentDate"
    static let Date = "Date"
    static let selectedRadioButtonType = "selectedRadioButtonType"
    static let SelectedDate = "SelectedDate"
    static let ponumber = "ponumber"
    static let comment = "comment"
    static let showAppBanner = "showAppBanner"
    static let showItemInGrid = "showItemInGrid"
    static let CommonSearchText = "CommonSearchText"
    static let outletsListData = "outletsListData"
    static let isShowUpdateAppPopUp = "isShowUpdateAppPopUp"
    static let isComeFromBanner = "isComeFromBanner"
    static let isResetList = "isResetList"
}

//MARK: - Alert Message
let customerIDMsgg = "Please enter Customer ID"
let passwordMsgg = "Please enter Password"
let validateCustomerID = "Please enter Customer ID"
let validatePassword = "Please enter Password"
let validateUserName = "Please enter Username"
let validateConfirmPassword = "Please enter Confirm Password"
let validateBusinessName  = "Please enter Business Name"
let validateFirstName  = "Please enter Username"
let validateFirstName1 = "Please enter First Name"
let validateLastName = "Please enter Last Name"
let validatePhoneNumber = "Please enter Phone Number"
let validateMobile = "Please enter Mobile Number"
let validateEmptyEmail = "Please enter Email"
let validateEmail = "Please enter valid Email"
let validatePasswordLength = "Passsword should be minimum 6 characters"
let vaidatePasswordConfirmPassword = "Password and Confirm Password do not match"
let selectedRegionMsg = "Please select a region"
let validateDeliveryNumber  = "Please enter Delivery Number/Street"
let validateDeliverySubUrb  = "Please enter Delivery Suburb/City"
let validateDeliveryCountry  = "Please enter Delivery Country"
let validateDeliveryState  = "Please enter Delivery State/Region"
let valdateDeliveryPostCode  = "Please enter Delivery Postcode/Zip"
//let validateDeliveryInstructions = "Please enter Delivery Note"
let validatePostalNumber  = "Please enter Postal Number/Street"
let validatePostalSubUrb  = "Please enter Postal Suburb/City"
let validatePostalCountry  = "Please enter Postal Country"
let validatePostalState  = "Please enter Postal State/Region"
let validatePostalCode  = "Please enter Postal Postcode/Zip"
let validateDeliveryNote  = "Please enter Delivery Note"
let validateDeliveryInstructions  = "Please enter Delivery Instructions"

let validateCardNumber = "Please enter card number."
let vaidateCardHolderName = "Please enter card holder name."
let validateExpiryMonth = "Please select expire Month."
let validateExpiryYear = "Please select expire Year."
let validateCVV = "Please enter CVV."

let validateInternetConnection = "Internet Connection is offline"
let validateInternetTitle = "Network Error"
let validateQuantities = "Please add quantities to your order to proceed."
let validateDeliveryDate = "Please select delivery date."
let serverNotResponding = "Server not responding"

let firstNameMsgEn = "Please Enter First Name"
let lastNameMsgEn = "Please Enter Last Name"
let emailMsgEn = "Please Enter Email"

let validEmailEn = "Please Enter Vaild Email"
let passMsgEn = "Please Enter Password"
let cnfPassMsgEn = "Please Enter Confirm Password"
let validPassMsgEn = "Password should be of 8 characters"
let countryMsgEn =  "Please Select Country"
let phoneMsgEn = "Please Enter Phone Number"
let passwordMatchEn = "Password doesn't match"
let nameMsgEn = "Please Enter Name"
let countryCodeMsgEn = "Please Select Your Country Code"
let quantityMsgEn = "Please Enter Quantity"
let commentMsgEn = "Please Enter Comment"
let newPassMsgEn = "Please Enter New Password"
let enterSubjectEn = "Please Enter Subject"
let writeMessageEn = "Please Write Message"
let dialCodeMessageEn = "Please Select DialCode"
let logoutConfirmationMesssage = "Are you sure want to logout?"
let emptyCart = "No Product Available in Cart"
let updateMessageTitle = "New version available"
let updateMessage = "You are using an old version of this app. Please download the latest version from the App Store."
let newPassLength = "New password length should be minimum 6 digits."
let passwordAndConfirmMatchEn = "New password & confirm password are not same."
let nextDeliveryDateConfirmationMessage = "Your order will be delivered on next delivery date, Do you want to place order?"

//MARK: - Constants
struct Constants {
    
    struct activitySize {
        static let size = CGSize(width: 40, height: 40)
    }
    
    static func isValidEmail(_ email: String?) -> Bool {
        guard let mail = email else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: mail)
    }
    
    //MARK: - Show Indicator Method
//   static func showIndicator() {
//       CustomActivityIndicator.showIndicator()
////        guard let window = UIApplication.shared.keyWindow else { return }
////        let Indicator = MBProgressHUD.showAdded(to: window, animated: true)
////        Indicator.bezelView.color = UIColor.black // Your backgroundcolor
////        Indicator.bezelView.style = .solidColor
////        Indicator.contentColor = UIColor.white
////        //Indicator.label.text = title
////        Indicator.isUserInteractionEnabled = false
////        //Indicator.detailsLabel.text = Description
////        Indicator.show(animated: true)
//    }
//    
//    //MARK: - Hide Indicator Method
//    static func hideIndicator() {
//        CustomActivityIndicator.hideIndicator()
////        guard let window = UIApplication.shared.keyWindow else { return }
////        MBProgressHUD.hide(for: window, animated: true)
//    }
    
    //MARK: -> htmlToAttributedString
    static func htmlToAttributedString(description: String, size: CGFloat) -> NSAttributedString? {
        let htmlString = description
        let modifiedFont = String(format:"<span style=\"font-family:'Regular'; font-size: \(size)\">%@</span>", htmlString)
        let descriptiion = try? NSAttributedString( // do catch
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        return descriptiion
    }
    
    static func getDeviceId() -> String {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        return deviceId ?? "39d568bf23a11f0e"
    }
    
    static let bannerHeight = 130.0
    static let deviceId = getDeviceId() //"39d568bf23a11f0e"
    static let deviceName = UIDevice.current.name//"iphone XR"
    static let deviceIP =  getIPAddress() ?? "192.168.3.101"
}

extension Constants {
    
    static  func rotateImageInPlace(image: UIImage, byDegrees degrees: CGFloat) -> UIImage? {
        let radians = degrees * .pi / 180
        let imageSize = image.size
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // Move the origin to the middle of the image
        context.translateBy(x: imageSize.width / 2, y: imageSize.height / 2)
        // Rotate the context
        context.rotate(by: radians)
        // Draw the image in the rotated context
        image.draw(in: CGRect(x: -imageSize.width / 2, y: -imageSize.height / 2,
                              width: imageSize.width, height: imageSize.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }


    static func getIPAddress() -> String? {
        var address : String?
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name:
                // wifi = ["en0"]
                // wired = ["en2", "en3", "en4"]
                // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    
    static func checkItems(localData: [GetItemsData], data: GetItemsData) {
        var localData = LocalStorage.getItemsData() //localData
        let itemCode = data.item_code
        let measureQty = data.measureQty
        let originQty  = data.originQty
        var quantity = ""
        
        let floatQuantity = (measureQty!  as NSString).floatValue.clean
        let strQuantity = String(floatQuantity)
        
        let floatOriginQty = (originQty! as NSString).floatValue.clean
        let strOriginQty = String(floatOriginQty)
        var mutableData = data 
        
        if data.is_meas_box == 0 {
            if let quan = Double(strOriginQty) {
                quantity = "\(quan)"
                mutableData.quantity = quantity // Modify the mutable copy
            } else {
                print("Invalid values for quantity or measureQty")
            }
        } else {
            if let quan = Double(strOriginQty), let measureQty = Double(strQuantity) {
                let totalQuantity = quan * measureQty
                quantity = "\(totalQuantity)"
                mutableData.quantity = quantity // Modify the mutable copy
            } else {
                print("Invalid values for quantity or measureQty")
            }
        }
        
      
        print(quantity, measureQty)
        
        if let index = localData.firstIndex(where: {$0.item_code == itemCode}) {
            if quantity != "" && quantity != "0.0" && quantity != "0.00" && quantity != "0.0"  {
                localData[index].quantity = quantity
                localData[index].measureQty = measureQty
                localData[index].originQty = originQty
               
            } else {
                localData[index].quantity = "0"
                localData[index].originQty = "0"
                localData[index].measureQty = "0"
                localData.remove(at: index)
            }
            LocalStorage.saveItemsData(data: localData)
        } else {
            // if item code not present
            if (quantity != "" && quantity != "0.00" && quantity != "0" && quantity != "0.0") || (measureQty != "" && measureQty != "0.00" && measureQty != "0" && measureQty != "0.0")  {
                print("Append in local Storage array")
                localData.append(mutableData) // Append the mutable copy
            }
            
//            let isValidQuantity: (String?) -> Bool = { value in
//                return ((value?.isEmpty) == nil) && value != "0" && value != "0.0" && value != "0.00"
//            }
//
//            let filteredData = localData.filter { item in
//                isValidQuantity(item.quantity) || isValidQuantity(item.measureQty) && !(item.measureQty == "0" || item.measureQty == "0.0") && !(item.quantity == "0" || item.quantity == "0.0")
//            }
            LocalStorage.saveItemsData(data: localData)
        
            
        }
    }
    
    static func checkMultiItems(localData: [GetItemsData], data: GetItemsData) {
        var localData = LocalStorage.getShowItData() //localData
        let itemCode = data.item_code
        let measureQty = data.measureQty
        let originQty  = data.originQty
        var quantity = ""
        
        let floatQuantity = (measureQty!  as NSString).floatValue.clean
        let strQuantity = String(floatQuantity)
        
        let floatOriginQty = (originQty! as NSString).floatValue.clean
        let strOriginQty = String(floatOriginQty)
        var mutableData = data // Create a mutable copy of `data`
        
        if let quan = Double(strOriginQty), let measureQty = Double(strQuantity) {
            let totalQuantity = quan * measureQty
            quantity = "\(totalQuantity)"
            mutableData.quantity = quantity // Modify the mutable copy
        } else {
            print("Invalid values for quantity or measureQty")
        }
    
     
        
        
        
            
        }
    

    
    static func getPrice(itemCode: String?) -> String? {
        var price: String?
        let localData = LocalStorage.getItemsData()
        print(itemCode)
        if let ind = localData.firstIndex(where: {$0.item_code == itemCode}) {
            price = localData[ind].originQty
            return price
        } else {
            return nil
        }
    }
    
    
    
    static func getCount(itemCode: String?) -> Int  {
        var price: String?
        var localData = LocalStorage.getFilteredData()
        localData += LocalStorage.getFilteredMultiData()
        var ind = Constants.getFilterItem(itemCode: itemCode, array: localData)
        return ind.count
        
    }
    
   static func getFilterItem(itemCode: String?,array:[GetItemsData]) -> [GetItemsData] {
        var test = [GetItemsData]()
        for i in array {
            if i.item_code == itemCode {
                test.append(i)
            }
        }
       return test
    }
    
    static func getMeasure(itemCode: String?) -> String? {
        var price: String?
        let localData = LocalStorage.getItemsData()
        if let ind = localData.firstIndex(where: {$0.item_code == itemCode}) {
            price = localData[ind].measureQty
            return price
        } else {
            return nil
        }
    }
    
    
    static func getQuantity(itemCode: String?) -> String? {
        var price: String?
        let localData = LocalStorage.getItemsData()
        if let ind = localData.firstIndex(where: {$0.item_code == itemCode}) {
            price = localData[ind].quantity
            return price
        } else {
            return nil
        }
    }
    
    static func getCartItem(itemCode: String?) -> GetItemsData? {
        var item: GetItemsData?
        let localData = LocalStorage.getItemsData()
        if let ind = localData.firstIndex(where: {$0.item_code == itemCode}) {
            item = localData[ind]
            return item
        } else {
            return nil
        }
    }
    
    
    
    static func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.AppName)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.UserDefaultLoginID)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.CustomerType)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.UserLoginID)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.CurrencySymbol)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.orderFlag)
        UserDefaults.standard.set(true, forKey:UserDefaultsKeys.isShowFeaturedImageOnDashboard)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.CurrentDate)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.Date)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.selectedRadioButtonType)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.SelectedDate)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.ponumber)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.comment)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.showAppBanner)
        UserDefaults.standard.removeObject(forKey:UserDefaultsKeys.showItemInGrid)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.showPrice)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.getItemsData)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.outletsListData)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.acmLoginID)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.clientRegionCode)
    }
}

//MARK: - Get-Cart-Updated-Items
extension Constants {
    static func getCartUpdatedItems() {
        LocalStorage.clearItemsData()
        let userCode = UserDefaults.standard.value(forKey:UserDefaultsKeys.UserLoginID) as? String
        let param = [SaveCartParam.user_code.rawValue: userCode,
                     SaveCartParam.client_code.rawValue: KeyConstants.clientCode,
                     SaveCartParam.device_id.rawValue: Constants.deviceId] as [String : Any?]
        print("Request Param:: ",JSON(param))
        carartItemsList(with: param as [String : Any])
    }
    
    static func carartItemsList(with param: [String: Any]) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.cartItemsV3) else { fatalError("URL is incorrect.") }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<HomeModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        //
        WebService().load(resource: resource) { [self] result in
            switch result{
            case .success(let cartData):
                if let cartData = cartData {
                    guard let status = cartData.status else { return }
                    if (status == 1) {
                        LocalStorage.clearItemsData()
                        if let cartData =  cartData.data {
                            if let allInventories = cartData.allInventories {
                                if allInventories.count > 0 {
                                    LocalStorage.saveItemsData(data: allInventories)
                                    let notificationCenter = NotificationCenter.default
                                    notificationCenter.post(name: Notification.Name("cartSucess"), object: nil, userInfo: nil)
                                }
                            }
                        }
                        
                        if let showPrice  = cartData.showPrice {
                            UserDefaults.standard.set(showPrice, forKey: UserDefaultsKeys.showPrice)
                        }
                        
                        if let currencySymbol = cartData.currency_symbol {
                            if(currencySymbol != ""){
                                UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                            } else {
                                UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                            }
                        }
                    } else {
                    }
                }
            case .failure(let error):
                print("error")
            }
        }
    }
}

//MARK: - Used-to-manage-cart-items-count-label-position-throughout-application
//(change here top and trailing, it will automatically reflect in whole application)
extension Constants {
    static let totalCartItemsCountTopConst = 11.5
    static func cartItemsCountLabelTrailingConst() -> Float {
        let cartItems = LocalStorage.getFilteredData()
        let cartItemsString = String(cartItems.count)
        let digitCount = cartItemsString.count
        if digitCount > 1  && cartItems.count != 11{
            return 8.5
        } else if cartItems.count == 1 {
            return 13
        } else if cartItems.count == 11 {
            return 10
        } else {
            return 11
        }
    }
}

import UIKit

class CustomActivityIndicator {
    
    static var backgroundView: UIView?
    
    static func showIndicator() {
        self.hideIndicator()
        guard let window = UIApplication.shared.keyWindow else { return }
        
        // Create a background view
        let bgView = UIView(frame: window.bounds)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.1) // Black transparent background
        bgView.tag = 999 // To identify and remove later
        
        // Create a container for the indicator
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black
        containerView.layer.cornerRadius = 5
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the activity indicator
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the indicator to the container view
        containerView.addSubview(indicator)
        
        // Add container to the background view
        bgView.addSubview(containerView)
        
        // Add to the window
        window.addSubview(bgView)
        
        // Center the indicator inside the container
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            containerView.widthAnchor.constraint(equalToConstant: 72),
            containerView.heightAnchor.constraint(equalToConstant: 72),
            containerView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor)
        ])
        
        backgroundView = bgView
    }

    static func hideIndicator() {
        backgroundView?.removeFromSuperview()
        backgroundView = nil
    }
}

