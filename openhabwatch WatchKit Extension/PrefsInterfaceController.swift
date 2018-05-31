//
//  InterfaceController.swift
//  openhabwatch WatchKit Extension
//
//  Created by Dirk Hermanns on 01.05.18.
//  Copyright © 2018 private. All rights reserved.
//

import WatchKit
import Foundation


class PrefsInterfaceController: WKInterfaceController {
    
    @IBOutlet var localUrlLabel: WKInterfaceLabel!
    @IBOutlet var remoteUrlLabel: WKInterfaceLabel!
    @IBOutlet var sitemapLabel: WKInterfaceLabel!
    @IBOutlet var usernameLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        localUrlLabel.setText(UserDefaultsRepository.readLocalUrl())
        remoteUrlLabel.setText(UserDefaultsRepository.readRemoteUrl())
        
        sitemapLabel.setText(UserDefaultsRepository.readSitemapName())
        
        usernameLabel.setText(UserDefaultsRepository.readUsername())
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
