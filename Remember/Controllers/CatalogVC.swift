//
//  CatalogVC.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 21.05.2022.
//

import UIKit

class CatalogVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var goButton: UIButton!
    
    var catalog: Catalog!
    let typeByString = [
        "text": TaskType.text,
        "photo with text": .photoText,
        "photo": .photo
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goButton.layer.cornerRadius = goButton.frame.width/2
    }
    
    func uploadData(_ data: Catalog) {
        nameLabel.text = data.name
        catalog = data
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func editAction(_ sender: Any) {
        if let editCatalogVC = storyboard?.instantiateViewController(withIdentifier: "editCatalogVC") as? EditCatalogVC {
            editCatalogVC.modalPresentationStyle = .fullScreen
            presentDetail(editCatalogVC) {
                editCatalogVC.uploadData(name: self.catalog.name!, type: self.typeByString[self.catalog.type!]!)
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        DataService.storage.deleteCatalog(catalog) {
            self.backAction(0)
        } onError: { message in
            //error
        }
    }
    
    @IBAction func goAction(_ sender: Any) {
    }

}
