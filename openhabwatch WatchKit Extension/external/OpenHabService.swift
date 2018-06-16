//
//  OpenHabService.swift
//  openhabwatch WatchKit Extension
//
//  Created by Dirk Hermanns on 31.05.18.
//  Copyright © 2018 private. All rights reserved.
//

import Foundation

class OpenHabService {
    
    static let singleton = OpenHabService()
    
    /* Reads the sitemap that should be displayed on the watch */
    func readSitemap(_ resultHandler : @escaping ((Sitemap) -> Void)) {
        
        let baseUrl = UserDefaultsRepository.readActiveUrl()
        let sitemapName = UserDefaultsRepository.readSitemapName()
        if baseUrl == "" {
            return
        }
        
        // Get the current data from REST-Call
        let request = URLRequest(url: URL(string: baseUrl + "/rest/sitemaps/" + sitemapName + "?jsoncallback=callback")!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 20)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                return
            }
            guard data != nil else {
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    guard let jsonDict :NSDictionary = json as? NSDictionary else {
                        return
                    }
                    let settingsDict = jsonDict.object(forKey: "widgets") as! NSDictionary
                    if (settingsDict.count == 0) {
                        resultHandler(Sitemap.init(frames: []))
                    }
                    let frames : [Frame] = []
                    let sitemap = Sitemap.init(frames: frames)
                    //FIXME: Frames aus JSON erzeugen
                    
                    resultHandler(sitemap)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        })
        task.resume()
    }
    
    func switchOpenHabItem(itemName : String,_ resultHandler : @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        
        let url = URL(string: UserDefaultsRepository.readRemoteUrl() + "/rest/items/" + itemName)!
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(getBase64EncodedCredentials())", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let postString = "TOGGLE"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.sync {
                resultHandler(data, response, error)
            }
        }
        task.resume()
    }
    
    private func getBase64EncodedCredentials() -> String {
        let loginString = "\(UserDefaultsRepository.readUsername()):\(UserDefaultsRepository.readPassword())"
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return ""
        }
        return loginData.base64EncodedString()
    }
}
