//
//  CheckPermisscionViewController.swift
//  Costa express
//
//  Created by giorgi quchuloria on 8/27/22.
//  Copyright © 2022 Gai. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class checkPermission: UIViewController, CLLocationManagerDelegate {
    
    let locationService = LocationService()
    
    @IBAction func button(_ sender: UIButton) {
        initializeLocationServices()
        if CLLocationManager().authorizationStatus == .denied {
            let alert = UIAlertController(title: "Location access is needed to get your current location", message: "Please allow location access", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { [weak self] _ in
                self?.locationServicesNeededState()
            })

            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    private func initializeLocationServices() {
           locationService.delegate = self
           
           let isEnabled = locationService.enabled
           
           guard isEnabled else {
               locationServicesNeededState()
               return
           }
           
           // start
           locationService.requestAuthorization()
       }
}
extension checkPermission: LocationServiceDelegate {
    func authorizationUknown() {
        locationServicesNeededState()
    }
    
    func authorizationRestricted() {
        locationServicesRestrictedState()
    }
    
    func promptAuthorizationAction() {
        promptForAuthorization()
    }
    
    func didAuthorize() {
//        locationService.start()
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "tracking") as! TrackingViewController
        secondVC.modalPresentationStyle = .fullScreen
        self.present(secondVC,animated: true)
    }
}

extension checkPermission {
    func promptForAuthorization() {
        let alert = UIAlertController(title: "Location access is needed to get your current location", message: "Please allow location access", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { [weak self] _ in
            self?.locationServicesNeededState()
        })

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
              
        alert.preferredAction = settingsAction

        present(alert, animated: true, completion: nil)
    }
    
    func locationServicesNeededState() {
//        self.statusLabel.text = "Access to location services is needed."
    }
    
    func locationServicesRestrictedState() {
//        statusLabel.text = "The app is restricted from using the location services."
    }
}


