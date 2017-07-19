//
//  RegistrationViewController.swift
//  DesgingApp
//
//  Created by Acquaint Mac on 25/01/17.
//  Copyright © 2017 Acquaint Mac. All rights reserved.
//

import UIKit
import CoreData
class RegistrationViewController: UIViewController,UITextFieldDelegate {
    var UserDetails: [NSManagedObject] = []
    @IBOutlet var txtUsername: MKTextField!
    @IBOutlet var txtEmail: MKTextField!
    @IBOutlet var txtPhone: MKTextField!
    @IBOutlet var txtPassword: MKTextField!
    @IBOutlet var txtConPassword: MKTextField!
    var DisplayMessage:MKSnackbar? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUsername.floatingLabelTextColor = UIColor.white
        txtUsername.bottomBorderColor = UIColor.white
        
        txtEmail.floatingLabelTextColor = UIColor.white
        txtEmail.bottomBorderColor = UIColor.white
        
        txtPhone.floatingLabelTextColor = UIColor.white
        txtPhone.bottomBorderColor = UIColor.white
        
        txtPassword.floatingLabelTextColor = UIColor.white
        txtPassword.bottomBorderColor = UIColor.white
        
        txtConPassword.floatingLabelTextColor = UIColor.white
        txtConPassword.bottomBorderColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    @IBAction func btnSubmit(_ sender: Any) {
        self.getUserDetails()
        let txtUserString = txtUsername.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let txtEmailString = txtEmail.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let txtPhoneString = txtPhone.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let txtPasswordString = txtPassword.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let txtConPasswordString = txtConPassword.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if txtUserString == ""
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter User Name", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtEmailString == ""
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter Email Id", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtEmailString?.isValidEmail() == false
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter Valid Email Id", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtPhoneString == ""
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter Phone Number", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtPhoneString?.phoneNumberValidation() == false
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter Valid Phone Number", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtPasswordString == ""
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter Password", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtConPasswordString == ""
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter Confirm Password", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtPasswordString != txtConPasswordString
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Mismatch Confirm Password and Password", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        var checkRecord = false
        for item in UserDetails
        {
            let emailString = item.value(forKeyPath: "email") as! String
            if emailString == txtEmailString
            {
                checkRecord = true;
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
            let entity = NSEntityDescription.entity(forEntityName: "User",
                                                    in: self.getContext())!
            
            let person = NSManagedObject(entity: entity,
                                         insertInto: self.getContext())
            
            person.setValue(txtUserString, forKeyPath: "name")
            person.setValue(txtEmailString, forKeyPath: "email")
            person.setValue(txtPhoneString, forKeyPath: "phone")
            person.setValue(txtPasswordString, forKeyPath: "password")
            
            do {
                try self.getContext().save()
                UserDetails.append(person)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func GoBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
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
    
    

}
