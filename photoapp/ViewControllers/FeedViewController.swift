//
//  FeedViewController.swift
//  photoapp
//
//  Created by USER on 08/08/2020.
//  Copyright © 2020 CJAPPS. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    
    @IBOutlet var tableView: UITableView!
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set the view controller as the datasource and delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        // Add pull to refresh
        addRefreshControl()
        
        
        // Call the photo service to retrieve the photos
        PhotoService.retrievePhotos { (retrievedPhotos) in
            
            // Set our photos array to the retrieved photos
            self.photos = retrievedPhotos
            
            // Tell the table view to reload
            self.tableView.reloadData()
        }

    }
    
    func addRefreshControl() {
        
        //  Create refresh Control
        let refresh = UIRefreshControl()
        
        // Set target
        refresh.addTarget(self, action: #selector(refreshFeed(refreshControl:)), for: .valueChanged)
        
        // Add to tableview
        
        self.tableView.addSubview(refresh)
    }
    
    @objc func refreshFeed(refreshControl: UIRefreshControl) {
        
        // Call the photo service
        PhotoService.retrievePhotos { (newPhotos) in
            
            // Assign new photos to our photos property
            self.photos = newPhotos
            
            DispatchQueue.main.async {
                
                // Refresh TableView
                self.tableView.reloadData()
                
                // Stop the spinner
                refreshControl.endRefreshing()
            }
            
        }
        
    }

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a photo cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.photoCellId, for: indexPath) as? PhotoCell
        
        // Get the photo this cell is displaying
        let photo = self.photos[indexPath.row]
        
        // Call display photo method of the cell
        cell?.displayPhoto(photo: photo)
        
       // Return the cell
        return cell!
    }
    
    
}
