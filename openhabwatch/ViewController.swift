//
//  ViewController.swift
//  openhabwatch
//
//  Created by Dirk Hermanns on 01.05.18.
//  Copyright © 2018 private. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var localUrl: UITextField!
    @IBOutlet weak var remoteUrl: UITextField!
    @IBOutlet weak var sitemapName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayTheApplicationVersionNumber()
        
        username.text = UserDefaultsRepository.readUsername()
        username.setBottomBorder(withColor: UIColor.lightGray)
        password.text = UserDefaultsRepository.readPassword()
        password.setBottomBorder(withColor: UIColor.lightGray)
        
        localUrl.text = UserDefaultsRepository.readLocalUrl()
        localUrl.setBottomBorder(withColor: UIColor.lightGray)
        remoteUrl.text = UserDefaultsRepository.readRemoteUrl()
        remoteUrl.setBottomBorder(withColor: UIColor.lightGray)
        
        sitemapName.text = UserDefaultsRepository.readSitemapName()
        sitemapName.setBottomBorder(withColor: UIColor.lightGray)
    }

    func displayTheApplicationVersionNumber() {
        
        let versionNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        
        version.text = "V\(versionNumber).\(buildNumber)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendAllValuesToWatch() {
        WatchService.singleton.sendToWatch(
            localUrl.text != nil ? localUrl.text! : "",
            remoteUrl: remoteUrl.text != nil ? remoteUrl.text! : "",
            username: username.text != nil ? username.text! : "",
            password: password.text != nil ? password.text! : "",
            sitemapName: sitemapName.text != nil ? sitemapName.text! : "")
    }
    
    // intercept editing events
    
    @IBAction func doUsernameEditingChanged(_ sender: Any) {
        UserDefaultsRepository.saveUsername(username.text!)
        sendAllValuesToWatch()
    }
    
    @IBAction func doPasswordEditingChanged(_ sender: Any) {
        UserDefaultsRepository.savePassword(password.text!)
        sendAllValuesToWatch()
    }
    
    @IBAction func doLocalUrlEditingChanged(_ sender: Any) {
        UserDefaultsRepository.saveLocalUrl(localUrl.text!)
        sendAllValuesToWatch()
    }
    
    @IBAction func doRemoteUrlEditingChanged(_ sender: Any) {
        UserDefaultsRepository.saveRemoteUrl(remoteUrl.text!)
        sendAllValuesToWatch()
    }
    
    @IBAction func doSitemapNameEditingChanged(_ sender: Any) {
        UserDefaultsRepository.saveSitemapName(sitemapName.text!)
        sendAllValuesToWatch()
    }
    
}

