//
//  FinalVC.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 25.05.2022.
//

import UIKit

class FinalVC: UIViewController {
    
    var closeDelegate: CloseDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    @IBAction func homeAction(_ sender: Any) {
        dismiss(animated: false) {
            self.closeDelegate.closeVC()
        }
    }
    

}
