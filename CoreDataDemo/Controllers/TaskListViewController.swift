//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by 18992227 on 05.07.2021.
//

import CoreData
import UIKit

final class TaskListViewController: UITableViewController {
    
    private static let cellId = "cell"
    private var tasks: [Task] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellId)
        tableView.dataSource = self
        tableView.reloadData()
        setupNavigationBar()
        fetchDataTasks()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDataTasks()
        tableView.reloadData()
    }
    private func fetchDataTasks(){
        tasks = CoreDataManager.shared.fetchData()
    }
    private func setupNavigationBar() {
        title = "Task List"
        
        //        делаем навигейшн опциональным для того, чтобы не упасть, если кто то обратится к TaskListViewController миную навигейшн
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appeareance
        //        отвечает за внешний вид(появление) навигейшена
        let navBarAppereance = UINavigationBarAppearance()
        //        делаем навигейшен полупрозрачным
        navBarAppereance.configureWithOpaqueBackground()
        
        //        настройка цветов текста через атрибуты
        navBarAppereance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppereance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppereance.backgroundColor = UIColor(
            red: 21 / 255,
            green: 101 / 255,
            blue: 192 / 255,
            alpha: 194 / 255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppereance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppereance
        
        // Add button to nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        let newTaskVC = NewTaskViewController()
        newTaskVC.modalPresentationStyle = .fullScreen
        present(newTaskVC, animated: true)
        
        
    }
    
    private func showAlert(with title: String, task: Task) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(
            title: "Save",
            style: .default) { _ in
            
            //            предаем значение текста в свойство тайтл в сущности сор даты
            task.title = alert.textFields?.first?.text
            if !task.title!.isEmpty{
               CoreDataManager.shared.saveContext()
              
                //                обновляем табличку для отображение обновленных данных
                self.tableView.reloadData()
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField { textField in
            textField.text = task.title
            
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellId, for: indexPath)
        let task = tasks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(with: "Your Task is:", task: tasks[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //        получаем текущую таску для удаления
            let currentTask = tasks[indexPath.row]
            //            вызываем метод удаления из кор даты
            CoreDataManager.shared.delete(task: currentTask)
            //            получаем объекты из кор даты для отображения
            tasks.remove(at: indexPath.row)
            //            удаляем ячейку по выбранному индекспасу
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
