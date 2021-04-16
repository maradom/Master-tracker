//
//  MasterViewController.swift
//  master
//
//  Created by Martynas Adomaitis on 19/05/2020.
//  Copyright © 2020 Martynas Adomaitis. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    
    var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchRequest: NSFetchRequest<Coursework>!
    var tasks: [Coursework]!
    var controller: NSFetchedResultsController<Coursework>!
    var object: Coursework!
    
    var detailViewController: DetailViewController? = nil
    //var managedObjectContext: NSManagedObjectContext? = nil
    //var courseworkDueDate:Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem


        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let context = self.fetchedResultsController.managedObjectContext
        let newCoursework = Coursework(context: context)
             
        // If appropriate, configure the new managed object.
        newCoursework.mainStartDate = Date()

        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.newCoursework = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        let Coursework = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEvent: Coursework)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
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
           
            if self.object != nil {
            if let object = self.controller.fetchedObjects , object.count > 0 {
                
                let item = object[indexPath.row]
                self.performSegue(withIdentifier: "editTask", sender: item)
                
                let vc = AddCWViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                
                
               }
            }
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [delete, edit]
    }
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let context = fetchedResultsController.managedObjectContext
//            context.delete(fetchedResultsController.object(at: indexPath))
//
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//
//    }

    //buvo event vietoj coursework
//    func configureCell(_ cell: UITableViewCell, withEvent coursework: Coursework) {
//        cell.textLabel!.text = coursework.mainCourseworkName
//    }
    func configureCell(_ cell: MainTableViewCell, withEvent coursework: Coursework) {
        cell.courseworkNameLabel.text = coursework.mainCourseworkName
        cell.moduleNameLabel.text = coursework.mainModuleName
        cell.courseworkLevelLabel.text = "Level: \(String(Int16(coursework.mainLevel)))"
        cell.courseworkWeightLabel.text = "Weight %\(String(Int16(coursework.mainWeight)))"
        cell.markDisplayLabel.text = coursework.mainMark
        //cell.courseworkProgressView.progress = Float(String(coursework.mainMark!))!
        
        let startFormatter = DateFormatter()
        startFormatter.dateStyle = .medium
        startFormatter.timeStyle = .none
        
        let startDate = coursework.mainDueDate
        if startDate != nil {
            let startDateString = startFormatter.string(from: startDate!)
            cell.courseworkDueDate.text = "Coursework is due: \(startDateString)"
        }
    }
    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<Coursework> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Coursework> = Coursework.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "mainCourseworkName", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<Coursework>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!)! as! MainTableViewCell, withEvent: anObject as! Coursework)
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)! as! MainTableViewCell, withEvent: anObject as! Coursework)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
   

}

