//
//  DataService.swift
//  Remember
//
//  Created by Anatoliy Khramchenko on 20.05.2022.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class DataService {
    
    static let storage = DataService()
    
    func addNewCatalog(name: String, type: TaskType, onSucces: @escaping ()->(Void), onError: @escaping (String)->(Void)) {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            onError("Something is not good")
            return
        }
        let catalog = Catalog(context: context)
        catalog.name = name
        catalog.type = type.rawValue
        do {
            try context.save()
            onSucces()
        } catch {
            onError(error.localizedDescription)
        }
    }
    
    func getAllCatalogs(onSucces: @escaping ([Catalog])->(Void), onError: @escaping (String)->(Void)) {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            onError("Something is not good")
            return
        }
        var res = [Catalog]()
        let fetchRequest = NSFetchRequest<Catalog>(entityName: "Catalog")
        do {
            try res = context.fetch(fetchRequest)
            onSucces(res)
        } catch {
            onError(error.localizedDescription)
        }
    }
    
    func getTasks(forCatalog catalog: String, onSucces: @escaping ([Task])->(Void), onError: @escaping (String)->(Void)) {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            onError("Something is not good")
            return
        }
        var tasks = [Task]()
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        do {
            try tasks = context.fetch(fetchRequest)
            var res = [Task]()
            for task in tasks {
                if task.catalog == catalog {
                    res.append(task)
                }
            }
            onSucces(res)
        } catch {
            onError(error.localizedDescription)
        }
    }
    
    func isCatalogNameOk(_ name: String, onSucces: @escaping (Bool)->(Void), onError: @escaping (String)->(Void)) {
        getAllCatalogs { catalogs in
            if catalogs.contains(where: { catalog in
                catalog.name == name
            }) {
                onSucces(false)
            } else {
                onSucces(true)
            }
        } onError: { message in
            onError(message)
        }
    }
    
    func addTask(forCatalog catalog: String, withTextTask text: String?, withPhoto photo: UIImage?, withAnswer answer: String, onSucces: @escaping ()->(Void), onError: @escaping (String)->(Void)) {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            onError("Something is not good")
            return
        }
        let task = Task(context: context)
        task.catalog = catalog
        task.textTask = text
        if let photo = photo {
            task.photoTask = photo.pngData()
        }
        task.answer = answer
        do {
            try context.save()
            onSucces()
        } catch {
            onError(error.localizedDescription)
        }
    }
    
    func deleteTask(_ task: Task, onSucces: @escaping ()->(Void), onError: @escaping (String)->(Void)) {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            onError("Something is not good")
            return
        }
        context.delete(task)
        do {
            try context.save()
            onSucces()
        } catch {
            onError(error.localizedDescription)
        }
    }
    
}
