//
//  InfoViewController.swift
//  master
//
//  Created by Martynas Adomaitis on 19/05/2020.
//  Copyright © 2020 Martynas Adomaitis. All rights reserved.
//

import UIKit
import CoreData

class InfoViewController: UIViewController {

    @IBOutlet var moduleNameLabel: UILabel!
    @IBOutlet var moduleLevelLabel: UILabel!
    @IBOutlet var moduleNotesTextView: UITextView!
    @IBOutlet var moduleTimeLeftLabel: UILabel!
    @IBOutlet var moduleDueDateLabel: UILabel!
    
    
    var moduleName:String?
    var moduleLevel:Int16?
    var moduleNotes:String?
    var courseworkDueDate:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moduleNameLabel.text = moduleName
        //Provide a default value to avoid this warning "?? 0"
        moduleLevelLabel.text = "Level:\(moduleLevel ?? 0)"
        moduleNotesTextView.text = moduleNotes
        
        dateToString()
        timeLeft()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func timeLeft() {
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        if courseworkDueDate != nil {
            let timeLeft = Calendar.current.dateComponents([.day], from: todaysDate, to: courseworkDueDate!).day
            moduleTimeLeftLabel.text = "Days left: \(String(timeLeft!))"
        }
    }
    
    func dateToString() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    
        
        if courseworkDueDate != nil { //courseworkDueDate returns nil when coursework is not selected
            
            let dateString = dateFormatter.string(from: courseworkDueDate!)
          moduleDueDateLabel.text = dateString
        }
        
    }

}
