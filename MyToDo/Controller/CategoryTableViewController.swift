//
//  CategoryTableViewController.swift
//  MyToDo
//
//  Created by Anil Thomas on 12/19/21.
//

import UIKit
import CoreData



class CategoryTableViewController: UITableViewController {

    
     var categoryList = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

       
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
        cell.textLabel?.text = categoryList[indexPath.row].name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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
            let category = Category(context: self.context)
            print("cateogy is \(textField.text)")
            category.name = textField.text
            self.categoryList.append(category)
            self.saveData()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    
    }
}




//MARK: - saving to db

extension CategoryTableViewController{
    func saveData()
    {
        do{
            try context.save()
        }
        catch{
            print("error while saving data")
        }
        
        tableView.reloadData()
        
        
    }
}


//MARK: - loading from db


extension CategoryTableViewController{
    func loadData(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            try categoryList = context.fetch(request)
        
    }
        catch {
            print("error loading data from db")
        }
}
}
