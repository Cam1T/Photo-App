//
//  CameraViewController.swift
//  photoapp
//
//  Created by USER on 08/08/2020.
//  Copyright © 2020 CJAPPS. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet var progressLabel: UILabel!
    
    @IBOutlet var progressBar: UIProgressView!
    
    @IBOutlet var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Hide and recept all elements
        progressBar.alpha = 0
        progressBar.progress = 0
        
        doneButton.alpha = 0
        
        progressLabel.alpha = 0
    }
    
    func savePhoto(image:UIImage) {
        
        // Call the photo service to store the photo
        PhotoService.savePhoto(image: image) { (pct) in
            
            DispatchQueue.main.async {
                
                // Update the progress bar
                self.progressBar.alpha = 1
                self.progressBar.progress = Float(pct)
                
                // Update the label
                let roundedPct = Int(pct * 10)
                self.progressLabel.text = "\(roundedPct) %"
                self.progressLabel.alpha = 1
                
                // Check if its done
                if pct == 10 {
                    
                    self.progressLabel.text = "Upload Completed!"
                    self.doneButton.alpha = 1
                }
            }
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        // Get a reference tpo the tab bar controller
        let tabBarVC = self.tabBarController as? MainTabBarController
        
        if let tabBarVC = tabBarVC {
            
            // Call go to feed
            tabBarVC.goToFeed()
        }
    }
    
}
