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
        guard let context = appDelegate?.persistentContainer.viewContext else {return}
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
        guard let context = appDelegate?.persistentContainer.viewContext else {return}
        var res = [Catalog]()
        let fetchRequest = NSFetchRequest<Catalog>(entityName: "Catalog")
        do {
            try res = context.fetch(fetchRequest)
            onSucces(res)
        } catch {
            onError(error.localizedDescription)
        }
    }
    
}
