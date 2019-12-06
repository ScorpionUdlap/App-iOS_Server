//
//  ViewController.swift
//  QRCodeReader
//
//  Created by Leonardo Moya on 11-26-19.
//  Copyright © 2019 AppCoda. All rights reserved.
//
import UIKit

class ViewController: UIViewController{
    var cookie = "test"
    let IP_ADRESS = Constants.getIP()
    
    
    func checkCookieStatus(cookie: String) {
        
        let urlToSend = "http://" + IP_ADRESS + ":5000/getUserByHash/"  +  cookie
        print(urlToSend)
        let url = NSURL(string: urlToSend )
        var loggedIn = true
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            OperationQueue.main.addOperation({
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    print(jsonObj as Any)
                    if (jsonObj!.value(forKey: "employee_id") as? String) != nil {
                        loggedIn = true
                    }
                }
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                if loggedIn {
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabController") as! UITabControll
                    self.present(nextViewController, animated: true, completion: nil)
                }
                else{
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.present(nextViewController, animated: true, completion: nil)
                }
            })
        }).resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let cookie = UserDefaults.standard.object(forKey: "cookie"){
            checkCookieStatus(cookie: cookie as! String)
        }
        else{
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(nextViewController, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
