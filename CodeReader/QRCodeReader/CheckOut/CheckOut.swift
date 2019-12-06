//
//  CheckOut.swift
//  QRCodeReader
//
//  Created by Leonardo Moya on 11-28-19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class CheckOut: UIViewController {
    let IP_ADRESS = Constants.getIP()
    
    @IBAction func checkOut(_ sender: Any) {
        var bigAssString = ""
        for item in Model2.items{
            bigAssString += item.serialNumber + "_" + item.quantity + ":"
        }
        print(bigAssString)
        let user = UserDefaults.standard.object(forKey: "employee_id") as! String
        let urlToSend = "http://" + self.IP_ADRESS + ":5000/createOrder/" + bigAssString + "/" + user
        let url = NSURL(string: urlToSend)
        print(url as Any)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            OperationQueue.main.addOperation({
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    print(jsonObj as Any)
                    if let total = jsonObj!.value(forKey: "total") as? String{
                        self.createAlert(total: total)
                    }
                }
            })
        }).resume()
    }
    
    func createAlert(total: String){
        let alert = UIAlertController(title: "Total Due is", message: total + "$", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Bye", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cookie = UserDefaults.standard.object(forKey: "cookie") as! String
        let urlToSend = "http://" + self.IP_ADRESS + ":5000/getUserByHash/" + cookie
        let url = NSURL(string: urlToSend)
        print(url as Any)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            OperationQueue.main.addOperation({
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    if let emp = jsonObj!.value(forKey: "employee_id") {
                        UserDefaults.standard.set(String(describing: emp), forKey: "employee_id")
                        print(UserDefaults.standard.object(forKey: "employee_id") as! String)
                    }
                }
            })
        }).resume()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
