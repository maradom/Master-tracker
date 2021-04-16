//
//  AddTaskViewController.swift
//  master
//
//  Created by Martynas Adomaitis on 19/05/2020.
//  Copyright © 2020 Martynas Adomaitis. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {

    @IBOutlet var addTaskName: UITextField!
    @IBOutlet var addTaskStartDate: UITextField!
    @IBOutlet var addTaskDueDate: UITextField!
    @IBOutlet var addTaskSlider: UISlider!
    @IBOutlet var addTaskCompletedSlider: UILabel!
    @IBOutlet var addTaskNotes: UITextView!
    
    let datePicker = UIDatePicker()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var sliderValue : Int!
    var currentCoursework:Coursework?
    var startTaskDate:Date?
    var endTaskDate:Date?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskName.becomeFirstResponder()
        dateToChange()
        endDateChange()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTaskTapped(_ sender: UIBarButtonItem) {
        
        let newTask = Task(context: context)
        if addTaskName.text != "" {
            
            if let currentCoursework = self.addTaskName.text{
                newTask.taskName = currentCoursework
            }
            if let currentCoursework = self.addTaskNotes.text {
                newTask.taskNotes = currentCoursework
            }
            if let currentCoursework = self.startTaskDate {
                newTask.taskStartDate = currentCoursework
            }
            if let currentCoursework = self.endTaskDate {
                newTask.taskFinishDate = currentCoursework
            }
            
//        newTask.taskName = addTaskName.text
//        newTask.taskStartDate = startTaskDate
//        newTask.taskFinishDate = endTaskDate
//        newTask.taskNotes = addTaskNotes.text

            currentCoursework?.addToRecordCoursework(newTask)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            print(newTask)
            
        }
    }
    
    @IBAction func cancelTaskTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //start date datePicker and change to string
    func dateToChange() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([buttonDone], animated: false)
        
        addTaskStartDate.inputAccessoryView = toolbar
        addTaskStartDate.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    @objc func doneButtonPressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: datePicker.date)
        
        addTaskStartDate.text = "\(dateString)"
        startTaskDate = formatter.date(from: dateString)
        self.view.endEditing(true)
    }//end of datePicker
    
    
    //end date datePicker and change to string
    func endDateChange() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endDoneButtonPressed))
        toolbar.setItems([buttonDone], animated: false)
        
        addTaskDueDate.inputAccessoryView = toolbar
        addTaskDueDate.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    @objc func endDoneButtonPressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let endDateString = formatter.string(from: datePicker.date)
        
        addTaskDueDate.text = "\(endDateString)"
        endTaskDate = formatter.date(from: endDateString)
        self.view.endEditing(true)
    }//end of datePicker

}
