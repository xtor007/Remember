//
//  ShowAlert.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 24.05.2022.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alertVC = UIAlertController(
                    title: title,
                    message: message,
                    preferredStyle: .alert)
        for action in actions {
            alertVC.addAction(action)
        }
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showError(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        showAlert(title: "ERROR", message: message, actions: [
            UIAlertAction(title: "OK", style: .default, handler: handler)
        ])
    }
    
}
