//
//  CatalogCell.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 03.05.2022.
//

import UIKit

class CatalogCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func uploadData(data: Catalog) {
        nameLabel.text = data.name
        typeLabel.text = data.type
        backView.layer.cornerRadius = 20
    }

}
