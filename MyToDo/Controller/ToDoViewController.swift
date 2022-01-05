//
//  ViewController.swift
//  MyToDo
//
//  Created by Anil Thomas on 12/10/21.
//

import UIKit
import CoreData
import RealmSwift

class ToDoViewController: UITableViewController {
    let realm = try! Realm()
    var myList = ["cookie","santa"]
    var selectedCategory : Category?{
        didSet{
        loadData()
        }
    }
    
    
    
    
    var itemList : Results<Item>?

  //  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    
}

//MARK: - Tableview Data Source

extension ToDoViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("itemList count is: \(itemList!.count)")
       return itemList?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = itemList?[indexPath.row].title ?? "No item added yet"
        cell.accessoryType = itemList![indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
      //  tableView.deselectRow(at: indexPath, animated: true)
        if let item = itemList?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(item)
                }
            }
            catch {
                print(error)
            }
        }
       
        tableView.reloadData()
    
       
        
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
           
           
        }
        
        
        let action = UIAlertAction(title: "Save", style: .default) {  (action) in
            
            
            if let currentCategory = self.selectedCategory {
                do{
                   try self.realm.write {
                let item = Item()
                       
                item.title = textfield.text!
                item.dateCreated = Date()
                currentCategory.items.append(item)
                       self.realm.add(item)
            }
           
                }
        
                   
                   
        catch{
                print(error)
            }
                self.tableView.reloadData()

          
        }
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    }



//MARK: - Loading from db

extension ToDoViewController {
    
    func loadData() {
        itemList = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
       
        
}


}


//MARK: - Search bar funcionalities

extension ToDoViewController : UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemList = itemList?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
       

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            itemList = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()

            }
           
        }
    }
    


