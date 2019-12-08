//
//  ViewController.swift
//  ImageSearch
//
//  Created by Eugene Bagaev on 08.12.2019.
//  Copyright © 2019 Eugene Bagaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
        
    @IBOutlet weak var TextField: UITextField!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            TextField.delegate = self
            searchImage(text: "cstrike")
        }


        func convert(farm: Int, server: String, photoId: String, secret: String)-> URL? {
            
            let    url =     URL(string:"https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_c.jpg")
            return url
        }
        
        
        func searchImage(text: String) {
            
                 let base         = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
                 let key          = "&api_key=da8153d16f20f5083e774f69183000e6"
                 let format       = "&format=json&nojsoncallback=1"
                 let textToSearch = "&text=\(text)"
                 let sort         = "&sort=relevance"

                 let searchUrl = base + key + format + textToSearch + sort
                 
                 let url = URL(string: searchUrl)!
                 
                 URLSession.shared.dataTask(with: url) { (data, _, _) in
                     guard let jsonData = data else {
                         print("No data")
                         return
                     }
                     
                     guard let jsonAny = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
                         print("Data's format no json")
                         return
                     }
            
                    guard let json = jsonAny as? [String : Any] else {
                        print("Wrong json format")
                        return
                    }
            
                    guard let photos = json["photos"] as? [String: Any] else {
                        print("No photos title")
                        return
                    }
                    
                    guard let photosArray = photos["photo"] as? [Any] else {
                        print("Photos absent")
                        return
                    }
                    
                    guard photosArray.count > 0 else {
                        print("no photo")
                        return
                    }
                    
                    guard let firstPhoto = photosArray[0] as? [String:Any] else {
                        print("no first photo")
                        return
                    }
                    
                   
                    let farm   = firstPhoto["farm"] as! Int
                    let id     = firstPhoto["id"] as! String
                    let secret = firstPhoto["secret"] as! String
                    let server = firstPhoto["server"] as! String
                                                
                    let pictureURL = self.convert(farm: farm, server: server, photoId: id, secret: secret)
            
      
                   URLSession.shared.dataTask(with: pictureURL!, completionHandler:  { (data,_,_ ) in
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data!)
                        }
                    }).resume()
                    
                 }.resume()
        }
}


extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchImage(text: TextField.text!)
        
        return true
    }
}
    
    



 
