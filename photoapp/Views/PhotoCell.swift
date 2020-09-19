//
//  PhotoCell.swift
//  photoapp
//
//  Created by USER on 16/08/2020.
//  Copyright © 2020 CJAPPS. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    
    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var dateLabel: UILabel!
    
    
    var photo:Photo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayPhoto(photo:Photo) {
        
        // Reset the image
        self.photoImageView.image = nil
        
        // Set photo property
        self.photo = photo
        
        // Set the username
        usernameLabel.text = photo.byUsername
        
        // Set the date
        dateLabel.text = photo.date
        
        // Check that there's a valid download url
        if photo.url == nil {
            return
        }
        
        // Check that image is in image cache
        if let cachedImage = ImageCacheService.getImage(url: photo.url!) {
            
            // Use the cache image
            self.photoImageView.image = cachedImage
            
            // Return because we no longer need to download the image
            return
        }
        
        // Download the image
        let url = URL(string: photo.url!)
        
        // Check that url object was created
        if url == nil {
            return
        }
        
        // Use url session to download the image asynchronously
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            // Check for errors and data
            if error == nil && data != nil {
                
                // Set the image view
                let image = UIImage(data: data!)
                
                // Store the image in cache
                ImageCacheService.saveImage(url: url!.absoluteString, image: image)
                
                // Check that the image data we downloaded matches the photo this cell is trying to display
                if url!.absoluteString != self.photo?.url! {
                    
                    
                    // The url downloaded does not match the url this cell is currently displaying
                    return
                }
                
                // Set the imageView
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            }
        }
        
        dataTask.resume()
    }

}
