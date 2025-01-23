

//  Created by mac5 on 01/08/17.
//  Copyright © 2017 Braintechnosys pvt ltd. All rights reserved.
//

import UIKit

class HomeRootVC: HamburguerVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        self.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "HamburguerNavigationController")
       // self.menuViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC")
        self.menuViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController")
    }
}
