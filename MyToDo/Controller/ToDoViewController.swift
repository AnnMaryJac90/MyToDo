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
//    var item1 = Item()
//    var item2 = Item()
//    var item3 = Item()
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
//        item1.title = "Buy groceries"
//        item2.title = "GO to Library"
//        item3.title = "pay bill"
//        myList = [item1,item2,item3]
//
        loadData()
      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
    
    
    //MARK: - delgate methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        tableView.deselectRow(at: indexPath, animated: true)
        myList[indexPath.row].done = !myList[indexPath.row].done
    
        saveData()
        tableView.reloadData()
        
    }
    
    
    //MARK: - Adding an item to list
    
    
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
    
    
    
    func saveData(){
      
        do {
            
         
           
            try context.save()
        }
        catch {
            print(error)
        }
     
        self.tableView.reloadData()
    }
    
    
    
    func loadData() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
        myList = try context.fetch(request)
        
    }
        catch{
            print("eroor while fetching data from db \(error)")
        }
}

}
