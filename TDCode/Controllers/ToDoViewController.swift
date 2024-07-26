//
//  ViewController.swift
//  TDCode
//
//  Created by Дмитрий Волков on 24.07.2024.
//

import UIKit
import CoreData


class ToDoViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plst")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        if let itemsArray = defaults.array(forKey: "TodoListArray") as? [String] {
//            items = itemsArray
//        }
        
        loadItems()
        
    
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoItemCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))

        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    @objc func addTapped() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //NSencoder
            //let newItem = Item()
            //newItem.title = textField.text!
            
            // CoreData
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            // common
            self.itemArray.append(newItem)
            self.saveItems()
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        /* for NSencoder
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding!")
        }
        */
        
        do {
            try context.save()
        } catch {
            print("Error saving context!")
        }
        
        self.tableView.reloadData()
    }
    func loadItems(){
        /* for NSencoder
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding!")
            }
        }
        */
    }
    
}
    
   
   
