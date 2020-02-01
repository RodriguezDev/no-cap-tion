//
//  Network.swift
//  NoCaption
//
//  Created by Chris Rodriguez on 2/1/20.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation

let baseUrl = "http://192.168.1.195:3313/twitter/api/"

func postRequest(url: String, params: Dictionary<String, String>, closure: @escaping (_ json: Dictionary<String, AnyObject>) -> ()) {
    
    var request = URLRequest(url: URL(string: url)!)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
        if (error != nil) {
            print(error!)
            return
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
            print(json)
            closure(json)
        } catch {
            print("Error parsing JSON.")
        }
    })

    task.resume()
}

func getRequest(url: String, closure: @escaping (_ json: Dictionary<String, AnyObject>) -> ()) {
    
    var request = URLRequest(url: URL(string: url)!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
        if (error != nil) {
            print(error!)
            return
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
            print(json)
            closure(json)
            
        } catch {
            print("Error parsing JSON.")
        }
    })

    task.resume()
}
