//
//  DetailViewController.swift
//  master
//
//  Created by Martynas Adomaitis on 19/05/2020.
//  Copyright © 2020 Martynas Adomaitis. All rights reserved.
//
//  Reference MasterDetailV2 2 2
//

import UIKit
import CoreData
import UserNotifications

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate {


    var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchRequest: NSFetchRequest<Task>!
    var tasks: [Task]!
    //var object:Coursework?
    
    @IBOutlet var detailDescriptionLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    func configureView() {
        if let detail = newCoursework {
            if let label = detailDescriptionLabel {
                label.text = detail.mainCourseworkName
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})

        
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTopView" {
            if let topViewController = segue.destination as? InfoViewController {
                
                // ?? 0 - Means default value
                topViewController.moduleName = newCoursework?.mainModuleName
                topViewController.moduleLevel = newCoursework?.mainLevel
                topViewController.moduleNotes = newCoursework?.mainNotes
                topViewController.courseworkDueDate = newCoursework?.mainDueDate
               
            }
        }
        if segue.identifier == "toAddTasks" {
            if let addTaskViewController = segue.destination as? AddTaskViewController {
                addTaskViewController.currentCoursework = newCoursework
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var newCoursework: Coursework? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    //TableView section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            
            //if self.object != nil {
               // if let object = self.controller.fetchedObjects , object.count > 0 {
                    
                    //let item = object[indexPath.row]
                    self.performSegue(withIdentifier: "toAddTasks", sender: self)
                    
                    let vc = AddTaskViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                //}
            //}
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [delete, edit]
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let context = self.fetchedResultsController.managedObjectContext
//            context.delete(self.fetchedResultsController.object(at: indexPath))
//
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        let task = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withTask: task)
        return cell
    }
    
    func configureCell(_ cell: TaskTableViewCell, withTask task: Task) {
        cell.taskNameLabel.text = task.taskName
        let startFormatter = DateFormatter()
        startFormatter.dateStyle = .medium
        startFormatter.timeStyle = .none
        
        let startDate = task.taskStartDate
        if startDate != nil {
            let startDateString = startFormatter.string(from: startDate!)
            cell.taskStartLabel?.text = "Start task: \(startDateString)"
        }
        let endDate = task.taskFinishDate
        if endDate != nil {
            let endDateString = startFormatter.string(from: endDate!)
            cell.taskTimeLeft?.text = "Task due: \(endDateString)"
        }
        
        let todaysDate = Date()
            if endDate != nil {
                if todaysDate > endDate! {
                    cell.taskTimeLeft?.text = "Time expired"
                    cell.taskTimeLeft.textColor = UIColor.red
                    
                }
                
        }
        
        
    }
    
    @IBAction func setReminder(_ sender: UIBarButtonItem) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.subtitle = "The coursework is due soon"
        if let detail = self.newCoursework {
            content.body = "Deadline is coming up for an task: \(detail.mainModuleName!)"
        }
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "timeDone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        if let reminder = self.newCoursework {
        let reminderTapped = UIAlertController(title: "Reminder", message: "The reminder for \(reminder.mainModuleName!) has been set.", preferredStyle: .alert)
        reminderTapped.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(reminderTapped, animated: true, completion: {
            //self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
    //Fetch results section
    
    
    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<Task> {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        
        let currentCoursework  = self.newCoursework
        let request:NSFetchRequest<Task> = Task.fetchRequest()
        //simpler version for just getting the albums
        //   let albums:NSSet = (currentArtist?.albums)!
        
        request.fetchBatchSize = 20
        //sort alphabetically
        let taskNameSortDescriptor = NSSortDescriptor(key: "taskName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        //simpler version
        //   albums.sortedArray(using: [albumNameSortDescriptor])
        
        
        request.sortDescriptors = [taskNameSortDescriptor]
        //we want the albums for the recordArtist - via the relationship
        if (self.newCoursework != nil){
            let predicate = NSPredicate(format: "recordTask = %@", currentCoursework!)
            request.predicate = predicate
        }
        else {
            //just do all albums for the first artist in the list
            //replace this to get the first artist in the record
            let predicate = NSPredicate(format: "newCoursework = %@","Pink Floyd")
            request.predicate = predicate
            
            
        }
        let frc = NSFetchedResultsController<Task>(
            fetchRequest: request,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: #keyPath(Task.newCoursework),
            cacheName:nil)
        frc.delegate = self
        _fetchedResultsController = frc
        
        do {
            //    try frc.performFetch()
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        
        return frc as! NSFetchedResultsController<NSFetchRequestResult> as! NSFetchedResultsController<Task>
    }//end var
    
    //MARK: - fetch results table view functions
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    //must have a NSFetchedResultsController to work
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType(rawValue: 0)!:
            // iOS 8 bug - Do nothing if we get an invalid change type.
            break
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)! as! TaskTableViewCell, withTask: anObject as! Task)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            //    default: break
            
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
        // self.tableView.reloadData()
    }

}

