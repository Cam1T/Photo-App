//
//  PhotoService.swift
//  photoapp
//
//  Created by USER on 12/08/2020.
//  Copyright © 2020 CJAPPS. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class PhotoService {
    
    static func retrievePhotos(completion: @escaping ([Photo]) -> Void) {
        
        // Get a database reference
        let db = Firestore.firestore()
        
        // Get all the documents from the photo collection
        db.collection("photoss").getDocuments { (snapshot, error) in
            
            // Check for errors
            if error != nil {
                
                // Error in retrieving photos
                return
            }
            
            // Get all the documents
            let documents = snapshot?.documents
            
            // Check that documents arennt nil
            if let documents = documents {
                
                // Create an array to hold all of our photo structs
                var photoArray = [Photo]()
                
                // Loop through the documents, create photo struct for each
                for doc in documents {
                    
                    // Create photo struct
                    let p = Photo(snapshot: doc)
                    
                    if p != nil {
                        // Store in our array
                        photoArray.insert(p!, at: 0)
                    }
                }
                
                // Parse back photo array
                completion(photoArray)
            }
            
        }
        
        
    }
    
    static func savePhoto(image:UIImage, progressUpdate: @escaping (Double) -> Void ) {
        
        // Check that there's a user logged in
        if Auth.auth().currentUser == nil {
            return
        }
        
        // Get the data representation of the UIImage
        let photoData = image.jpegData(compressionQuality: 0.1)
        
        guard photoData != nil else {
            // Error, couldn't get data from the UIImage
            return
        }
        
        // Create a file name
        let filename = UUID().uuidString
        
        // Get the user id of the current user
        let userId = Auth.auth().currentUser!.uid
        
        // Create a firebase storage path/referencer
        let ref = Storage.storage().reference().child("image/\(userId)/\(filename).jpg")
        
        // Upload the data
        let uploadTask = ref.putData(photoData!, metadata: nil) { (metadata, error) in
            
            
            // Check if upload was succuessful
            if error == nil {
                // Upon successful upload, create the database entry
                self.createDatabaseEntry(ref: ref)
            }
        }
        
        uploadTask.observe(.progress) { (taskSnapshot) in
            
            let pct = Double(taskSnapshot.progress!.completedUnitCount) / Double(taskSnapshot.progress!.totalUnitCount) * 10
            
            print(pct)
            
            progressUpdate(pct)
        }
    }
    
    private static func createDatabaseEntry(ref: StorageReference) {
        
        // Download url
        ref.downloadURL { (url, error) in
            
            // If theres no error then proceed
            if error == nil {
                
                // Photo Id
                let photoId = ref.fullPath
                
                // Get the current user
                let photoUser = LocalStorageService.loadUser()
                
                // User id
                let userId = photoUser?.userId
                
                // Username
                let username = photoUser?.username
                
                // Date
                let df = DateFormatter()
                df.dateStyle = .full
                
                let dateString = df.string(from: Date())
                
                // Create a dictionairy of the photo metadata
                let metadata = ["photoId":photoId, "byId":userId!, "byUsername":username!, "date":dateString, "url":url!.absoluteString]
                
                // Save the metadata to the firestore database
                let db = Firestore.firestore()
                
                db.collection("photoss").addDocument(data: metadata) { (error) in
                    
                    // Check if the saving of data was succussful
                    if error == nil {
                        // Successfully created database entry for the photo
                    }
                }
            }
            
        }
    }
}
