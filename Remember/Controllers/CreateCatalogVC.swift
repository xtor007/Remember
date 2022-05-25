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
        overrideUserInterfaceStyle = .light
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
                DataService.storage.isCatalogNameOk(name) { isOk in
                    if !isOk {
                        self.showError(message: "Catalog name cannot be same")
                    } else {
                        DataService.storage.addNewCatalog(name: name, type: self.selectType) {
                            if let editCatalogVC = self.storyboard?.instantiateViewController(withIdentifier: "editCatalogVC") as? EditCatalogVC {
                                editCatalogVC.modalPresentationStyle = .fullScreen
                                editCatalogVC.closeDelegate = self
                                self.presentDetail(editCatalogVC) {
                                    editCatalogVC.uploadData(name: name, type: self.selectType)
                                }
                            } else {
                                self.showError(message: "Somethig is not good, reload app")
                            }
                        } onError: { message in
                            self.showError(message: "Somethig is not good, reload app")
                        }
                    }
                } onError: { message in
                    self.showError(message: "Somethig is not good, reload app")
                }
            } else {
                showError(message: "You don't enter name")
            }
        } else {
            showError(message: "You don't write name")
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

extension CreateCatalogVC: CloseDelegate {
    
    func closeVC() {
        dismiss(animated: false)
    }
    
}
