//
//  CategoryViewController.swift
//  Todo-it
//
//  Created by Mohaned Yossry on 4/22/20.
//  Copyright © 2020 Mohaned Yossry. All rights reserved.
//

import UIKit
import RealmSwift
import UIColor_Hex_Swift
class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var categoryList:Results<TodoCategory>?
    
    var token:NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.categoryCellIdentifier)
         token = categoryList?.observe {  change  in
            self.numberLabel.text = "You have \(self.categoryList?.count ?? 0) categories"
        }
    }
    

    deinit {
                token?.invalidate()

    }
    //MARK: - Table Delegate Tables
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryList?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellIdentifier, for: indexPath) as! CategoryTableViewCell
        
        cell.categoryItem = categoryList?[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: K.itemsListSegue, sender: self)
        
    }
    
    @IBAction func onAddCategoryPressed(_ sender: UIButton) {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: K.popUpVC) as? BottomSheetViewController else { return }
        popVC.type = .category
        popVC.delegate = self
        present(popVC, animated: false, completion: nil)
    }
    
    
    //MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.itemsListSegue{
            let destinationVC = segue.destination as! TodoViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categoryList?[indexPath.row]
            }
            
        }
    }
    
    //MARK: - Saves data to the CoreData
    func saveData(category:TodoCategory){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print(error)
        }
        tableView.reloadData()
        
    }
    
    func loadData() {
         categoryList = realm.objects(TodoCategory.self)
        
        tableView.reloadData()
        numberLabel.text = "You have \(categoryList?.count ?? 0) categories"
    }
    
}
extension CategoryViewController :  BottomSheetDelegate{
    func itemIsAdded(text: String) {
        let category = TodoCategory()
        category.name = text
        category.color = UIColor.random.hexString()
        saveData(category: category)
        
    }
    
}
