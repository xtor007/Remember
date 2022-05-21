//
//  PresentDetails.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 20.05.2022.
//

import UIKit

extension UIViewController {
    
    func presentDetail(_ toPresent: UIViewController, withDuration duration: CFTimeInterval = 0.4, completion: (() -> (Void))? = nil) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = .push
        transition.subtype = .fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        present(toPresent, animated: false, completion: completion)
    }
    
    func dismissDetail(withDuration duration: CFTimeInterval = 0.4, completion: (() -> (Void))? = nil) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = .push
        transition.subtype = .fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: completion)
    }
    
}
