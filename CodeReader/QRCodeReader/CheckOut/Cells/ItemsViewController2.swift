//
//  ItemsViewController.swift
//  TableComida
//
//  Created by UDLAP24 on 2/5/19.
//  Copyright © 2019 UDLAP24. All rights reserved.
//

import UIKit

class ItemsViewController2: UITableViewController{
    /*
    func getProducts() {
        for item in Model2.items{
            self.addItem(item: item)
        }
    }
    func addItem(item: Item) {
        var indexPath : IndexPath
        
        //Using the Model create a new Item and add it
        
        //Updating the View
        //Figure out where that item is in the array
        if let index = Model2.items.index(of:item)
        {
            indexPath = IndexPath(row: index, section: 0)
            item.printThis()
            //Inser this new row into the table view, with animation
            //Al heredar de la clase UITableViewController por defecto ya hay un tableView
            tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
        }//Fin if
    }
    */
    
    @objc func backAction(){
        //print("Back Button Clicked")
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backAction))
        initializeView()
    }
    
    private func initializeView()
    {
        //Determinar altura de los renglones automaticamente
        tableView.rowHeight = UITableViewAutomaticDimension
        //Estimado de 65 puntos de altura para renglones del table view
        tableView.estimatedRowHeight = 65
    }
    /*
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        //Construir boton izquierdo de Edit
        //navigationItem.leftBarButtonItem = editButtonItem
        
    }//Fin constructor
    */
    
    //Funciones necesrias por los protocolos
    
    //Cada vez que aparezca esta pantalla
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        //Hacer reload de los datos
        //getProducts()  ///?
        tableView.reloadData()
    }//End view willAppear
    
    //Prepares notifica al viewController que un segue esta apunto de suceder
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        //If the triggered segue is the "showItem" segue
        switch segue.identifier
        {
        //Identificador del segue
        case "showItem"?:
            //Figure out wich row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row
            {
                //Get the item associated with this row and pass it along
                let item = Model2.items[row]
                let detailViewController = segue.destination as! DetailViewController2
                detailViewController.item = item
                
                
            }//Fin if
            
        default:
            if let row = tableView.indexPathForSelectedRow?.row
            {
                //Get the item associated with this row and pass it along
                let item = Model2.items[row]
                let detailViewController = segue.destination as! DetailViewController2
                detailViewController.item = item
            }//Fin if
            
            
        }//Fin switch
        
    }//Fin funcion prepare
    
    
    /*
     override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
     {
     Model.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
     }//Finn funcion table view
     
     //Tipo de edicion que se quiere tener (en este caso solo un delete)
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     
     var item:Item
     var title:String
     var alertController:UIAlertController
     var cancelAction:UIAlertAction
     var deleteAction:UIAlertAction
     
     //If the table view is asked to commit a delete command...
     if editingStyle == UITableViewCellEditingStyle.delete
     {
     item = Model.items[indexPath.row]
     title = "Delete\(item.name)?"
     //Preferd style = forma en que sale el mensaje
     alertController = UIAlertController(title: title, message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
     
     cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:nil)
     alertController.addAction(cancelAction)
     
     //Handler recive una funcion anonima que recive como parametro action (lo recibe el handler .:.hay que declararlo) y que regresa void
     deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {
     (action) -> Void
     in
     //Remover elemento del model(estructura de datos)
     Model.removeItem(item)
     //Also remove that row from the table view with an animation
     self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
     })
     //Añadir al alert controller
     alertController.addAction(deleteAction)
     
     //Presentar el alert controller
     present(alertController, animated: true, completion: nil)
     
     }//Fin if
     }//Fin editingstyle
     */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Numero de elementos en la estructura de datos
        return Model2.items.count
    }//Funcion table view
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : ItemCell2
        var item : Item
        
        //self.tableView.register(ItemCell.self, forCellReuseIdentifier: "incel")
        
        //Create an isntance of UITableViewCell with default appereance
        cell = tableView.dequeueReusableCell(withIdentifier: "incel2", for: indexPath) as! ItemCell2
        //Set the text on the cell with the description of the item that is at the nth index where n = row this cell will appear in on the tableView
        item = Model2.items[indexPath.row]

        
        cell.nombre.text = item.name
        
        
        cell.noserie.text = item.quantity
        cell.val.text = "$\(item.value)"
        
        return cell
        
    }
    
    /*override func numberOfSections(in tableView: UITableView) -> Int {
     return 1
     }*/
    
    
}//Fin clase ItemsViewController


