//
//  MainVC.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 03.05.2022.
//

import UIKit


class MainVC: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var catalogsTable: UITableView!
    let cellId = "catalogCell"
    
    @IBOutlet weak var addButtonHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonTrailingConstraint: NSLayoutConstraint!
    
    
    var catalogs: [Catalog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        addButton.layer.cornerRadius = addButton.frame.width/2
        catalogsTable.dataSource = self
        catalogsTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataService.storage.getAllCatalogs { catalogs in
            self.catalogs = catalogs
            self.catalogsTable.reloadData()
        } onError: { message in
            self.showError(message: "Somethig is not good, reload app")
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        addButton.tintColor = .systemYellow
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseIn) {
            let magnificationFactor: CGFloat = 20
            self.addButton.transform = CGAffineTransform(scaleX: magnificationFactor, y: magnificationFactor)
        } completion: { isFinish in
            if isFinish {
                if let createCatalogVC = self.storyboard?.instantiateViewController(withIdentifier: "createCatalog") as? CreateCatalogVC {
                    createCatalogVC.modalPresentationStyle = .fullScreen
                    self.present(createCatalogVC, animated: false) {
                        self.addButton.transform = CGAffineTransform.identity
                        self.addButton.tintColor = .white
                    }
                } else {
                    self.showError(message: "Somethig is not good, reload app")
                }
            } else {
                self.showError(message: "Somethig is not good, reload app")
            }
        }
    }

}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CatalogCell {
            cell.uploadData(data: catalogs[indexPath.row])
           return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let catalogVC = storyboard?.instantiateViewController(withIdentifier: "catalogVC") as? CatalogVC {
            catalogVC.modalPresentationStyle = .fullScreen
            presentDetail(catalogVC) {
                catalogVC.uploadData(self.catalogs[indexPath.row])
            }
        }
    }
    
}
