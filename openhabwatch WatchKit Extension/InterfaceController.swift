//
//  InterfaceController.swift
//  openhabwatch WatchKit Extension
//
//  Created by Dirk Hermanns on 01.05.18.
//  Copyright © 2018 private. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var haustuerButton: WKInterfaceButton!
    @IBOutlet var garageButton: WKInterfaceButton!
    @IBOutlet var garagentuerButton: WKInterfaceButton!
    @IBOutlet var kuechenButton: WKInterfaceButton!
    
    @IBOutlet var activityImage: WKInterfaceImage!
    
    var darkGray = UIColor(red:0.13, green:0.13, blue:0.14, alpha:1.0)
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        activityImage.setImageNamed("Activity")
        activityImage.setHidden(true)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func doButtonPressedHaustuer() {
        toggleButtonColor(button: self.haustuerButton)
        switchOpenHabItem(itemName: "KeyMatic_Open")
    }
    
    @IBAction func doButtonPressedGarage() {
        toggleButtonColor(button: self.garageButton)
        switchOpenHabItem(itemName: "Garagentor_Taster")
    }
    
    @IBAction func doButtonPressedGaragentuer() {
        toggleButtonColor(button: self.garagentuerButton)
        switchOpenHabItem(itemName: "KeyMatic_Garage_State")
    }

    @IBAction func doButtonPressedKuechenlampe() {
        toggleButtonColor(button: self.kuechenButton)
        switchOpenHabItem(itemName: "Licht_EG_Kueche")
    }
    
    private func toggleButtonColor(button : WKInterfaceButton) {
        button.setBackgroundColor(UIColor.darkGray)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(250)) {
            button.setBackgroundColor(self.darkGray)
        }
    }
    
    private func switchOpenHabItem(itemName : String) {
        
        displayActivityImage()
        
        let url = URL(string: "http://pi3:8080/rest/items/" + itemName)!
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "TOGGLE"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.sync {
                self.hideActivityImage()
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    self.displayAlert(message: "error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    let message = "statusCode should be 200, but is \(httpStatus.statusCode)\n" +
                                    "response = \(String(describing: response))"
                    self.displayAlert(message: message)
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
        }
        task.resume()
    }
    
    private func displayAlert(message : String) {
        let okAction = WKAlertAction.init(title: "Ok", style:.default) {
            print("ok action")
        }
        
        presentAlert(withTitle: "Fehler", message: message, preferredStyle:.actionSheet, actions: [okAction])
    }
    
    private func displayActivityImage() {
        activityImage.setHidden(false)
        activityImage.startAnimatingWithImages(in: NSRange(1...15), duration: 1.0, repeatCount: 0)
    }
    
    private func hideActivityImage() {
        activityImage.setHidden(true);
        activityImage.stopAnimating();
    }
}
