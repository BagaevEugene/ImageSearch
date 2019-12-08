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
        
        override func viewDidLoad() {
            super.viewDidLoad()
            searchImage(text: "panda")
        }


        func convert(farm: Int, server: String, photoId: String, secret: String)-> URL? {
            
            let url =     URL(string:"https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_c.jpg")
            print(url)
            return url
        }
        
        
        func searchImage(text: String) {
            
                 let base = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
                 let key = "&api_key=938072888c9d1845a5096b088be070d7"
                 let format = "&format=json&nojsoncallback=1"
                 let textToSearch = "&text=\(text)"
                 let sort = "&sort=relevance"

                 let searchUrl = base + key + format + textToSearch + sort
                 
                 let url = URL(string: searchUrl)!
                 
                 URLSession.shared.dataTask(with: url) { (data, _, _) in
                     guard let jsonData = data else {
                         print("нет данных")
                         return
                     }
                     
                     guard let jsonAny = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
                         print("нет json")
                         return
                     }
            
                    guard let json = jsonAny as? [String : Any] else {
                        return
                    }
            
                    guard let photos = json["photos"] as? [String: Any] else {
                        return
                    }
                    
                    guard let photosArray = photos["photo"] as? [Any] else {
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
                    
                   
                    let farm = firstPhoto["farm"] as! Int
                    let id = firstPhoto["id"] as! String
                    let secret = firstPhoto["secret"] as! String
                    let server = firstPhoto["server"] as! String
                                                
                    let pictureURL = self.convert(farm: farm, server: server, photoId: id, secret: secret)
            
                    print(pictureURL)
                    
                  //  sleep(10)

                 /*   URLSession.shared.dataTask(with: pictureURL!, completionHandler:  { (data,_,_ ) in
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data!)
                        }
                    }).resume()
            
                 */
                    
                    
                 }.resume()
        }
}


    
    
    



 
