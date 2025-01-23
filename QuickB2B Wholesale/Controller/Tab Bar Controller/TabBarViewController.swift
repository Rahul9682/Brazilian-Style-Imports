//  TabBarViewController.swift
//  QB2B Wholesale
//  Created by braintech on 17/12/21.

import UIKit

class TabBarViewController: UITabBarController {
    
    //MARK: -> Properties
    var selectedTabIndex: Int = 0
    var isShowFollowUs = false
    var alert:UIAlertController!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addThemeBorder()
        addLabelToTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: -> Helpers
    func configureUI() {
        self.tabBarController?.delegate = self
        selectedIndex = selectedTabIndex
        self.delegate = self
//        UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
//        UITabBar.appearance().selectedItem?.badgeColor = UIColor.black
//        tabBar.tintColor = UIColor.systemTeal
//        tabBar.backgroundColor = UIColor.white
    }
}

//MARK: - TABBAR DELEGATE EXTENSION
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is HomeViewController {
            selectedTabIndex = selectedIndex
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
        } else if viewController is MyListViewController {
            selectedTabIndex = selectedIndex
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
        } else if viewController is ProductsViewController {
            selectedTabIndex = selectedIndex
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
        } else if viewController is MyOrdersViewController {
            selectedTabIndex = selectedIndex
        } else if viewController is ConfirmPaymentViewController {
            selectedTabIndex = selectedIndex
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("tabChange"), object: nil, userInfo: nil)
        } else if viewController is AccountDetailsVC {
            selectedTabIndex = selectedIndex
        }
        //addLabelAtTabBarItemIndex(tabIndex: selectedTabIndex)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            return true
    }
}

//MARK: -> Tabbar Configuration
extension TabBarViewController {
    func addThemeBorder() {
        let themeBorder = UIView()
        themeBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 0.5)
        themeBorder.backgroundColor = UIColor.black//UIColor.lightGray.withAlphaComponent(0.4)
        tabBar.addSubview(themeBorder)
        self.tabBarController?.tabBar.layer.zPosition = 0
    }
    
    func addLabelToTabBar() {
        let label = UILabel()
        label.text = "Developed by QuickB2B" // Customize the label's text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 8.0)
        label.textColor = .black
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        label.addGestureRecognizer(tapGesture)
        
        if deviceHasSafeArea() {
            print("Device supports safe areas.")
        } else {
            print("Device does not have safe areas.")
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.frame = CGRect(x: tabBar.frame.width - 130, y: tabBar.frame.height - 15, width: 156, height: 20)
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            label.frame = CGRect(x: tabBar.frame.width - 150, y: tabBar.frame.height, width: 156, height: 20)
        }
        tabBar.addSubview(label)
    }
    
    func deviceHasSafeArea() -> Bool {
        if #available(iOS 11.0, *) {
            // Check if the window's safeAreaInsets are greater than zero.
            if let window = UIApplication.shared.windows.first {
                return window.safeAreaInsets != UIEdgeInsets.zero
            }
        }
        return false
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        // Your code to handle the tap gesture on the label
        openURL("http://quickb2b.com/")
    }
    
    // Function to open a URL
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("URL cannot be opened.")
                // Handle the case when the URL cannot be opened, e.g., display an error message.
            }
        } else {
            print("Invalid URL.")
            // Handle the case when the URL string is not a valid URL.
        }
    }
}

