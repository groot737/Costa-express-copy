//
//  RegisterViewController.swift
//  Costa express
//
//  Created by giorgi on 3/19/22.
//  Copyright © 2022 Gai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBAction func registerButton(_ sender: UIButton) {
        
        //longitude
        var longitude = 0.0
        //latitude
        var latitude = 0.0
        //first name
        let firstName = firstNameInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //last name
        let lastName = lastNameInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // phone number
        let phoneNumber = phoneNumberInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //email
        let email = emailInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //let password
        let password = passwordInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // postal code
        let postalcode = ""
        
        //this checks if input are empty or firstame and lastname weak!!!
        if(firstNameInput.text!.count <= 0 || phoneNumberInput.text!.count <= 0 || lastNameInput.text!.count <= 0 || emailInput.text!.count <= 0 || passwordInput.text!.count <= 0){
            let alert = UIAlertController(title: "Attention", message: "Please fill every input", preferredStyle: .alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else if (firstNameInput.text!.count < 3 || firstNameInput.text!.count > 25 ) || (lastNameInput.text!.count < 3 || lastNameInput.text!.count > 25){
            
            let alert = UIAlertController(title: "Attention", message: "firstname or last name must be minimum 3 character and maximum 25 character long", preferredStyle: .alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!) { authResult, error in
                if let error = error as NSError? {
                    switch AuthErrorCode(rawValue: error.code) {
                    case .operationNotAllowed:
                        let alert = UIAlertController(title: "We went wrong", message: "We are sorry we went wrong, please try again later", preferredStyle: .alert)
                        
                    case .emailAlreadyInUse:
                        let alert = UIAlertController(title: "Emali already in use", message: "Emali already in use, please use another email.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        print("already in use")
                    case .invalidEmail:
                        
                        let alert = UIAlertController(title: "Invalid email", message: "Email is invalid, please enter again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    case .emailAlreadyInUse:
                        let alert = UIAlertController(title: "Email already in use", message: "Email is already registered please use another email", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case .weakPassword:
                        let alert = UIAlertController(title: "Weak password", message: "Password length must be min 6 characters long", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    default:
                        print("Error: \(error.localizedDescription)")
                    }
                } else {
                    print("User signs up successfully")
                    let newUserInfo = Auth.auth().currentUser
                    let currentUid = Auth.auth().currentUser?.uid
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    Firestore.firestore().collection("users").document(currentUid!).setData(["email": self.emailInput.text,"firstname": self.firstNameInput.text, "lastname": self.lastNameInput.text, "latitude": latitude, "ZipCode": postalcode, "longitude": longitude, "phoneNumber": self.phoneNumberInput.text, "uid": currentUid, "speed": 0, "MovementStatus":"","isActive": false])
                    
                    self.popupScrn()
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
            secondVC.modalPresentationStyle = .fullScreen
            present(secondVC,animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //first name
        firstNameInput.frame = CGRect(x: 50, y: 96, width: 312, height: 47)
        firstNameInput.backgroundColor = UIColor(red: 40, green: 44, blue: 52, alpha: 0)
        firstNameInput.layer.borderWidth = 2
        firstNameInput.layer.cornerRadius = 4
        firstNameInput.layer.borderColor = UIColor(red: 0.984, green: 0.588, blue: 0.114, alpha: 1).cgColor
        
        //last name
        lastNameInput.frame = CGRect(x: 50, y: 200, width: 312, height: 47)
        lastNameInput.backgroundColor = UIColor(red: 40, green: 44, blue: 52, alpha: 0)
        lastNameInput.layer.borderWidth = 2
        lastNameInput.layer.cornerRadius = 4
        lastNameInput.layer.borderColor = UIColor(red: 0.984, green: 0.588, blue: 0.114, alpha: 1).cgColor
        
        //phone number
        phoneNumberInput.frame = CGRect(x: 50, y: 312, width: 312, height: 47)
        phoneNumberInput.backgroundColor = UIColor(red: 40, green: 44, blue: 52, alpha: 0)
        phoneNumberInput.layer.borderWidth = 2
        phoneNumberInput.layer.cornerRadius = 4
        phoneNumberInput.layer.borderColor = UIColor(red: 0.984, green: 0.588, blue: 0.114, alpha: 1).cgColor
        
        //email input
        emailInput.frame = CGRect(x: 50, y: 537, width: 314, height: 47)
        emailInput.backgroundColor = UIColor(red: 40, green: 44, blue: 52, alpha: 0)
        emailInput.layer.borderWidth = 2
        emailInput.layer.cornerRadius = 4
        emailInput.layer.borderColor = UIColor(red: 0.984, green: 0.588, blue: 0.114, alpha: 1).cgColor
        
        //password input
        passwordInput.frame = CGRect(x: 50, y: 425, width: 312, height: 47)
        passwordInput.backgroundColor = UIColor(red: 40, green: 44, blue: 52, alpha: 0)
        passwordInput.layer.borderWidth = 2
        passwordInput.layer.cornerRadius = 4
        passwordInput.layer.borderColor = UIColor(red: 0.984, green: 0.588, blue: 0.114, alpha: 1).cgColor
        
        PreviousNextableDoneButtonOnKeyboard(textFields: [firstNameInput,lastNameInput,phoneNumberInput,emailInput,passwordInput], previousNextable: false)
        
    }
}
extension UIViewController {
    
    func PreviousNextableDoneButtonOnKeyboard(textFields: [UITextField], previousNextable: Bool = false) {
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
