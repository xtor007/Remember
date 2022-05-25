//
//  ExerciseVC.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 24.05.2022.
//

import UIKit

class ExerciseVC: UIViewController {
    
    var game: Game!
    
    var closeDelegate: CloseDelegate!
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var passedLabel: UILabel!
    @IBOutlet weak var forwardLabel: UILabel!
    
    @IBOutlet weak var taskText: UITextView!
    @IBOutlet weak var taskImage: UIImageView!
    
    var changeValues: ((Int,Int,Int)->(Void))!
    var startQuiz: ((Task,[String])->(Void))!
    
    var isNeedInitTask = false
    var isFinish = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFinish {
            if let finalVC = self.storyboard?.instantiateViewController(withIdentifier: "finalVC") as? FinalVC {
                finalVC.modalPresentationStyle = .fullScreen
                self.presentDetail(finalVC) {
                    finalVC.closeDelegate = self
                }
            }
            return
        }
        if isNeedInitTask {
            initTask()
            isNeedInitTask = false
        }
    }
    
    func uploadData(tasks: [Task]) {
        game = Game(tasks: tasks, onFinish: {
            self.isFinish = true
            if let finalVC = self.storyboard?.instantiateViewController(withIdentifier: "finalVC") as? FinalVC {
                finalVC.modalPresentationStyle = .fullScreen
                self.presentDetail(finalVC) {
                    finalVC.closeDelegate = self
                }
            }
        })
        changeValues = { leftValue, passedValue, forwardValue in
            self.leftLabel.text = leftValue.description
            self.passedLabel.text = passedValue.description
            self.forwardLabel.text = forwardValue.description
        }
        startQuiz = { task, answers in
            if let quizVC = self.storyboard?.instantiateViewController(withIdentifier: "quizVC") as? QuizVC {
                quizVC.modalPresentationStyle = .fullScreen
                self.present(quizVC, animated: true) {
                    quizVC.uploadData(answers: answers, rightAnswer: task.answer!)
                    quizVC.quizAnswerDelegate = self
                }
            } else {
                self.showError(message: "Somethig is not good, reload app")
            }
        }
        initTask()
    }
    
    private func initTask() {
        let task = game.getNewTask(changeValues: changeValues)
        if let task = task {
            if let text = task.textTask {
                taskText.text = text
            }
            if let imageData = task.photoTask {
                taskImage.image = UIImage(data: imageData)
            }
        } else {
            showError(message: "Somethig is not good, reload app")
        }
    }
    
    private func showAnswer() {
        showAlert(title: "REMEBER!", message: "Answer is \(self.game.answer)", actions: [
            UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.initTask()
            })
        ])
    }
    
    @IBAction func closeAction(_ sender: Any) {
        showAlert(title: "REMEMBER", message: "Are you sure?", actions: [
            UIAlertAction(title: "YES", style: .default, handler: { _ in
                self.dismissDetail {
                    self.closeDelegate.closeVC()
                }
            }),
            UIAlertAction(title: "NO", style: .default)
        ])
    }
    
    @IBAction func showAnswerAction(_ sender: Any) {
        showAlert(title: "REMEMBER!", message: "Do you know this?", actions: [
            UIAlertAction(title: "YES", style: .default, handler: { _ in
                self.game.answerSend(isKnown: true, changeValues: self.changeValues, startQueez: self.startQuiz)
                self.showAnswer()
            }),
            UIAlertAction(title: "NO", style: .default, handler: { _ in
                self.game.answerSend(isKnown: false, changeValues: self.changeValues, startQueez: self.startQuiz)
                self.showAnswer()
            })
        ])
    }

}

extension ExerciseVC: QuizAnswerDelegate {
    
    func postAnswer(isRight: Bool) {
        game.quizAnswer(isRight: isRight, changeValues: changeValues)
        isNeedInitTask = true
    }
    
}

extension ExerciseVC: CloseDelegate {
    
    func closeVC() {
        dismiss(animated: false) {
            self.closeDelegate.closeVC()
        }
    }
    
}
