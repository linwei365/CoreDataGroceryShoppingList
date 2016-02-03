//
//  MainTableViewController.swift
//  CoreDataGroceryList
//
//  Created by Lin Wei on 2/1/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
//step #1 import CoreData 
import CoreData

//step #2 add NSFetchedResultsControllerDelegate tag
class MainTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {

    //step #3 create mangeObjectContext instance
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    //step #4 create fetchReqsultController
    var fetchResultController: NSFetchedResultsController = NSFetchedResultsController()

    //step #5 create a fetchRequest function
    func fetchRequest ()-> NSFetchRequest{
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
       
        //sort the item based on the key "name"
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        //rearrange the array with sorted result
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
        
    }
    
    //step #6 create a function grab the result from fetchResultController
    func getFectchRequestController()->NSFetchedResultsController{
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
       
        return fetchResultController
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

 
    
        self.tableView.rowHeight = 60
     
        
        //step #7 set fetchRequestController with  the getFetchResultController function
        fetchResultController = getFectchRequestController()
        //step #8 set fetchRequestController.delegate to self
        fetchResultController.delegate = self
        
        //step #9 first fetch
        
        do{
            try fetchResultController.performFetch()
        } catch {
            print("Failed to perform initial fetch")
            
            return
            
        }
        
        
       self.tableView.reloadData()
    
    }
   
   
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
         self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        do{
            try fetchResultController.performFetch()
        } catch {
            print("Failed to perform initial fetch")
            
            return
            
        }
        
        
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        let numberOfSections = fetchResultController.sections?.count
        
        return numberOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let numberOfRowsInSections = fetchResultController.sections?[section].numberOfObjects
        return numberOfRowsInSections!
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let item = fetchResultController.objectAtIndexPath(indexPath) as! Item
        
        cell.textLabel?.text = item.name
        let note = item.note
        let quantity =  item.quantity
        cell.detailTextLabel?.text = "Qty: \(quantity!) Note: \(note!)"
        cell.imageView?.image = UIImage(data: (item.image)!)
        // Configure the cell...
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let manageObject: NSManagedObject = fetchResultController.objectAtIndexPath(indexPath) as! NSManagedObject
        
        moc.deleteObject(manageObject)
        
        do {
            try moc.save()
            
        }
        catch {
            print("failed to save ")
            
            return
        }
        
       self.tableView.reloadData()
        /*
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        } 
        */
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "edit" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let itemController :AddEditViewController = segue.destinationViewController as! AddEditViewController
            let item:Item = fetchResultController.objectAtIndexPath(indexPath!) as! Item
            itemController.item = item
            
        }
        
    }
    

}
