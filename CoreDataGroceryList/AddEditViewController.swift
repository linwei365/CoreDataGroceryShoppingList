//
//  AddEditViewController.swift
//  CoreDataGroceryList
//
//  Created by Lin Wei on 2/1/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit
import CoreData

class AddEditViewController: UIViewController,NSFetchedResultsControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var item : Item? = nil
    let moc  =  (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var itemNote: UITextField!
    
    @IBOutlet weak var itemQuantity: UITextField!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if item != nil {
            itemName.text = item?.name
            itemNote.text = item?.note
            itemQuantity.text = item?.quantity
            imageView.image = UIImage(data: (item?.image)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
 
        if item != nil {
            editItem()
        } else {
            
            if self.imageView.image != nil {
                createNewItem()
            }
        }
        dissmissVC()
    }
    func createNewItem(){
        
        let entityDescription = NSEntityDescription.entityForName("Item", inManagedObjectContext: moc)
        let item = Item(entity: entityDescription!, insertIntoManagedObjectContext: moc)
        item.name = itemName.text
        item.note = itemNote.text
        item.quantity = itemQuantity.text
        item.image = UIImagePNGRepresentation(imageView.image!)
        do{
            try moc.save()
        }
        catch{
            
            print("failed to save")
            return
        }
        
    }
    
    func editItem(){
        item?.name = itemName.text
        item?.note = itemNote.text
        item?.quantity = itemQuantity.text
        item!.image = UIImagePNGRepresentation(imageView.image!)
        do{
            try moc.save()
        }
        catch{
            
            print("failed to save")
            return
        }
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
         dissmissVC()
    }
    
    @IBAction func pickAnImageTapped(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerController.allowsEditing = true
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func TakeAPictureTapped(sender: UIButton) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        pickerController.allowsEditing = true
        
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    func dissmissVC(){
        
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.imageView.image = image
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
