//
//  TableViewController.swift
//  ToDoList(SwiftBook)
//
//  Created by Дмитрий Емелин on 14.09.2022.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var toDoItems: [TaskDo] = []
    
    @IBAction func deleteTasks(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TaskDo> = TaskDo.fetchRequest()
        
        if let tasks = try? context.fetch(fetchRequest) {
            for task in tasks {
                context.delete(task)
            }
        }
        
        
        do {
            try context.save()
            print("Yeap! You delete all elements")
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add Task", message: "add new task", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { action in            
            let textField = alertController.textFields?[0]
            //self.toDoItems.insert((textField?.text)!, at: 0)
            self.saveTask(taskToDo: (textField?.text)!)
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
       
        alertController.addTextField {
            textField in
            
        }
        
        alertController.addAction(cancel)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func saveTask(taskToDo: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "TaskDo", in: context) else { return }
        let taskObject = NSManagedObject(entity: entity, insertInto: context) as! TaskDo
        taskObject.taskToDo = taskToDo
        
        do {
            try context.save()
            toDoItems.append(taskObject)
            print("Saved! Good Job!")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TaskDo> = TaskDo.fetchRequest()
        
        do {
            toDoItems = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let task = toDoItems[indexPath.row]
        cell.textLabel?.text = task.taskToDo

        return cell
    }
    
    //MARK: detete one element from table view
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        guard let taskToDelete = toDoItems[indexPath.row] as? TaskDo, editingStyle == .delete else { return }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        context.delete(taskToDelete)
        toDoItems.remove(at: indexPath.row)
        
        do {
            try context.save()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print(error.localizedDescription)
        }
        
    }/*
 self.toDoItems.remove(at: indexPath.row)
 tableView.deleteRows(at: [indexPath], with: .fade)

 let appDelegate = UIApplication.shared.delegate as! AppDelegate
 let context = appDelegate.persistentContainer.viewContext

 let fetchRequest: NSFetchRequest<TaskDo> = TaskDo.fetchRequest()
 
 let arrayData = try context.fetch(fetchRequest)
 
 let elementToDelete = arrayData[indexPath.row]

 context.delete(elementToDelete)

 do {
     try context.save()
 } catch {
     print(error.localizedDescription)

 }
 */
}
