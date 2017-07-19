//
//  String+Validation.swift
//  WeatherMonitor
//
//  Created by sanjeet on 11/16/16.
//  Copyright © 2016 sanjeet. All rights reserved.
//

import Foundation
import UIKit
extension String {
    
    public func TrimString() -> String {
        
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
    
    public func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: self.TrimString())
        
        return result
    }
    public func phoneNumberValidation() -> Bool {
        
        let charcterSet = NSCharacterSet(charactersIn: "+0123456789").inverted
        
        let inputString = self.components(separatedBy: charcterSet)
        
        let filtered = inputString.joined(separator: "")
        
        return self == filtered
    }
    public func isPasswordSame(password:String,confirmPassword:String) -> Bool {
        
        if password == confirmPassword{
            
            return true
        }else{
            return false
        }
    }
    
    public func isPwdLenth(password:String,confirmPassword:String) -> Bool {
        
        if password.characters.count <= 7 && confirmPassword.characters.count <= 7{
            
            return true
        }else{
            return false
        }
    }
}
extension NSAttributedString {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}

extension UIViewController{

    func hideKeyboardWhenTappedAround(){
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard(){
         view.endEditing(true)
    }
    func showAlertMessage(message:String,title:String) -> Void {
        
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    /******************** custom  Pop up method ***********************************/
    
    
    
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UINavigationController {
    func pop(animated: Bool) {
        _ = self.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        _ = self.popToRootViewController(animated: animated)
    }
}


