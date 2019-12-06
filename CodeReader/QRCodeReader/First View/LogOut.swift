//
//  LogOut.swift
//  QRCodeReader
//
//  Created by Leonardo Moya on 11-27-19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class LogOut: UIViewController{
    
    @IBAction func logOut(_ sender: Any) {
        createAlert()
    }
    func createAlert(){
        let alert = UIAlertController(title: "Are you sure?", message: "Log Out", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) -> Void
            in
            UserDefaults.standard.removeObject(forKey: "cookie")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(nextViewController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
