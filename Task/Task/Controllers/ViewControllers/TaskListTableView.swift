//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Rishi Kolappa on 4/21/21.
//

import UIKit

class TaskListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        TaskController.sharedInstance.loadFromPersistenceStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TaskController.sharedInstance.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let task = TaskController.sharedInstance.tasks[indexPath.row]
        
        cell.textLabel?.text = task.taskName

        return cell
    }

    //heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 7
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = TaskController.sharedInstance.tasks[indexPath.row]
            TaskController.sharedInstance.delete(taskToDelete: taskToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? TaskDetailViewController else {return}
            
            let tasktoSend = TaskController.sharedInstance.tasks[indexPath.row]
            destinationVC.task = tasktoSend
    

        }
    }
} //End of class

extension TaskListTableViewController: TaskCellDelegate {
    func taskSwitchTapped(for cell: TaskTableViewCell) {
       
        guard let indexPath = tableView.indexPath(for: cell) else {return}

        let task = TaskController.sharedInstance.tasks[indexPath.row]
  
        TaskController.sharedInstance.toggleIsComplete(task: task)
    
        cell.updateViews(for: task)
        
    }
}
