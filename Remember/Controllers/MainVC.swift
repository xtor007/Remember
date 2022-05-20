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
        addButton.layer.cornerRadius = addButton.frame.width/2
        catalogsTable.dataSource = self
        catalogsTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataService.storage.getAllCatalogs { catalogs in
            self.catalogs = catalogs
            self.catalogsTable.reloadData()
        } onError: { message in
            //error
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        let startFrame = addButton.frame
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear) {
            let height = self.view.frame.height*2
            let screenWidth = self.view.frame.width
            self.addButton.frame = CGRect(x: screenWidth-50-height/2, y: -85, width: height, height: height)
            self.addButton.layer.cornerRadius = height/2
            self.addButtonHeighConstraint.constant = height
            self.addButtonWidthConstraint.constant = height
            self.addButtonTrailingConstraint.constant = 50 - height/2
            self.addButtonBottomConstraint.constant = height/2 - 50
        } completion: { isFinish in
            if let createCatalogVC = self.storyboard?.instantiateViewController(withIdentifier: "createCatalog") as? CreateCatalogVC {
                createCatalogVC.modalPresentationStyle = .fullScreen
                self.present(createCatalogVC, animated: false) {
                    self.addButton.frame = startFrame
                    self.addButton.layer.cornerRadius = startFrame.width/2
                    self.addButtonHeighConstraint.constant = 80
                    self.addButtonWidthConstraint.constant = 80
                    self.addButtonTrailingConstraint.constant = 20
                    self.addButtonBottomConstraint.constant = -20
                }
            } else {
                //ERROR
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
    
}
