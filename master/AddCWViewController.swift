//
//  AddCWViewController.swift
//  master
//
//  Created by Martynas Adomaitis on 19/05/2020.
//  Copyright © 2020 Martynas Adomaitis. All rights reserved.
//
//  Reference https://www.youtube.com/watch?v=QBuYmP2p3AY&index=5&list=PL013GXaJjC-vTX1TvwtbT6E3_aEO67UYR

import UIKit
import CoreData

class AddCWViewController: UIViewController {
    
    //let changeDate = UIDatePicker()

    
    @IBOutlet var moduleNameTextField: UITextField!
    @IBOutlet var courseworkNameTextField: UITextField!
    @IBOutlet var dueDateTextField: UITextField!
    @IBOutlet var levelTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var markLabel: UILabel!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var slider: UISlider!
    
    let datePicker = UIDatePicker()
    var courseworkToEdit: Coursework?
    
    var date:Date?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var sliderValue : Int!
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        markLabel.text = String(Int(sender.value))
        let value = String(Int(slider.value))
        markLabel.text = "Mark \(value)"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateToChange()

        if courseworkToEdit != nil {
            loadCourseworkData()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCourseworkData(){
        
        if let editCoursework = courseworkToEdit{
            
           moduleNameTextField.text = editCoursework.mainModuleName
            
            
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        
        let newCoursework = Coursework(context: context)
       
        
            if moduleNameTextField.text != "" {
                
                if let courseworkToEdit = self.courseworkNameTextField.text {
                newCoursework.mainCourseworkName = courseworkToEdit
                }
                if let courseworkToEdit = self.moduleNameTextField.text {
                    newCoursework.mainModuleName = courseworkToEdit
                }
                if let courseworkToEdit = self.notesTextView.text {
                    newCoursework.mainNotes = courseworkToEdit
                }
                if let courseworkToEdit = self.weightTextField.text {
                    newCoursework.mainWeight = Int16(courseworkToEdit)!
                }
                if let courseworkToEdit = self.levelTextField.text {
                    newCoursework.mainLevel = Int16(courseworkToEdit)!
                }
                if let courseworkToEdit = self.markLabel.text {
                    newCoursework.mainMark = courseworkToEdit
                }
                if let courseworkToEdit = self.date {
                    newCoursework.mainDueDate = courseworkToEdit
                }
            
//        newCoursework.mainCourseworkName = courseworkNameTextField.text
//        newCoursework.mainModuleName = moduleNameTextField.text
//        newCoursework.mainNotes = notesTextView.text
//        newCoursework.mainWeight = Int16(String(weightTextField.text!))!
//        newCoursework.mainLevel = Int16(String(levelTextField.text!))!
//        newCoursework.mainMark = markLabel.text
//        newCoursework.mainDueDate = date
        
                
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            print(newCoursework)
            
        }
    }
    

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func dateToChange() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([buttonDone], animated: false)
        
        dueDateTextField.inputAccessoryView = toolbar
        dueDateTextField.inputView = datePicker

        datePicker.datePickerMode = .date
    }
    @objc func doneButtonPressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: datePicker.date)
        

        dueDateTextField.text = "\(dateString)"
        
        date = formatter.date(from: dateString)
        self.view.endEditing(true)
    }
}
