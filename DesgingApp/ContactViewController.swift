//
//  ContactViewController.swift
//  DesgingApp
//
//  Created by Acquaint Mac on 25/01/17.
//  Copyright © 2017 Acquaint Mac. All rights reserved.
//

import UIKit
import CoreData
class ContactViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var btnAddNew: MKButton!
    @IBOutlet var tlbContact: UITableView!
    @IBOutlet var lblNoRecord: UILabel!
    var UserDetails: [NSManagedObject] = []
    override func viewDidLoad()
    {
        lblNoRecord.isHidden = true
        super.viewDidLoad()
        tlbContact.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.getUserDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getUserDetails()
    }

    @IBAction func btnAddnewContact(_ sender: Any)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ContactAddEditViewController") as! ContactAddEditViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ContactAddEditViewController") as! ContactAddEditViewController
        nextViewController.PariCularRecord = UserDetails[indexPath.row];
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        for item in cell.contentView.subviews
        {
            item.removeFromSuperview()
        }
        let contact = UserDetails[indexPath.row]
        
        let username = (contact.value(forKeyPath: "firstname") as! String).appending(" ").appending(contact.value(forKeyPath: "lastname") as! String)
        let email = (contact.value(forKeyPath: "email") as! String)
        let phone = (contact.value(forKeyPath: "phone") as! String)
        let ImageData = contact.value(forKeyPath: "photo") as? Data
        
        var currentX:CGFloat = 10
        if ImageData != nil
        {
            let ImageView = UIImageView()
            ImageView.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            ImageView.image = UIImage.init(data: ImageData!)
            cell.contentView.addSubview(ImageView)
            currentX = 55
        }
        
        
        let lableName = UILabel()
        lableName.frame = CGRect(x: currentX, y: 10, width: self.view.frame.size.width-150, height: 30)
        lableName.text = username
        cell.contentView.addSubview(lableName)
        
        let lableEmail = UILabel()
        lableEmail.frame = CGRect(x: currentX, y: 45, width: self.view.frame.size.width-150, height: 30)
        lableEmail.text = email
        cell.contentView.addSubview(lableEmail)
        
        let lablePhone = UILabel()
        lablePhone.frame = CGRect(x: self.view.frame.size.width-145, y: 10, width: 140, height: 30)
        lablePhone.text = phone
        cell.contentView.addSubview(lablePhone)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == .delete)
        {
            self.getContext().delete(UserDetails[indexPath.row])
            self.SaveContext()
            UserDetails.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if UserDetails.count == 0
            {
                lblNoRecord.isHidden = false
            }
            else
            {
                lblNoRecord.isHidden = true
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDetails.count
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func SaveContext () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
        return appDelegate.persistentContainer.viewContext
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
        if UserDetails.count == 0
        {
            lblNoRecord.isHidden = false
        }
        else
        {
            lblNoRecord.isHidden = true
        }
        tlbContact.reloadData()
    }
    
    @IBAction func GoBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddNewContact(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ContactAddEditViewController") as! ContactAddEditViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
