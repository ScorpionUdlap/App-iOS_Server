//
//  DetailViewController.swift
//  TableComida
//
//  Created by UDLAP24 on 2/7/19.
//  Copyright © 2019 UDLAP24. All rights reserved.
//

import UIKit

class DetailViewController2: UIViewController, UITextFieldDelegate{
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
            let temp = Model2.filter(filter: self.name.text!)[0]
            Model2.removeItem(temp)
            Model2.addItem(Item(name1: self.name.text!,value1: self.val.text! ,serialNumber1: self.serie.text!,quantity1: self.quantity.text!))
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            
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
            let temp = Model2.filter(filter: self.name.text!)[0]
            Model2.removeItem(temp)
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
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

