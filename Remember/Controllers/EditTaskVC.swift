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
    var task: Task?
    
    var deleteTaskDelegate: DeleteTaskDelegate!

    @IBOutlet weak var catalogNameLabel: UILabel!
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var loadPhotoButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var answerLabel: UILabel!
    
    var taskValue = ""
    var answerValue = ""
    var isTaskHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if isTaskHidden || segmentController.selectedSegmentIndex == 1 {
            answerValue = textView.text
        } else {
            taskValue = textView.text
        }
        if answerValue == "" {
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
            if taskValue == "" {
                //error
                return
            }
        case .photoText:
            if taskValue == "" || taskImage.image == nil {
                //error
                return
            }
        case .none:
            //error
            return
        }
        var text: String?
        if taskValue == "" {
            text = nil
        } else {
            text = taskValue
        }
        if let catalog = catalog {
            if let task = task {
                deleteTaskDelegate.deleteTask(task)
            }
            DataService.storage.addTask(forCatalog: catalog, withTextTask: text, withPhoto: taskImage.image, withAnswer: answerValue) {
                self.backAction(0)
            } onError: { message in
                //error
            }

        }
    }
    
    @IBAction func loadPhotoAction(_ sender: Any) {
        chooseImage()
    }
    
    @IBAction func tap(_ sender: Any) {
        textView.endEditing(true)
    }
    
    @IBAction func segmentControllerAction(_ sender: Any) {
        textView.endEditing(true)
        if segmentController.selectedSegmentIndex == 0 {
            answerValue = textView.text
            textView.text = taskValue
        } else {
            taskValue = textView.text
            textView.text = answerValue
        }
    }
    
    @IBAction func swipeAction(_ sender: Any) {
        if let swipe = sender as? UISwipeGestureRecognizer {
            if swipe.direction == .right {
                backAction(0)
            }
        }
    }
    
    func uploadData(name: String, type: TaskType, task: Task? = nil) {
        self.type = type
        self.catalog = name
        self.task = task
        catalogNameLabel.text = name
        switch type {
        case .photo:
            segmentController.isHidden = true
            answerLabel.isHidden = false
            isTaskHidden = true
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
                textView.text = textTask
                if let answer = task.answer {
                    answerValue = answer
                } else {
                    //error
                }
            } else {
                if let answer = task.answer {
                    textView.text = answer
                } else {
                    //error
                }
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
