//
//  ViewController.swift
//  DesgingApp
//
//  Created by Acquaint Mac on 24/01/17.
//  Copyright © 2017 Acquaint Mac. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth
import BlueTooth
class ViewController: UIViewController,UITextFieldDelegate,BlueToothDeviceDelegate {
    var UserDetails: [NSManagedObject] = []
    @IBOutlet var btnLogin: MKButton!
    @IBOutlet var txtpassword: MKTextField!
    @IBOutlet var txtuserName: MKTextField!
    var DisplayMessage:MKSnackbar? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        txtuserName.floatingLabelTextColor = UIColor.white
        txtuserName.bottomBorderColor = UIColor.white
        txtpassword.floatingLabelTextColor = UIColor.white
        txtpassword.bottomBorderColor = UIColor.white
        btnLogin.layer.cornerRadius = 5.0
        btnLogin.clipsToBounds = true
        self.navigationController?.isNavigationBarHidden = true
        BlueToothDevice.sharedInstance.startScaning(5.0)
        BlueToothDevice.sharedInstance.delegate = self
//        let text = AllBlueToothDevice()
//        text.startScaning(5.0)
//        text.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getAllDevice(_ periperal: Array<CBPeripheral>, _ rrsiValue: [NSNumber]) {
        print(" get all device \(periperal)")
    }

    @IBAction func btnLoginClick(_ sender: Any)
    {
        self.getUserDetails()
        let txtEmailString = txtuserName.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let txtPasswordString = txtpassword.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if txtEmailString == ""
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter Email Id", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if txtEmailString?.isValidEmail() == false
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter valid email", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            self.view.endEditing(true)
            return
        }
        if txtPasswordString == ""
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please Enter Password", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        if UserDetails.count == 0
        {
            DisplayMessage = MKSnackbar.init(withTitle: "No record found!", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            return
        }
        var emailString = ""
        var passString = ""
        var checkRecord = false
        for item in UserDetails
        {
            emailString = item.value(forKeyPath: "email") as! String
            passString = item.value(forKeyPath: "password") as! String
            
            if emailString == txtEmailString && txtPasswordString == passString
            {
                checkRecord = true;
            }
        }
        if checkRecord == true
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Login Succssfully", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        else
        {
            DisplayMessage = MKSnackbar.init(withTitle: "Please enter valid information", withDuration: 2.0, withTitleColor: UIColor.white, withActionButtonTitle: "Ok", withActionButtonColor: UIColor.white)
            DisplayMessage?.show()
        }
    }
    @IBAction func CreateNewAccontOnClick(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func ForgotPasswordOnClick(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func getUserDetails ()
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            UserDetails = try getContext().fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
