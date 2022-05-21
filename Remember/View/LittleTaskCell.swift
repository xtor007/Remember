//
//  LittleTaskCell.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 21.05.2022.
//

import UIKit

class LittleTaskCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var taskImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func uploadData(data: Task) {
        if let text = data.textTask {
            taskLabel.text = text
        } else {
            taskLabel.text = ""
        }
        if let answer = data.answer {
            answerLabel.text = answer
        }
        taskImage.isHidden = true
        if let imageData = data.photoTask {
            if let image = UIImage(data: imageData) {
                taskImage.isHidden = false
                taskImage.image = image
            }
        }
    }
    
}
