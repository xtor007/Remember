//
//  EditCatalogVC.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 21.05.2022.
//

import UIKit

class EditCatalogVC: UIViewController {
    
    var delegate: CloseDelegate!
    
    var catalogName: String!
    var taskType: TaskType!
    
    @IBOutlet weak var catalogNameLabel: UILabel!
    
    @IBOutlet weak var tasksTable: UITableView!
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTable.delegate = self
        tasksTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if catalogName != nil {
            getData()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismissDetail {
            self.delegate.closeVC()
        }
    }
    
    func uploadData(name: String, type: TaskType) {
        catalogName = name
        taskType = type
        catalogNameLabel.text = name
        getData()
    }
    
    private func getData() {
        DataService.storage.getTasks(forCatalog: catalogName) { result in
            self.tasks = result
            self.tasksTable.reloadData()
        } onError: { message in
            //error
        }
    }
}

extension EditCatalogVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tasks.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "addNewTaskCell", for: indexPath) as? AddNewTaskCell {
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "littleTaskCell", for: indexPath) as? LittleTaskCell {
                cell.uploadData(data: tasks[indexPath.row])
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let editTaskVC = storyboard?.instantiateViewController(withIdentifier: "editTaskVC") as? EditTaskVC {
            editTaskVC.modalPresentationStyle = .fullScreen
            presentDetail(editTaskVC) {
                if indexPath.row == self.tasks.count {
                    editTaskVC.uploadData(name: self.catalogName, type: self.taskType)
                } else {
                    let task = self.tasks[indexPath.row]
                    editTaskVC.uploadData(name: self.catalogName, type: self.taskType, task: task)
                    DataService.storage.deleteTask(task) {} onError: { message in
                        //error
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeDelete = UIContextualAction(style: .normal, title: "DELETE") { action, view, succes in
            DataService.storage.deleteTask(self.tasks[indexPath.row]) {
                self.getData()
            } onError: { message in
                //error
            }
        }
        swipeDelete.backgroundColor = .systemRed
        let actions = [swipeDelete]
        let res = UISwipeActionsConfiguration(actions: actions)
        res.performsFirstActionWithFullSwipe = true
        return res
    }
    
}
