//
//  RecoverViewController.swift
//  Costa express
//
//  Created by giorgi on 3/21/22.
//  Copyright © 2022 Gai. All rights reserved.
//

import UIKit
import Firebase

class RecoverViewController: UIViewController {
    
    @IBOutlet weak var recoverInput: UITextField!
    @IBAction func recoverButton(_ sender: Any) {
        let email = recoverInput.text
        if(recoverInput.text!.count <= 0){
            recoverInput.layer.borderColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1).cgColor
        } else{
            Auth.auth().sendPasswordReset(withEmail: recoverInput.text!) { (error) in
                if let error = error as NSError? {
                    switch AuthErrorCode(rawValue: error.code) {
                    case .userNotFound:
                        
                        let alert = UIAlertController(title: "Email not found", message: "Email is not registered, plese enter again or register.", preferredStyle: .alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        
                    case .invalidEmail:
                        let alert = UIAlertController(title: "Invalid email", message: "Please enter email again", preferredStyle: .alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        print("invalid email")
                    case .invalidRecipientEmail:
                        
                        let alert = UIAlertController(title: "We went wrong", message: "We are sorry we went wrong, please try again later", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    case .invalidMessagePayload:
                        
                        let alert = UIAlertController(title: "We went wrong", message: "We are sorry we went wrong, please try again later", preferredStyle: .alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        
                    default: print("Error message: \(error.localizedDescription)")
                    }
                } else {
                    let alert = UIAlertController(title: "Success", message: "Recovery link successfuly sent", preferredStyle: .alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recoverInput.layer.frame = CGRect(x: 51, y: 424, width: 312, height: 50)
        recoverInput.backgroundColor = UIColor(red: 40, green: 44, blue: 52, alpha: 0)
        recoverInput.layer.borderWidth = 2
        recoverInput.layer.cornerRadius = 4
        recoverInput.layer.borderColor = UIColor(red: 0.984, green: 0.588, blue: 0.114, alpha: 1).cgColor
        recoverInput.font = .systemFont(ofSize: 20)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
