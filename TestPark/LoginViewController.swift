//
//  LoginViewController.swift
//  TestPark
//
//  Created by oliviero rossi on 01/05/17.
//  Copyright © 2017 gianluigi nero. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var token : String?
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    func showError() {
        let alert = UIAlertController(title: "Errore", message: "Username e password non validi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion:nil)
    }

    @IBAction func chiediToken(_ sender: Any) {
        let headers = [
            "user": username.text!,
            "pswd": password.text!,
            "cache-control": "no-cache"
        ]
        
        var request = URLRequest(url: NSURL(string: "http://nicholasgiordano.it:3005/user/token")! as URL,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = String(data :data!,encoding : .utf8)
                print(httpResponse!)
                let dict = self.convertToDictionary(text: httpResponse!)
                let test : Bool = dict!["result"]! as! Bool
                if (!test) {
                    print("ciao")
                    self.showError()
                }
                else {
                    self.token = dict!["token"]! as? String
                    print(self.token!)
                }
            }
        })
        dataTask.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
