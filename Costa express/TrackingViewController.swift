//
//  TrackingViewController.swift
//  Costa express
//
//  Created by giorgi quchuloria on 8/30/22.
//  Copyright © 2022 Gai. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import CoreLocation
import CoreLocation

class TrackingViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBAction func logOut(_ sender: UIButton) {
        if start.isHidden != true {
            do {
                try Auth.auth().signOut()
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as! MainViewController
                present(secondVC,animated: true)
            } catch {
                //                print("error")
            }
        } else {
            let alert = UIAlertController(title: "log out", message: "press stop button to log out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    var locationManager: CLLocationManager?
    var latitude = 0.0
    let newUserInfo = Auth.auth().currentUser
//    let userID : String = (Auth.auth().currentUser?.uid)!
    var longitude = 0.0
    var firebaseTimer:Timer?
    let currentUid = Auth.auth().currentUser?.uid
    let manager = CLLocationManager()
    func myMethod(_:Timer) {}
    private var statusLabel: UILabel!
    var postalcode: String = ""
    
    
    override func viewDidLoad() {

        start.backgroundColor = UIColor(red: 0.145, green: 0.639, blue: 0.38, alpha: 1)
        start.setTitle("Start driving", for: UIControl.State.normal)
        start.setTitleColor(.white,
                            for: .normal)
        start.titleLabel?.font = .systemFont(ofSize: 18)
        start.layer.cornerRadius = 15
        start.layer.cornerRadius = start.frame.width / 2
        //------------------- stop -----------------------//
        stop.frame = CGRect(x: 151, y: 750, width: 112, height: 112)
        stop.backgroundColor = UIColor(red: 1, green: 0.121, blue: 0.121, alpha: 1)
        stop.setTitle("Stop driving", for: UIControl.State.normal)
        stop.setTitleColor(.white,
                           for: .normal)
        stop.titleLabel?.font = .systemFont(ofSize: 18)
        stop.layer.cornerRadius = 15
        stop.layer.cornerRadius = stop.frame.width / 2
        stop.isHidden = true
    }
    
    func getUserLocation(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.allowsBackgroundLocationUpdates = true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myLocation : CLLocation = locations[0]
        
        CLGeocoder().reverseGeocodeLocation(myLocation, completionHandler:{(placemarks, error) in
            
            if ((error) != nil)  { print("Error: \(String(describing: error))") }
            else {
                
                let p = CLPlacemark(placemark: (placemarks?[0] as CLPlacemark?)!)
                
                var subThoroughfare:String = ""
                var thoroughfare:String = ""
                var subLocality:String = ""
                var subAdministrativeArea:String = ""
                var postalCode:String = ""
                var country:String = ""
                
                
                if ((p.postalCode) != nil) {
                    postalCode = p.postalCode!
                    self.postalcode = postalCode
                    print("here is postalcode: \(postalCode)")
                }
            }   // end else no error
        }       // end CLGeocoder reverseGeocodeLocation
        )
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            if firebaseTimer == nil {
                
                firebaseTimer = Timer.scheduledTimer(withTimeInterval: 500.0, repeats: true) { timer in
                    print("longitude: \(self.longitude) and latitude \(self.latitude)")
                    Firestore.firestore().collection("users").document(self.currentUid!).updateData(["longitude": self.longitude, "latitude": self.latitude, "ZipCode": self.postalcode,"isActive": true, "speed": location.speed])
                    if location.speed <= 5 {
                        Firestore.firestore().collection("users").document(self.currentUid!).updateData(["MovementStatus": "car is stopped"])
                    } else if location.speed > 5 && location.speed <= 15 {
                        Firestore.firestore().collection("users").document(self.currentUid!).updateData(["MovementStatus": "car is in traffic"])
                    } else {
                        Firestore.firestore().collection("users").document(self.currentUid!).updateData(["MovementStatus": "car is moving"])
                    }
                    
                }
            }
        }
    }
    
    @IBAction func start(_ sender: UIButton) {
        getUserLocation()
        stop.isHidden = false
        start.isHidden = true
    }
    @IBAction func stop(_ sender: UIButton) {
        
        locationManager?.stopUpdatingLocation()
        stop.isHidden = true
        ////        logOutBtn.isHidden = false
        start.isHidden = false
        if firebaseTimer != nil{
            firebaseTimer?.invalidate()
            firebaseTimer = nil
            Firestore.firestore().collection("users").document(self.currentUid!).updateData(["longitude": self.longitude, "latitude": self.latitude, "ZipCode": self.postalcode,"isActive": false])
        }
        print("stopped")
    }
    
}
