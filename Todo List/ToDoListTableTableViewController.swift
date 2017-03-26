//
//  ToDoListTableTableViewController.swift
//  Todo List
//
//  Created by Rey Cerio on 2017-03-25.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit

class ToDoListTableTableViewController: UITableViewController, UITextFieldDelegate{
    
    let cellId = "cellId"
    let headerId = "headerId"
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTaskTable()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerId)

    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            let task = self.tasks[indexPath.row]
            if let url = URL(string: "http://localhost:8080/tasks/delete") {
        
                var request = URLRequest(url: url)
                request.httpMethod = "POST"  //header like in postMan or SQL DB
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: ["taskId": task.taskId], options: [])  //body like in postMan or SQL DB
                }catch {
                    
                }
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    DispatchQueue.main.async(execute: {
                        self.fetchTaskTable()
                    })
                }).resume()
            }else {}

            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        headerView.backgroundColor = .white
        
        let textField = UITextField(frame: CGRect(x: 6, y: 0, width: self.view.frame.width, height: 44))
        textField.placeholder = "Enter task here"
        textField.delegate = self
        
        headerView.addSubview(textField)
        return headerView
    }
    //must give the header a height so it shows
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let url = URL(string: "http://localhost:8080/tasks/create") {
            if let taskTitle = textField.text {
                let task = Task(taskId: nil, title: taskTitle)
                var request = URLRequest(url: url)
                request.httpMethod = "POST"  //header like in postMan or SQL DB
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: ["title": taskTitle], options: [])  //body like in postMan or SQL DB
                }catch {
                    
                }
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    DispatchQueue.main.async(execute: { 
                        self.fetchTaskTable()
                    })
                }).resume()
            }else {}
        }else {}
        textField.text = ""
        return textField.resignFirstResponder()
    }
    
    
    private func fetchTaskTable() {
        self.tasks = [] //make sure empty array so it doesnt load what it previously has in it
        let url = URL(string: "http://localhost:8080/tasks/all")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do{
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String: Any]]
                for item in result {
                    
                    let taskId = item["taskId"] as! Int
                    let title = item["title"] as! String
                    
                    let task = Task(taskId: taskId, title: title)
                    self.tasks.append(task)
                    
                    DispatchQueue.main.async(execute: { 
                        self.tableView.reloadData()
                    })
            }

            }catch let err {
                print(err)
            }
            
        }.resume()
        
    }
 
}


