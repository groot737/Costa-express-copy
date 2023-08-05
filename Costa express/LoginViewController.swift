//
//  LoginViewController.swift
//  Costa express
//
//  Created by giorgi on 3/20/22.
//  Copyright © 2022 Gai. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBAction func logInButton(_ sender: UIButton) {
        loader.isHidden = false
        if(emailInput.text!.count <= 0 && passwordInput.text!.count <= 0){
            loader.isHidden = true
            emailInput.layer.borderColor = UIColor(red: 255, green: 0, blue:
                0, alpha: 1).cgColor
            passwordInput.layer.borderColor = UIColor(red:255, green: 0, blue: 0, alpha: 1).cgColor
        }else if( passwordInput.text!.count <= 0){
            loader.isHidden = true
            emailInput.layer.borderColor = UIColor(red: 0.984, green: 0.588, blue: 0.114, alpha: 1).cgColor
            passwordInput.layer.borderColor = UIColor(red:255, green: 0, blue: 0, alpha: 1).cgColor
        } else if(emailInput.text!.count <= 0){
            loader.isHidden = true
            emailInput.layer.borderColor = UIColor(red: 255, green: 0, blue:
                0, alpha: 1).cgColor
            passwordInput.layer.borderColor = UIColor(red: 0.984, green: 0.588, blue: 0.114, alpha: 1).cgColor
        } else{
            Auth.auth().signIn(withEmail: emailInput.text!, password: passwordInput.text!) { (authResult, error) in
                if let error = error as NSError? {
                    switch AuthErrorCode(rawValue: error.code) {
                    case .userDisabled:
                        self.loader.isHidden = true
                        print("your account is disabled")
                        let alert = UIAlertController(title: "Log in failed", message: "your account is disabled", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    case .wrongPassword:
                        self.loader.isHidden = true
                        let alert = UIAlertController(title: "Log in failed", message: "Email or password is wrong, please enter again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        print("invalid email or password")
                    case .invalidEmail:
                        self.loader.isHidden = true
                        let alert = UIAlertController(title: "invalid email", message: "Please enter valid email", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    default:
                        self.loader.isHidden = true
                        print("Error: \(error.localizedDescription)")
                        /////////////////////////////////////////////////////
                        let alert = UIAlertController(title: "Log in failed", message: "Email or password is wrong or your account may been deleted", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        ////////////////////////////////////////////////////////
                    }
                } else {
                    print("User signs in successfully")
                    self.popupScrn()
                    self.loader.isHidden = true
                }
            }
        }
    }
    func popupScrn() {
    
        if CLLocationManager().authorizationStatus == .authorizedWhenInUse || CLLocationManager().authorizationStatus == .authorizedAlways {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "tracking") as! TrackingViewController
            present(secondVC,animated: true)
        } else {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "checkPermission") as! checkPermission
            present(secondVC,animated: true)
        }
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        loader.isHidden = true
        loader.startAnimating()
        emailInput.frame = CGRect(x: 50, y: 282, width: 312, height: 47)
        emailInput.backgroundColor = UIColor(red: 40, green: 44, blue: 52, alpha: 0)
        emailInput.layer.borderWidth = 2
        emailInput.layer.cornerRadius = 4
        emailInput.layer.borderColor = UIColor(red: 0.984, green: 0.588, blue: 0.114, alpha: 1).cgColor
        // password
        passwordInput.frame = CGRect(x: 50, y: 399, width: 312, height: 47)
        passwordInput.backgroundColor = UIColor(red: 40, green: 44, blue: 52, alpha: 0)
        passwordInput.layer.borderWidth = 2
        passwordInput.layer.cornerRadius = 4
        passwordInput.layer.borderColor = UIColor(red: 0.984, green: 0.588, blue: 0.114, alpha: 1).cgColor
        NextableDoneButtonOnKeyboard(textFields: [emailInput,passwordInput], previousNextable: false)
    }
}
extension UIViewController {
    
    func NextableDoneButtonOnKeyboard(textFields: [UITextField], previousNextable: Bool = false) {
        for (index, textField) in textFields.enumerated() {
            //Loop processing is performed for each text field.
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            toolBar.barStyle = .default
            ///Bar button item
            var items = [UIBarButtonItem]()
            
            // MARK:Front and back button settings
            
            if previousNextable {
                //When the front and back buttons are enabled
                ///Up arrow button
                let previousButton = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: nil)
                if textField == textFields.first {
                    //In the array of text fields you want to set, if it is the top text field, deactivate it.
                    previousButton.isEnabled = false
                } else {
                    //Other than the above
                    //Target the previous text field.
                    previousButton.target = textFields[index - 1]
                    //Focus on the target.
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                ///Fixed space
                let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: self, action: nil)
                fixedSpace.width = 8
                
                ///Down arrow button
                let nextButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: nil)
                if textField == textFields.last {
                    //Of the array of text fields you want to set, if it is the bottom text field, deactivate it.
                    nextButton.isEnabled = false
                } else {
                    //Other than the above
                    //Set the next text field as the target.
                    nextButton.target = textFields[index + 1]
                    //Focus on the target.
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                //Add front and back buttons to bar button items.
                items.append(contentsOf: [previousButton, fixedSpace, nextButton])
            }
            
            // MARK:Done button settings
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: view, action: #selector(UIView.endEditing))
            //Add a Done button to the bar button item.
            items.append(contentsOf: [flexSpace, doneButton])
            
            toolBar.setItems(items, animated: false)
            toolBar.sizeToFit()
            
            textField.inputAccessoryView = toolBar
        }
    }
}





