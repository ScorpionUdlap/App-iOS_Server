//
//  LoginViewController.swift
//  QRCodeReader
//
//  Created by Leonardo Moya on 11-26-19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

//
//  ViewController.swift
//  examen3_152037
//
//  Created by Leonardo Moya on 11-9-18.
//  Copyright © 2018 UDLAP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let IP_ADRESS = Constants.getIP()
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func logIn(_ sender: Any) {
        sendLoginInfo(userName: userNameField.text!, password: passwordField.text!)
    }
    func sendLoginInfo(userName: String, password: String) {
        
        let urlToSend = "http://" + IP_ADRESS + ":5000/login/"  +  userName + "/" + password
        print(urlToSend)
        let url = NSURL(string: urlToSend )
        var cookie = "error"
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            OperationQueue.main.addOperation({
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    //print(jsonObj as Any)
                    if let value = jsonObj!.value(forKey: "cookie") as? String {
                        cookie = value
                        //print(value as Any)
                        print(cookie)
                    }
                    else{
                        cookie = "error"
                    }
                }
                if cookie == "error" {
                    self.createAlert()
                }
                else{
                    UserDefaults.standard.set(cookie, forKey: "cookie")
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabController") as! UITabControll
                    self.present(nextViewController, animated: true, completion: nil)
                }
            })
        }).resume()
        print(cookie)
    }
    
    func createAlert(){
        let alert = UIAlertController(title: "Error", message: "The login credentials provided are wrong, please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


