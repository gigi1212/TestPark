//
//  ViewController.swift
//  TestPark
//
//  Created by oliviero rossi on 26/04/17.
//  Copyright © 2017 gianluigi nero. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    var inviata = 0;
    
    @IBOutlet weak var usernameText: UITextField!

    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var confermaText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var swichtSig: UISwitch!
    
    
    @IBOutlet weak var sfondo: UIImageView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    override func viewDidLoad() {
        
        swichtSig.setOn(false, animated: true)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func showAlert(title:String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion:nil)
    }
    func send(user : String, psswd : String, mail: String) {
       let headers = [
       "content-type": "application/x-www-form-urlencoded",
       "cache-control": "no-cache"
       ]
       let us = "user=" + user
       let pass = "&password=" + psswd
       let email = "&mail=" + mail
       let postData = NSMutableData(data: us.data(using: String.Encoding.utf8)!)
       postData.append(pass.data(using: String.Encoding.utf8)!)
       postData.append(email.data(using: String.Encoding.utf8)!)
    
       var request = URLRequest(url: NSURL(string: "http://www.nicholasgiordano.it:3005/user/register")! as URL,
           cachePolicy: .useProtocolCachePolicy,
           timeoutInterval: 10.0)
           request.httpMethod = "POST"
           request.allHTTPHeaderFields = headers
           request.httpBody = postData as Data
    
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
          print(error!)
        }
        else {
            let responseString = String(data: data!, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            self.inviata = 1
        }
    })
    
    dataTask.resume()
    }
    @IBAction func invio(_ sender: UIButton) {
        var stringa = "Form non valida : \n"
        var generale = 1;
        if (usernameText.text == "") {
            generale = 0;
            stringa += "username vuoto \n"
        }
        if (passwordText.text == "") {
            generale = 0;
            stringa += "password vuota \n"
        }
        if (confermaText.text == "") {
            generale = 0;
            stringa += "conferma password vuota \n"
        }
        if (emailText.text == "") {
            generale = 0;
            stringa += "email vuota \n"
        }
        if (passwordText.text != confermaText.text) {
            generale = 0;
            stringa += "password non coincidono \n"
        }
        if (!swichtSig.isOn) {
            generale = 0
            stringa += "Accetta la legge suprema \n"
        }
        let mail = emailText.text!
        var chioc = 0
        for Character in mail.characters {
            if (Character == "@") {
                chioc = 1
                break
            }
        }
        if (chioc == 0) {
            stringa += "email non valida \n"
            generale = 0;
        }
        if (generale == 0) {
            DispatchQueue.main.async {
                self.showAlert(title: "Ops", message:stringa)

            }
        }
        else {
            DispatchQueue.main.async {
                self.showAlert(title:"Form valida", message:"Registrazione in corso")
            }
            send(user: usernameText.text!, psswd: passwordText.text!, mail: emailText.text!)
        }
        
    }
    
    
}





