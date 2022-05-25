//
//  QuizVC.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 25.05.2022.
//

import UIKit

class QuizVC: UIViewController {
    
    @IBOutlet var variants: [UITextView]!
    @IBOutlet var backViews: [UIView]!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var rightAnswer: Int!
    var isAnswerPost = false
    
    var quizAnswerDelegate: QuizAnswerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func uploadData(answers: [String], rightAnswer: String) {
        let rightIndex = Int.random(in: 0...3)
        print(rightIndex)
        self.rightAnswer = rightIndex
        var answerIndex = 0
        for i in 0...3 {
            if i == rightIndex {
                variants[i].text = rightAnswer
            } else {
                variants[i].text = answers[answerIndex]
                answerIndex += 1
            }
        }
    }
    
    @IBAction func answerAction(_ sender: Any) {
        if !isAnswerPost {
            if let button = sender as? UIButton {
                isAnswerPost = true
                backViews[rightAnswer].backgroundColor = .systemGreen
                if button.tag != rightAnswer {
                    backViews[button.tag].backgroundColor = .systemRed
                    nextButton.backgroundColor = .systemRed
                    quizAnswerDelegate.postAnswer(isRight: false)
                } else {
                    nextButton.backgroundColor = .systemGreen
                    quizAnswerDelegate.postAnswer(isRight: true)
                }
            } else {
                //error
            }
        }
    }
    
    @IBAction func stopAction(_ sender: Any) {
        if isAnswerPost {
            dismissDetail()
        } else {
            //error
        }
    }
    
    
}
