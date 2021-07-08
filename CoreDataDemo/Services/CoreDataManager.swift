//
//  CoreDataManager.swift
//  CoreDataDemo
//
//  Created by Екатерина Боровкова on 06.07.2021.
//
import CoreData
import Foundation

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    //        контейнер содержит весь стек кор даты приложения
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataDemo")
        //        контейнер загрузает все сущности, которые есть
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        //        контекст - область которая позволяет работать с данными
        //        контекст - прослойка сессии
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(_ text: String) -> Task? {
        //        достаем ОПИСАНИЕ СУЩНОСТИ, который мы создали в кор дате
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: persistentContainer.viewContext) else { return nil}
        //        создаем объект(сущность) задачи, задача описана в энтитидискрипшион, область объекта описана во вьюконтекст
        guard let task = NSManagedObject(entity: entityDescription, insertInto: persistentContainer.viewContext) as? Task else { return nil}
        //передаем параметр метода текст в тайтл таска
        task.title = text
        
        //        если это изменяет контекст, сохраняемся, если нет, то ничего не делаем
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }
        return task
    }
    
    func fetchData() -> [Task] {
        //        получаем данные из бд в типе таск(<Task>)
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        //        обработки ошибки при передалчи данных в массив типа таск
        do {
            //            возвращает массив объяектов по определенному запросу
            let tasks = try persistentContainer.viewContext.fetch(fetchRequest)
            return tasks
        } catch let error {
            print(error)
        }
        return[]
    }
    
    func takeTask(title: String) -> Task?{
        //        получаем данные из бд в типе таск(<Task>)
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        //        делаем предикат
        fetchRequest.predicate = NSPredicate(format: "title == %@",title)
        
        do {
            //            возвращает массив объяектов по определенному запросу
            let task = try persistentContainer.viewContext.fetch(fetchRequest)
            let selectedTask = task.first!
            return selectedTask
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    func delete(task: Task){
        
        persistentContainer.viewContext.delete(task)
        
        do{
            try persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}
