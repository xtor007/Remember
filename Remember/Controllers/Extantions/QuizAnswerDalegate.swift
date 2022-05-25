//
//  QuizAnswerDalegate.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 25.05.2022.
//

import Foundation

protocol QuizAnswerDelegate {
    func postAnswer(isRight: Bool)
}
