//
//  Game.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 24.05.2022.
//

import Foundation

class Game {
    
    private var left = [Task]()
    private var passed = [Task]()
    private var forward = [Task]()
    
    private var summaryCount = 0
    
    private var isQuizStart = false
    
    private var currentTask: Task?
    
    private(set) var answer = ""
    
    private var onFinish: ()->(Void)
    
    init (tasks: [Task], onFinish: @escaping ()->(Void)) {
        left = tasks
        currentTask = nil
        self.onFinish = onFinish
        summaryCount = tasks.count
    }
    
    func getNewTask(changeValues: @escaping (Int,Int,Int)->(Void)) -> Task? {
        currentTask = left.randomElement()
        left.remove(at: left.firstIndex(of: currentTask!)!)
        changeValues(left.count+1,passed.count,forward.count)
        answer = currentTask!.answer!
        return currentTask
    }
    
    func answerSend(isKnown: Bool, changeValues: @escaping (Int,Int,Int)->(Void), startQueez: @escaping (Task,[String])->(Void)) {
        if isKnown {
            let chance = 0.2
            let randValue = Double.random(in: 0..<1)
            if randValue < chance && summaryCount > 4  {
                isQuizStart = true
                startQueez(currentTask!, getAnswersForTask(currentTask!))
                return
            } else {
                passed.append(currentTask!)
            }
        } else {
            forward.append(currentTask!)
        }
        currentTask = nil
        if left.count == 0 {
            if forward.count == 0 {
                onFinish()
            } else {
                left = forward
                forward = []
            }
        }
        changeValues(left.count,passed.count,forward.count)
    }
    
    func quizAnswer(isRight: Bool, changeValues: @escaping (Int,Int,Int)->(Void)) {
        if isQuizStart {
            isQuizStart = false
            if isRight {
                passed.append(currentTask!)
            } else {
                forward.append(currentTask!)
            }
            currentTask = nil
            if left.count == 0 {
                if forward.count == 0 {
                    onFinish()
                } else {
                    left = forward
                    forward = []
                }
            }
            changeValues(left.count,passed.count,forward.count)
        }
    }
    
    private func getAnswersForTask(_ task: Task) -> [String] {
        var answers = [String]()
        let tasks = left + passed + forward
        while answers.count < 3 {
            let ranTask = tasks.randomElement()!
            if ranTask.answer == task.answer || answers.contains(ranTask.answer!) {
                continue
            }
            answers.append(ranTask.answer!)
        }
        return answers
    }
    
}
