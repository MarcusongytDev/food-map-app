//
//  LocationsDataService.swift
//  FoodMapApp
//
//  Created by Marcus Ong on 23/6/22.
//

import Foundation
import MapKit



//func getLocationData() {
//
//    let murl = URL(string: "https://data.mongodb-api.com/app/data-xelyc/endpoint/data/v1")
//
//    guard murl != nil else {
//        print("Error creating url object")
//        return
//    }
//
//    var request = URLRequest(url: murl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
//
//    let jsonObject = [
//        "_id": "62bbf9b418fdb99580e73308",
//        "Title": "Dominos",
//        "Subtitle": "Pizza",
//        "Latitude": 1.4462692778075756,
//        "Longitude": 103.80624720281315,
//        "Description": "The international fast food pizza delivery corporation, Domino's Pizza, is a renowned and popular choice amongst people for relishing their favorite fast food, the Pizza."
//    ] as [String : Any]
//
//
//    do {
//        let requestBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
//
//        request.httpBody = requestBody
//    }
//    catch {
//        print("Error creating the data object from json")
//    }
//
//    request.httpMethod = "POST"
//
//    let session = URLSession.shared
//
//    let dataTask = session.dataTask(with: request) { (data, response, error) in
//
//        if error == nil && data != nil {
//
//            do {
//                let locationsFile = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
//                print(locationsFile)
//            }
//            catch {
//                print("Error parsing reponse data")
//            }
//        }
//    }
//    dataTask.resume()
//}




class LocationsDataService {
    
    static let locations: [Location] = [
        Location(name: "Dominos",
                 subName: "Pizza",
                 coordinates: CLLocationCoordinate2D(
                    latitude: 1.4462692778075756,
                    longitude: 103.80624720281315),
                 description: "The international fast food pizza delivery corporation, Domino's Pizza, is a renowned and popular choice amongst people for relishing their favorite fast food, the Pizza.",
                 imageNames: ["Pizza"])
    
    
    ]
    
//
//    let cache  =  NSCache<NSString, UIImage>();
//    cache.name = "Remote Image Cache"
//
//
    
}
