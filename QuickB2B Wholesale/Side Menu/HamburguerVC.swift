
//  Created by mac5 on 01/08/17.
//  Copyright © 2017 Braintechnosys pvt ltd. All rights reserved.
//

import UIKit

/** Direction of menu appearance */
enum DLHamburguerMenuPlacement: Int {
    case left = 0, right, top, bottom
}

/** Visual style of the menu */
enum DLHamburguerMenuBackgroundStyle: Int {
    case light = 0, dark = 1
    
    func toBarStyle() -> UIBarStyle {
        return UIBarStyle(rawValue: self.rawValue)!
    }
}

// Constants
private let kDLHamburguerMenuSpan: CGFloat = 50.0

/**
 * The DLHamburguerViewController is the main VC managing the content view controller and the menu view controller.
 * These view controllers will be contained in the main container view controller.
 * The menuViewController will be shown when panning or invoking the showMenuViewController method.
 * The contentViewController will contain the application main content VC, probably a UINavigationController.
 */
class HamburguerVC: UIViewController {
    // pan gesture recognizer.
    var gestureRecognizer: UIPanGestureRecognizer?
    var gestureEnabled = false
    
    // appearance
    var overlayAlpha: CGFloat = 0.3                                // % of dark fading of the background (0.0 - 1.0)
    var animationDuration: TimeInterval = 0.35                   // duration of the menu animation.
    var desiredMenuViewSize: CGSize?                                // if set, menu view size will try to adhere to these limits
    var actualMenuViewSize: CGSize = CGSize.zero                     // Actual size of the menu view
    var menuVisible = false                                         // Is the hamburguer menu currently visible?
    
    // delegate
    var delegate: DLHamburguerViewControllerDelegate?
    
    // settings
    var menuDirection: DLHamburguerMenuPlacement = .left
    var menuBackgroundStyle: DLHamburguerMenuBackgroundStyle = .light
    
    // structure & hierarchy
    var containerViewController: HamburguerContainerVC!
    fileprivate var _contentViewController: UIViewController!
    var contentViewController: UIViewController! {
        get {
            return _contentViewController
        }
        set {
            if _contentViewController == nil {
                _contentViewController = newValue
                return
            }
            // remove old links to previous hierarchy
            _contentViewController.removeFromParent()
            _contentViewController.view.removeFromSuperview()
            
            // update hierarchy
            if newValue != nil {
                self.addChild(newValue)
                newValue.view.frame = self.containerViewController.view.frame
                self.view.insertSubview(newValue.view, at: 0)
                newValue.didMove(toParent: self)
            }
            _contentViewController = newValue
            
            // update status bar appearance
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    fileprivate var _menuViewController: UIViewController!
    var menuViewController: UIViewController! {
        get {
            return _menuViewController
        }
        set {
            // remove old links to previous hierarchy
            if _menuViewController != nil {
                _menuViewController.view.removeFromSuperview()
                _menuViewController.removeFromParent()
            }
            _menuViewController = newValue
            
            // update hierarchy
            let frame = _menuViewController.view.frame
            _menuViewController.willMove(toParent: nil)
            _menuViewController.removeFromParent()
            _menuViewController.view.removeFromSuperview()
            _menuViewController = newValue
            if _menuViewController == nil { return }
            
            // add menu to container view hierarchy
            self.containerViewController.addChild(newValue)
            newValue.view.frame = frame
            self.containerViewController?.containerView?.addSubview(newValue.view)
            newValue.didMove(toParent: self)
        }
    }
    
    // MARK: - Lifecycle
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupHamburguerViewController()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHamburguerViewController()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupHamburguerViewController()
    }
    
    convenience init(contentViewController: UIViewController, menuViewController: UIViewController) {
        self.init()
        self.contentViewController = contentViewController
        self.menuViewController = menuViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hamburguerDisplayController(contentViewController, inFrame: self.view.bounds)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - VC management
    
    override var childForStatusBarStyle : UIViewController? {
        return self.contentViewController
    }
    
    override var childForStatusBarHidden : UIViewController? {
        return self.contentViewController
    }
    
    // MARK: - Setup DLHamburguerViewController
    
    internal func setupHamburguerViewController() {
        // initialize container view controller
        containerViewController = HamburguerContainerVC()
        containerViewController.hamburguerViewController = self
        
        // initialize gesture recognizer
//        gestureRecognizer = UIPanGestureRecognizer(target: containerViewController!, action: #selector(HamburguerVC.panGestureRecognized(_:)))
        gestureRecognizer = UIPanGestureRecognizer(target: containerViewController, action: #selector(HamburguerVC.panGestureRecognized(_:)))
        
    }
    
    // MARK: - Presenting and managing menu.
    /** Main function for presenting the menu */
    func showMenuViewController() { self.showMenuViewControllerAnimated(true, completion: nil)
        
    }
    
    /** Detailed function for presenting the menu, with options */
    func showMenuViewControllerAnimated(_ animated: Bool, completion: (() -> Void)? = nil) {
        // inform that the menu will show
        delegate?.hamburguerViewController?(self, willShowMenuViewController: self.menuViewController)
        
        self.containerViewController.shouldAnimatePresentation = animated
        // calculate menu size
        adjustMenuSize()
        
        // present menu controller
        self.hamburguerDisplayController(self.containerViewController, inFrame: self.contentViewController.view.frame)
        self.menuVisible = true
        
        // call completion handler.
        completion?()
    }
    
    func adjustMenuSize(_ forRotation: Bool = false) {
           
           var w: CGFloat = 0.0
           var h: CGFloat = 0.0
           
           if desiredMenuViewSize != nil { // Try to adjust to desired values
               w = desiredMenuViewSize!.width > 0 ? desiredMenuViewSize!.width : contentViewController.view.frame.size.width
               h = desiredMenuViewSize!.height > 0 ? desiredMenuViewSize!.height : contentViewController.view.frame.size.height
           } else { // Calculate menu size based on direction.
               var span: CGFloat = 0.0
               if self.menuDirection == .left || self.menuDirection == .right {
                   span = kDLHamburguerMenuSpan
               }
               if forRotation { w = self.contentViewController.view.frame.size.height - span; h = self.contentViewController.view.frame.size.width }
               else { w = self.contentViewController.view.frame.size.width - span; h = self.contentViewController.view.frame.size.height }

           }
           
           if UIDevice.current.userInterfaceIdiom == .pad {
               self.actualMenuViewSize = CGSize(width: w + 50 , height: h)
           }   else {
               self.actualMenuViewSize = CGSize(width: w + 50, height: h)
               
           }
       }
    /** Hides the menu controller */
    func hideMenuViewControllerWithCompletion(_ completion: (() -> Void)?) {
        if !self.menuVisible { completion?(); return }
        self.containerViewController.hideWithCompletion(completion!)
    }

    func resizeMenuViewControllerToSize(_ size: CGSize) {
        self.containerViewController.resizeToSize(size)
    }
    
    // MARK: - Gesture recognizer
    
    @objc func panGestureRecognized (_ recognizer: UIPanGestureRecognizer) {
        self.delegate?.hamburguerViewController?(self, didPerformPanGesture: recognizer)
        if self.gestureEnabled {
            if recognizer.state == .began && shouldStartShowingMenu(recognizer) { self.showMenuViewControllerAnimated(true, completion: nil) }
//            self.containerViewController.panGestureRecognized(recognizer)
            self.containerViewController.panGestureRecognized(recognizer)
        }
    }
    
    func shouldStartShowingMenu(_ recognizer: UIPanGestureRecognizer) -> Bool {
        
        self.contentViewController.view.backgroundColor = UIColor.clear
        
        let superView = self.contentViewController.view.superview
        
        superView?.backgroundColor = UIColor.clear
        
        switch self.menuDirection {
        case .bottom:
            return recognizer.velocity(in: self.containerViewController.view).y < 0
        case .left:
            return recognizer.velocity(in: self.containerViewController.view).x > 0
        case .top:
            return recognizer.velocity(in: self.containerViewController.view).y > 0
        case .right:
            return recognizer.velocity(in: self.containerViewController.view).x < 0
        }
    }
    
    // MARK: - Rotation legacy support (iOS 7)
    
    override var shouldAutorotate : Bool { return self.contentViewController.shouldAutorotate }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        // call super and inform delegate
        super.willAnimateRotation(to: toInterfaceOrientation, duration: duration)
        self.delegate?.hamburguerViewController?(self, willAnimateRotationToInterfaceOrientation: toInterfaceOrientation, duration: duration)
        // adjust size of menu if visible only.
        self.containerViewController.setContainerFrame(self.menuViewController.view.frame)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotate(from: fromInterfaceOrientation)
        if !self.menuVisible { self.actualMenuViewSize = CGSize.zero }
        adjustMenuSize(true)
    }
    
    // MARK: - Rotation (iOS 8)
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // call super and inform delegate
        if #available(iOS 8.0, *) {
            super.viewWillTransition(to: size, with: coordinator)
        } else {
            // Fallback on earlier versions
        }
        delegate?.hamburguerViewController?(self, willTransitionToSize: size, withTransitionCoordinator: coordinator)
        // adjust menu size if visible
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.containerViewController.setContainerFrame(self.menuViewController.view.frame)
        }, completion: {(finalContext) -> Void in
            if !self.menuVisible { self.actualMenuViewSize = CGSize.zero }
            self.adjustMenuSize(true)
        })
    }

}

/** Extension for presenting and hiding view controllers from the Hamburguer container. */
extension UIViewController {
    func hamburguerDisplayController(_ controller: UIViewController, inFrame frame: CGRect) {
        self.addChild(controller)
        controller.view.frame = frame
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func hamburguerHideController(_ controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
    func findHamburguerViewController() -> HamburguerVC? {
        var vc = self.parent
        while vc != nil {
            if let dlhvc = vc as? HamburguerVC { return dlhvc }
            else if vc != nil && vc?.parent != vc { vc = vc!.parent }
            else { vc = nil }
        }
        return nil
    }
}

@objc protocol DLHamburguerViewControllerDelegate {
    @objc optional func hamburguerViewController(_ hamburguerViewController: HamburguerVC, didPerformPanGesture gestureRecognizer: UIPanGestureRecognizer)
    @objc optional func hamburguerViewController(_ hamburguerViewController: HamburguerVC, willShowMenuViewController menuViewController: UIViewController)
    @objc optional func hamburguerViewController(_ hamburguerViewController: HamburguerVC, didShowMenuViewController menuViewController: UIViewController)
    @objc optional func hamburguerViewController(_ hamburguerViewController: HamburguerVC, willHideMenuViewController menuViewController: UIViewController)
    @objc optional func hamburguerViewController(_ hamburguerViewController: HamburguerVC, didHideMenuViewController menuViewController: UIViewController)
    @objc optional func hamburguerViewController(_ hamburguerViewController: HamburguerVC, willTransitionToSize size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    // Support for legacy iOS 7 rotation.
    @objc optional func hamburguerViewController(_ hamburguerViewController: HamburguerVC, willAnimateRotationToInterfaceOrientation toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval)
}
