//
//  CategoryTableViewController.swift
//  MyToDo
//
//  Created by Anil Thomas on 12/19/21.
//

import UIKit
import RealmSwift



class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    var categoryList : Results<Category>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

       
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
        cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No category added yet"
       
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toItems" , sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC = segue.destination as! ToDoViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryList?[indexPath.row]
    }
    }
    
}


//MARK: - adding the category


extension CategoryTableViewController{
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new category",message: nil, preferredStyle: .alert)
        alert.addTextField { alertText in
            textField = alertText
        }
        
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
            let category = Category()
            category.name = textField.text!
           
            self.saveData(with: category)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    
    }
}




//MARK: - saving to db

extension CategoryTableViewController{
    func saveData(with category:Category)
    {
        do {
         try realm.write {
            realm.add(category)
        }
        }
        catch {
            print(error)
        }
        tableView.reloadData()
        
        
    }
}


//MARK: - loading from db


extension CategoryTableViewController{
    func loadData(){
        
        categoryList = realm.objects(Category.self)
       
}
}
