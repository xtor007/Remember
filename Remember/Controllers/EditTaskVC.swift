//
//  EditTaskVC.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 21.05.2022.
//

import UIKit

class EditTaskVC: UIViewController {
    
    var type: TaskType!
    var catalog: String!

    @IBOutlet weak var catalogNameLabel: UILabel!
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var loadPhotoButton: UIButton!
    @IBOutlet weak var taskText: UITextView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var answerText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if answerText.text == nil || answerText.text == "" {
            //error
            return
        }
        switch type {
        case .photo:
            if taskImage.image == nil {
                //error
                return
            }
        case .text:
            if taskText.text == nil || taskText.text == "" {
                //error
                return
            }
        case .photoText:
            if taskText.text == nil || taskText.text == "" || taskImage.image == nil {
                //error
                return
            }
        case .none:
            //error
            return
        }
        var text: String?
        if taskText.text == "" {
            text = nil
        } else {
            text = taskText.text
        }
        if let catalog = catalog {
            DataService.storage.addTask(forCatalog: catalog, withTextTask: text, withPhoto: taskImage.image, withAnswer: answerText.text!) {
                self.backAction(0)
            } onError: { message in
                //error
            }

        }
    }
    
    @IBAction func loadPhotoAction(_ sender: Any) {
        chooseImage()
    }
    
    func uploadData(name: String, type: TaskType, task: Task? = nil) {
        self.type = type
        self.catalog = name
        catalogNameLabel.text = name
        switch type {
        case .photo:
            taskText.isHidden = true
            taskLabel.isHidden = true
        case .text:
            taskImage.isHidden = true
            loadPhotoButton.isHidden = true
        case .photoText: break
        }
        if let task = task {
            if let photoData = task.photoTask {
                if let photo = UIImage(data: photoData) {
                    taskImage.image = photo
                }
            }
            if let textTask = task.textTask {
                taskText.text = textTask
            }
            if let answer = task.answer {
                answerText.text = answer
            }
        }
    }

}

extension EditTaskVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            taskImage.image = image
            dismiss(animated: true)
        } else {
            //error
        }
    }
    
}
