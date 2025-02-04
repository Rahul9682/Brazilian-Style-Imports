   //  AppDelegate.swift
//  QuickB2B Wholesale
//  Created by Brain Tech on 4/13/21.

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase
import SwiftyJSON
//import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate{
    
    var window: UIWindow?
    static let shared = AppDelegate()
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(true, forKey:UserDefaultsKeys.isShowFeaturedImageOnDashboard)
        UserDefaults.standard.set(true, forKey:UserDefaultsKeys.isShowUpdateAppPopUp)
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    //  Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        callSaveCart()
        Thread.sleep(forTimeInterval: 1.5)//MARK: - Using for add delay on launch screen
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        print("device Name:- ", UIDevice.current.name)
        print("device IP:- ", Constants.getIPAddress() ?? "")
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
        }
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        // get application instance ID
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let token = token {
                print("Remote instance ID token:\(token)")
            }
            //Check for error. Otherwise do what you will with token here
        }
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound,.alert,.badge,  .providesAppNotificationSettings]) { (granted, error) in
            print(error?.localizedDescription ?? "")
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    //MARK: - PUSH NOTIFICATION DELEGATES
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let info = response.notification.request.content.userInfo as? [String: Any]
       
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let appOldVersion = UserDefaults.standard.object(forKey: "AppVersion") as? String ?? ""
        let userID = UserDefaults.standard.object(forKey:UserDefaultsKeys.UserLoginID) as? String ?? ""
        print("FCM TOKEN:: ",fcmToken)
        UserDefaults.standard.set(fcmToken, forKey: "PushToken")
        UserDefaults.standard.set(deviceID, forKey: "DeviceIdentifier")
        if(userID != ""){
            let floatAppVersion = Float(appVersion ) ?? 0.0
            let floatAppOldVersion = Float(appOldVersion) ?? 0.0
            if(floatAppVersion > floatAppOldVersion) {
                var dictParam = [String:Any]()
                var appType = ""
                let customerType = UserDefaults.standard.object(forKey:UserDefaultsKeys.CustomerType) as? String ?? ""
                if (customerType == "Wholesale Customer") {
                    appType = KeyConstants.app_TypeDual
                } else {
                    appType = KeyConstants.app_TypeRetailer
                }
                
                var  orderFlag = UserDefaults.standard.object(forKey:UserDefaultsKeys.orderFlag) as? String ?? "0"
                if(orderFlag == ""){
                    orderFlag = "0"
                }
                let clientCode = UserDefaults.standard.object(forKey: "ClientCode") as? String ?? ""
                
                dictParam = [
                    GetPushNotification.type.rawValue:KeyConstants.appType ,
                    GetPushNotification.app_type.rawValue:KeyConstants.app_Type,
                    GetPushNotification.client_code.rawValue:KeyConstants.clientCode ,
                    GetPushNotification.user_code.rawValue:userID ,
                    GetPushNotification.device_id.rawValue:deviceID,
                    GetPushNotification.device_type.rawValue:"FI",
                    GetPushNotification.device_token.rawValue:fcmToken ?? "",
                ]
                UserDefaults.standard.set(appVersion, forKey: "AppVersion")
                self.getPushNotification(with: dictParam)
            }
        }
    }
    
    //MARK: - API INTEGRATION
    private func getPushNotification(with param: [String: Any]) {
        print(JSON(param))
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getPushNotification) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<GetPushNotificationModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        //
        WebService().load(resource: resource) { [self] result in
            
            switch result{
            case .success(let getPushNotificationData):
                if let getPushNotificationData = getPushNotificationData {
                    
                    guard let result = getPushNotificationData.result else { return }
                    
                    if (result == 1) {
                        
                    } else {
                        
                    }
                }
            case .failure(let error):
                
                print("error")
                
            }
        }
    }
    
    //MARK: - Save Cart Items
    func callSaveCart() {
        LocalStorage.clearItemsData()
        let userCode = UserDefaults.standard.value(forKey:UserDefaultsKeys.UserLoginID) as? String
        let param = [SaveCartParam.user_code.rawValue: userCode,
                     SaveCartParam.client_code.rawValue: KeyConstants.clientCode,
                     SaveCartParam.device_id.rawValue: Constants.deviceId] as [String : Any?]
        print(JSON(param))
        self.carartItemsList(with: param as [String : Any])
    }
    
    private func carartItemsList(with param: [String: Any]) {
        print(JSON(param))
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.cartItemsV3) else { fatalError("URL is incorrect.") }
        print(url)
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
                        LocalStorage.clearMultiItemsData()
                        if let cartData =  cartData.data {
                            if let allInventories = cartData.allInventories {
                                if allInventories.count > 0 {
                                    LocalStorage.saveItemsData(data: allInventories)
                                }
                            }
                            if let multi_items = cartData.multi_items {
                                if multi_items.count > 0 {
                                    LocalStorage.saveMultiData(data: multi_items)
                                    
                                }
                            }
                            let notificationCenter = NotificationCenter.default
                            notificationCenter.post(name: Notification.Name("cartSucess"), object: nil, userInfo: nil)
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
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 13.0, *)
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentCloudKitContainer(name: "QuickB2B_Wholesale")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    @available(iOS 13.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}
