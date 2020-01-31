//
//  InputViewController.swift
//  taskapp
//
//  Created by 今村俊博 on 2020/01/15.
//  Copyright © 2020 toshihiro.imamura. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicke: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!
    
    
    let realm = try! Realm()
    var task: Task!
    var category: Category!
    
    var pickerView: UIPickerView = UIPickerView()
    var categoryArray = try! Realm().objects(Category.self)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pickerView.reloadAllComponents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicke.date = task.date
        categoryTextField.text = task.category
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.categoryTextField.inputView = pickerView
        
        
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return self.categoryArray.count + 1
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if row == 0 {
            return "カテゴリなし"
        }else{
            return "\(categoryArray[row-1].categoryname)"
        }
    }
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if row == 0{
            self.categoryTextField.text = " "
        }else{
            self.categoryTextField.text = "\(self.categoryArray[row-1].categoryname)"
        }
    }
    
    
    
    @IBAction func 保存(_ sender: Any) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicke.date
            self.task.category = self.categoryTextField.text!
            self.realm.add(self.task, update: .modified)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        setNitification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func setNitification(task: Task){
        let content = UNMutableNotificationContent()
        
        if task.title == ""{
            content.title = "(内容なし)"
        } else {
            content.body = task.contents
            
        }
        content.sound = UNNotificationSound.default
        
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request){(error) in
            print(error ?? "ローカル通知登録　OK")
            
        }
        
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let categoryViewController:categoryViewController = segue.destination as! categoryViewController
        
        let category = Category()
        
        let allCategories = realm.objects(Category.self)
        
        if allCategories.count != 0{
            category.categoryid = allCategories.max(ofProperty: "categoryid")! + 1
        }
        
        categoryViewController.category = category
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
