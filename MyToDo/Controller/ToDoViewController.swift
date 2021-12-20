//
//  ViewController.swift
//  MyToDo
//
//  Created by Anil Thomas on 12/10/21.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
    var myList = [Item]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    
}

//MARK: - Tableview Data Source

extension ToDoViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return myList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = myList[indexPath.row].title
        cell.accessoryType =  myList[indexPath.row].done ? .checkmark : .none
       
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        tableView.deselectRow(at: indexPath, animated: true)
        myList[indexPath.row].done = !myList[indexPath.row].done
    
        saveData()
      
        
    }
    
}
    //MARK: - Adding an item to list
    
extension ToDoViewController {
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
       
        let alert = UIAlertController(title: "Add an Item", message: "Enter the activity", preferredStyle: .alert)
        
        alert.addTextField { alerttextfield in
            alerttextfield.placeholder = "add an item"
            textfield = alerttextfield
            print("added item is \(alerttextfield)")
           
        }
        
        
        let action = UIAlertAction(title: "Save", style: .default) {  (action) in
            
            let item = Item(context: self.context)
            item.title = textfield.text!
            item.done = false
            self.myList.append(item)
            
            self.saveData()
          
          
        }
      
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
    }
}

//MARK: - Saving to db

extension ToDoViewController {
    
    func saveData(){
        do {
            try context.save()
           }
        catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
}


//MARK: - Loading from db

extension ToDoViewController {
    
    func loadData(with request:NSFetchRequest<Item> = Item.fetchRequest()) {
       
        do {
        myList = try context.fetch(request)
        
    }
        catch{
            print("eroor while fetching data from db \(error)")
        }
        tableView.reloadData()
}
   

}


//MARK: - Search bar funcionalities

extension ToDoViewController : UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
      
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
       loadData(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
    

}
