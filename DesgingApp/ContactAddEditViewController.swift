//
//  ContactAddEditViewController.swift
//  DesgingApp
//
//  Created by Acquaint Mac on 25/01/17.
//  Copyright © 2017 Acquaint Mac. All rights reserved.
//

import UIKit
import CoreData
import ALCameraViewController
import TOCropViewController
class ContactAddEditViewController: UIViewController,UITextFieldDelegate,TOCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var UserDetails: [NSManagedObject] = []
    @IBOutlet var txtFirstName: MKTextField!
    @IBOutlet var txtEmail: MKTextField!
    @IBOutlet var txtPhone: MKTextField!
    @IBOutlet var txtLastName: MKTextField!
    @IBOutlet var btnImage: UIButton!
    @IBOutlet var navigationBar: UINavigationBar!
    var DisplayMessage:MKSnackbar? = nil
    var ContactPhotoData:Data? = nil
    var PariCularRecord:NSManagedObject!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFirstName.floatingLabelTextColor = UIColor.white
        txtFirstName.bottomBorderColor = UIColor.white
        
        txtEmail.floatingLabelTextColor = UIColor.white
        txtEmail.bottomBorderColor = UIColor.white
        
        txtPhone.floatingLabelTextColor = UIColor.white
        txtPhone.bottomBorderColor = UIColor.white
        
        txtLastName.floatingLabelTextColor = UIColor.white
        txtLastName.bottomBorderColor = UIColor.white
        navigationBar.topItem?.title = "Contact Add"
        if PariCularRecord != nil
        {
            navigationBar.topItem?.title = "Contact Edit"
            txtFirstName.text = PariCularRecord.value(forKeyPath: "firstname") as? String
            txtLastName.text = PariCularRecord.value(forKeyPath: "lastname") as? String
            txtEmail.text = PariCularRecord.value(forKeyPath: "email") as? String
            txtPhone.text = PariCularRecord.value(forKeyPath: "phone") as? String
            ContactPhotoData = PariCularRecord.value(forKeyPath: "photo") as? Data
            if ContactPhotoData != nil
            {
                let image = UIImage.init(data: ContactPhotoData!)
                btnImage.setImage(image, for: .normal)
                btnImage.setImage(image, for: .highlighted)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnUserImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.isEditing = false
        
        let actionSheet =  UIAlertController(title: "Select Profile Photo", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.default){ (libSelected) in
            print("library selected")
            
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        actionSheet.addAction(libButton)
        let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.default) { (camSelected) in
            
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                actionSheet.dismiss(animated: false, completion: nil)
                let alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (alertAction) in
                    
                    alert.dismiss(animated: true, completion: nil)
                }))
                
            }
            
        }
        actionSheet.addAction(cameraButton)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (cancelSelected) in
            
            print("cancel selected")
            
        }
        actionSheet.addAction(cancelButton)
        let albumButton = UIAlertAction(title: "Saved Album", style: UIAlertActionStyle.default) { (albumSelected) in
            
            print("Album selected")
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        actionSheet.addAction(albumButton)
        self.present(actionSheet, animated: true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        dismiss(animated: true, completion: nil)
        if let PickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            let controller = TOCropViewController.init(image: PickedImage)
            controller.delegate = self
            let navigation =  UINavigationController.init(rootViewController: controller)
            self.present(navigation, animated: true, completion: nil)
        }
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        ContactPhotoData = UIImagePNGRepresentation(image)
        self.btnImage.setImage(image, for: .normal)
        self.btnImage.setImage(image, for: .highlighted)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSubmit(_ sender: Any) {
        self.getUserDetails()
        let txtFirstNameString = txtFirstName.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let txtEmailString = txtEmail.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let txtPhoneString = txtPhone.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let txtLastNameString = txtLastName.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if txtFirstNameString == ""
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter first Name", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtLastNameString == ""
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter last name", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtEmailString == ""
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter email", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtEmailString?.isValidEmail() == false
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter valid email", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtPhoneString == ""
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter Phone", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtPhoneString?.phoneNumberValidation() == false
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter valid Phone", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        var checkRecord = false
        for item in UserDetails
        {
            let emailString = item.value(forKeyPath: "email") as! String
            if emailString == txtEmailString
            {
                if PariCularRecord != nil {
                    if PariCularRecord.objectID != item.objectID {
                        checkRecord = true
                    }
                }
                else
                {
                    checkRecord = true;
                }
            }
        }
        if checkRecord == true
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Duplicate Email Id", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        else
        {
            
            if PariCularRecord == nil
            {
                let entity = NSEntityDescription.entity(forEntityName: "Contact",
                                                        in: self.getContext())!
                
                let person = NSManagedObject(entity: entity,
                                             insertInto: self.getContext())
                
                person.setValue(txtFirstNameString, forKeyPath: "firstname")
                person.setValue(txtLastNameString, forKeyPath: "lastname")
                person.setValue(txtPhoneString, forKeyPath: "phone")
                person.setValue(txtEmailString, forKeyPath: "email")
                person.setValue(ContactPhotoData, forKeyPath: "photo")
                do {
                    try self.getContext().save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            else
            {
                PariCularRecord.setValue(txtFirstNameString, forKeyPath: "firstname")
                PariCularRecord.setValue(txtLastNameString, forKeyPath: "lastname")
                PariCularRecord.setValue(txtPhoneString, forKeyPath: "phone")
                PariCularRecord.setValue(txtEmailString, forKeyPath: "email")
                PariCularRecord.setValue(ContactPhotoData, forKeyPath: "photo")
                self.SaveContext()
            }
            self.perform(#selector(self.goBack), with: nil, afterDelay: 1.5)
        }
    }
    
    func goBack ()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
        return appDelegate.persistentContainer.viewContext
    }
    
    func SaveContext () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getUserDetails ()
    {
        UserDetails.removeAll()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        do {
            UserDetails = try getContext().fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GoBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
