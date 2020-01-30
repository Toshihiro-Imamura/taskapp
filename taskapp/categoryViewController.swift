//
//  categoryViewController.swift
//  taskapp
//
//  Created by 今村俊博 on 2020/01/19.
//  Copyright © 2020 toshihiro.imamura. All rights reserved.
//

import UIKit
import RealmSwift

class categoryViewController: UIViewController {
    
    @IBOutlet weak var newCategoryTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    let realm = try! Realm()
    var category: Category!
    var categoryArray = try! Realm().objects(Category.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer( tapGesture)
        
        if self.newCategoryTextField.text! == "" {
            self.saveButton.isEnabled = false
        }else{
            self.saveButton.isEnabled = true
        }
        
        
    }
    @IBAction func newCategoryTextField(_ sender: Any) {
        self.saveButton.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.newCategoryTextField.text == ""{
            let allCategories = realm.objects(Category.self)
            let lastcategory = realm.objects(Task.self).filter("id == \(allCategories.count) ")
            if allCategories.count != 0{
                try! realm.write {
                    realm.delete(lastcategory)
                    
                }
            }
        }
        print(category.categoryname)
        print(categoryArray.count)
        super.viewWillDisappear(animated)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        try! Realm().write {
            self.category.categoryname = self.newCategoryTextField.text!
            self.realm.add(self.category, update: .modified)
            
        }
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.newCategoryTextField.text = ""
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        let category = Category()
        
        inputViewController.category = category
        
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
