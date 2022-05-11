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
        //
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let el1 = Catalog(context: context)
        el1.name = "Astronomy"
        el1.type = "photo"
        catalogs.append(el1)
        let el2 = Catalog(context: context)
        el2.name = "English"
        el2.type = "text"
        catalogs.append(el2)
        let el3 = Catalog(context: context)
        el3.name = "Astronomy"
        el3.type = "photo"
        catalogs.append(el3)
        let el4 = Catalog(context: context)
        el4.name = "English"
        el4.type = "text"
        catalogs.append(el4)
        let el5 = Catalog(context: context)
        el5.name = "Astronomy"
        el5.type = "photo"
        catalogs.append(el5)
        let el6 = Catalog(context: context)
        el6.name = "English"
        el6.type = "text"
        catalogs.append(el6)
        let el7 = Catalog(context: context)
        el7.name = "Astronomy"
        el7.type = "photo"
        catalogs.append(el7)
        let el8 = Catalog(context: context)
        el8.name = "English"
        el8.type = "text"
        catalogs.append(el8)
        let el9 = Catalog(context: context)
        el9.name = "Astronomy"
        el9.type = "photo"
        catalogs.append(el9)
        let el10 = Catalog(context: context)
        el10.name = "English"
        el10.type = "text"
        catalogs.append(el10)
        let el11 = Catalog(context: context)
        el11.name = "Astronomy"
        el11.type = "photo"
        catalogs.append(el11)
        let el12 = Catalog(context: context)
        el12.name = "English"
        el12.type = "text"
        catalogs.append(el12)
        //
        catalogsTable.dataSource = self
        catalogsTable.delegate = self
    }
    
    @IBAction func addAction(_ sender: Any) {
        print(view.frame)
        print(addButton.frame)
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
            print("finish")
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
