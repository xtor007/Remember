//
//  CreateCatalogVC.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 20.05.2022.
//

import UIKit

class CreateCatalogVC: UIViewController {


    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet var selectTypeButtons: [UIButton]!
    
    var selectType = TaskType.text
    let types = [TaskType.text, .photo, .photoText]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectTypeAction(_ sender: Any) {
        if let tappedButton = sender as? UIButton {
            selectType = types[tappedButton.tag]
            for selectTypeButton in selectTypeButtons {
                selectTypeButton.backgroundColor = .systemGray2
            }
            tappedButton.backgroundColor = .systemOrange
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if let name = nameText.text {
            if name != "" {
                DataService.storage.addNewCatalog(name: name, type: selectType) {
                    print("next")
                } onError: { message in
                    //error
                }
            } else {
                //error
            }
        } else {
            //error
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func swipe(_ sender: Any) {
        if let swipe = sender as? UISwipeGestureRecognizer {
            if swipe.direction == .right {
                backAction(0)
            }
        }
    }
    
    @IBAction func tap(_ sender: Any) {
        nameText.endEditing(true)
    }

}
