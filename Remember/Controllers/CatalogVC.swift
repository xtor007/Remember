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
    @IBOutlet weak var starImage: UIImageView!
    
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
    
    @IBAction func swipeAction(_ sender: Any) {
        if let swipe = sender as? UISwipeGestureRecognizer {
            if swipe.direction == .right {
                backAction(0)
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
        goButton.setTitle("", for: .normal)
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear) {
            let reductionFactor: CGFloat = 0.4
            self.goButton.transform = CGAffineTransform(scaleX: reductionFactor, y: reductionFactor)
        } completion: { isFinish in
            if isFinish {
                self.goToExercise()
            } else {
                //error
            }
        }

    }
    
    private func goToExercise() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn) {
            let magnificationFactor: CGFloat = 20
            self.starImage.transform = CGAffineTransform(scaleX: magnificationFactor, y: magnificationFactor)
        } completion: { isFinish in
            if isFinish {
                if let exerciseVC = self.storyboard?.instantiateViewController(withIdentifier: "exerciseVC") as? ExerciseVC {
                    exerciseVC.modalPresentationStyle = .fullScreen
                    DataService.storage.getTasks(forCatalog: self.catalog.name!) { tasks in
                        self.present(exerciseVC, animated: false) {
                            exerciseVC.uploadData(tasks: tasks)
                            exerciseVC.closeDelegate = self
                            self.starImage.transform = CGAffineTransform.identity
                        }
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
    }

}

extension CatalogVC: CloseDelegate {
    
    func closeVC() {
        dismiss(animated: false)
    }
    
}
