//
//  SettingsViewController.swift
//  photoapp
//
//  Created by USER on 08/08/2020.
//  Copyright © 2020 CJAPPS. All rights reserved.
//

import UIKit
import FirebaseAuth
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOutTapped(_ sender: Any) {
    
        do {
            
            // Try to sign out the user
            try Auth.auth().signOut()
            
            // Clear local storage
            LocalStorageService.clearUser()
            
            // Transition to authentication flow
            let loginNavVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginNavController)
            
            self.view.window?.rootViewController = loginNavVC
            self.view.window?.makeKeyAndVisible()
        }
        catch {
            // Couldn't sign out the user
        }
    }
}
