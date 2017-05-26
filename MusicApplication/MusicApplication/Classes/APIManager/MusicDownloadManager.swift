//
//  MusicDownloadManager.swift
//  MusicApplication
//
//  Created by Sidramappa Halake on 24/05/17.
//  Copyright © 2017 Sidramappa Halake. All rights reserved.
//

import UIKit

typealias musicResponseHandler = (_ responseData: [Any]?,_ error: Error?) -> ()
typealias imageResponseHandler = (_ image: UIImage?,_ error: Error?) -> ()


class MusicDownloadManager: NSObject {
    
    static let sharedInstance = MusicDownloadManager()
    
    //Make default initiliazer to fileprivate so that we can avoid creating another instance of MusicDownloadManager
    fileprivate override init() {
        
    }
    
    func downloadData(form API: String, completionHandler: @escaping musicResponseHandler) {
        
        // Set up the URL request
        guard let url = URL(string: API) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            // make sure we got data
            guard let responseData = data else {
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let responseDictionary = try JSONSerialization.jsonObject(with: responseData, options: []) as? [AnyHashable: Any] else {
                    //print("error trying to convert data to JSON")
                    return
                }
                // now we have the todo, let's just print it to prove we can access it
                let results = responseDictionary["results"] as? [Any]
                
                DispatchQueue.main.async {
                    completionHandler(results, nil)
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()
    }
    
    func downlodImage(from url: String, completionHandler: @escaping imageResponseHandler) {
        
        // Set up the URL request
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {return}
            
            if let data = data{
                let image = UIImage.init(data: data)
                DispatchQueue.main.async {
                    completionHandler(image, nil)
                }
            }
        }
        task.resume()
    }
}

