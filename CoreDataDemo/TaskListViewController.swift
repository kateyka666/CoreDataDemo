//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by 18992227 on 05.07.2021.
//

import CoreData
import UIKit

final class TaskListViewController: UITableViewController {
//    получаем контекст из кор даты
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private static let cellId = "cell"
    private var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellId)
        tableView.dataSource = self
        setupNavigationBar()
        fetchData()
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchData()
        tableView.reloadData()
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
        //let newTaskVC = NewTaskViewController()
        //newTaskVC.modalPresentationStyle = .fullScreen
        //present(newTaskVC, animated: true)

        showAlert(with: "New Task", message: "What do you want to enter?")
    }

    private func fetchData() {
//        получаем данные из бд в типе таск(<Task>)
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()

//        обработки ошибки при передалчи данных в массив типа таск
        do {
//            возвращает массив объяектов по определенному запросу
            tasks = try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
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

    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let saveAction = UIAlertAction(
            title: "Save",
            style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }

            self.save(task)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    private func save(_ text: String) {
//        достаем ОПИСАНИЕ СУЩНОСТИ который мысоздали в кор дате
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: viewContext) else { return }
//        создаем объект(сущность) задачи, задача описана в энтитидискрипшион, область объекта описана во вьюконтекст
        guard let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Task else { return }
//передаем параметр метода текст в тайтл таска
        task.title = text

//        если это изменяет контекст, сохраняемся, если нет, то ничего не делаем
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                print(error)
            }
        }

        tasks.append(task)
        let cellIndex = IndexPath(row: tasks.count - 1, section: 0)

        tableView.insertRows(at: [cellIndex], with: .automatic)
    }
}
