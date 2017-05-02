//
//  MainViewController.swift
//  TestPark
//
//  Created by oliviero rossi on 01/05/17.
//  Copyright © 2017 gianluigi nero. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var myToken : String = String()
    
    @IBOutlet weak var modelloAuto: UITextField!

    @IBOutlet weak var strisciaBlu: UISwitch!
    
    @IBOutlet weak var parcheggiRiservati: UISwitch!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func viewDidLoad() {
        strisciaBlu.setOn(false, animated: true)
        parcheggiRiservati.setOn(false, animated: true)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func showAlert(title:String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion:nil)
    }
    
    @IBAction func goToLogin(_ sender: Any) {
        print("vado al login");
        
        self.performSegue(withIdentifier: "Login" , sender: nil)
    }

    @IBAction func goToRegister(_ sender: Any) {
        print("Vado al register")
        
        self.performSegue(withIdentifier: "Register" , sender: nil)
    }
    
    @IBAction func aggiornaPreferenze(_ sender: Any) {
        if (modelloAuto.text?.isEmpty)! {
            showAlert(title: "Errore", message: "modello auto è obbligatorio")
            return
        }
        if (myToken.isEmpty) {
            showAlert(title: "Errore", message: "Login necessario")
            return
        }
        let headers = [
            "token": myToken,
            "content-type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache"
        ]
        let tipo = "tipo=" + modelloAuto.text!
        var pagamento = "&pagamento="
        if (strisciaBlu.isOn) {
            pagamento += "true"
        }
        else {
            pagamento += "false"
        }
        var speciale = "&speciale="
        if (strisciaBlu.isOn) {
            speciale += "true"
        }
        else {
            speciale += "false"
        }
        let postData = NSMutableData(data: tipo.data(using: String.Encoding.utf8)!)
        postData.append(pagamento.data(using: String.Encoding.utf8)!)
        postData.append(speciale.data(using: String.Encoding.utf8)!)
        
        var request = URLRequest(url: NSURL(string: "http://www.nicholasgiordano.it:3005/user/preferenze")! as URL,
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
            }
        })
        
        dataTask.resume()
        /*let headers = [
            "token": myToken,
            "content-type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache"
        ]
        let tipo = "nome=Gigi"
        let pagamento = "&cognome=bubu"
        let speciale = "&sesso=m"
        let postData = NSMutableData(data: tipo.data(using: String.Encoding.utf8)!)
        postData.append(pagamento.data(using: String.Encoding.utf8)!)
        postData.append(speciale.data(using: String.Encoding.utf8)!)
        
        var request = URLRequest(url: NSURL(string: "http://www.nicholasgiordano.it:3005/user/profilo")! as URL,
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
            }
        })
        
        dataTask.resume()*/
    }
    @IBAction func backToMainController(segue: UIStoryboardSegue) {
        print("torno indietro al Main")
        
        let myVc = segue.source as! LoginViewController
        self.myToken = myVc.token!
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
