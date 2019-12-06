//
//  DetailViewController.swift
//  TableComida
//
//  Created by UDLAP24 on 2/7/19.
//  Copyright © 2019 UDLAP24. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate{
    let IP_ADRESS = Constants.getIP()
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var serie: UITextField!
    @IBOutlet weak var val: UITextField!
    @IBOutlet weak var quantity: UITextField!
    
    @IBAction func update(_ sender: Any) {
        var alertController:UIAlertController
        var cancelAction:UIAlertAction
        var deleteAction:UIAlertAction
        
        alertController = UIAlertController(title: "Are you sure?", message: "Do you want to update " + name.text! + "?", preferredStyle: UIAlertControllerStyle.alert)
        
        cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:nil)
        alertController.addAction(cancelAction)
        
        //Handler recive una funcion anonima que recive como parametro action (lo recibe el handler .:.hay que declararlo) y que regresa void
        deleteAction = UIAlertAction(title: "Update", style: UIAlertActionStyle.destructive, handler: {
            (action) -> Void
            in
            //Remover elemento del model(estructura de datos)
            let urlToSend = "http://" + self.IP_ADRESS + ":5000/update/"  +  self.serie.text! + "/" + self.name.text! + "/" + self.val.text! + "/" + self.quantity.text!
            print(urlToSend)
            let url = NSURL(string: urlToSend.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            //print(url as Any)
            URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                OperationQueue.main.addOperation({
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                        print(jsonObj as Any)
                        if (jsonObj!.value(forKey: "status") as? String) != nil {
                            self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            }).resume()
        })
        //Añadir al alert controller
        alertController.addAction(deleteAction)
        
        //Presentar el alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func deleteThis(_ sender: Any) {
        var alertController:UIAlertController
        var cancelAction:UIAlertAction
        var deleteAction:UIAlertAction
        
        alertController = UIAlertController(title: "Are you sure?", message: "Do you want to delete " + name.text! + "?", preferredStyle: UIAlertControllerStyle.alert)
        
        cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:nil)
        alertController.addAction(cancelAction)
        
        //Handler recive una funcion anonima que recive como parametro action (lo recibe el handler .:.hay que declararlo) y que regresa void
        deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {
            (action) -> Void
            in
            //Remover elemento del model(estructura de datos)
            let urlToSend = "http://" + self.IP_ADRESS + ":5000/delete/"  +  self.serie.text!
            print(urlToSend)
            let url = NSURL(string: urlToSend )
            URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                OperationQueue.main.addOperation({
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                        //print(jsonObj as Any)
                        if (jsonObj!.value(forKey: "status") as? String) != nil {
                            self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            }).resume()
        })
        //Añadir al alert controller
        alertController.addAction(deleteAction)
        
        //Presentar el alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    var item: Item!{
        didSet{
            navigationItem.title = item.name
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        name.text = item.name
        serie.text = item.serialNumber
        val.text = item.value
        quantity.text = item.quantity
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        
        
    }
    
    func textFieldShouldReturn(_ textField : UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
