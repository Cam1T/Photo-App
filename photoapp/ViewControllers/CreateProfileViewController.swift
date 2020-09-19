//
//  CreateProfileViewController.swift
//  photoapp
//
//  Created by USER on 08/08/2020.
//  Copyright © 2020 CJAPPS. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateProfileViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
 
    @IBAction func confirmTapped(_ sender: Any) {
        
        // Check that a user is logged in
        guard Auth.auth().currentUser != nil else {
            // No user logged in
            return
        }
        
        // Get the username
        // Check it against whitespaces, new lines, illegal characters etc
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check that the username isn't nil
        if username == nil || username == "" {
            // Show an error message
            return
        }
        
        // Call the user service to create the profile
        UserService.createProfile(userId: Auth.auth().currentUser!.uid, username: username!) { (user) in
            
            // Check if it was created successfully
            if user != nil {
             // if so, Go to the bar controller
                
                // Save the user to local storage
                LocalStorageService.saveUser(userId: user!.userId, username: user!.username)
    
                let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController)
                
                self.view.window?.rootViewController = tabBarVC
                self.view.window?.makeKeyAndVisible()
            }
            else {
                // If not , display error
            }
                
        }
        
        
    }
    
}
