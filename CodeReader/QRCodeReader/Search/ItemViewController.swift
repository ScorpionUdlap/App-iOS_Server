//
//  ItemsViewController.swift
//  TableComida
//
//  Created by UDLAP24 on 2/5/19.
//  Copyright © 2019 UDLAP24. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        filteredItems = Model.filter(filter: searchController.searchBar.text!.lowercased())
        tableView.reloadData()
    }
    
    let IP_ADRESS = Constants.getIP()
    var filteredItems = [Item]()
    func getProducts() {
        let urlToSend = "http://" + IP_ADRESS + ":5000/getProducts/"
        print(urlToSend)
        let url = NSURL(string: urlToSend )
        var number = 0
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            OperationQueue.main.addOperation({
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    //print(jsonObj as Any)
                    if let num = jsonObj!.value(forKey: "number") as? Int {
                        number = num
                    }
                    if number != 0{
                        if let dict = jsonObj!.value(forKey: "data") as? NSDictionary {
                            for (_, val) in dict{
                                var name = ""
                                var value = ""
                                var serialNumber = ""
                                var quantity = ""
                                //print(val as Any)
                                if let it = val as? NSDictionary {
                                    if let id = it.value(forKey: "id") as? String {
                                        serialNumber = id
                                    }
                                    if let name1 = it.value(forKey: "name") as? String {
                                        name = name1
                                    }
                                    if let value1 = it.value(forKey: "price") as? String {
                                        value = value1
                                    }
                                    if let quantity1 = it.value(forKey: "quantity") as? String {
                                        quantity = quantity1
                                    }
                                }
                                self.addItem(name: name, value: value, serialNumber: serialNumber, quantity: quantity)
                            }
                        }
                    }

                }
            })
        }).resume()
    }
    
    
    
    
    let searchController = UISearchController(searchResultsController: nil)
    

    func addItem(name: String, value: String, serialNumber: String, quantity: String) {
        var newItem: Item
        var indexPath : IndexPath
        
        //Using the Model create a new Item and add it
        newItem = Item(name1: name, value1: value, serialNumber1: serialNumber, quantity1: quantity)
        Model.addItem(newItem)
        
        //Updating the View
        //Figure out where that item is in the array
        if let index = Model.items.index(of:newItem)
        {
            indexPath = IndexPath(row: index, section: 0)
            //Inser this new row into the table view, with animation
            //Al heredar de la clase UITableViewController por defecto ya hay un tableView
            tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
        }//Fin if
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(displayP3Red: 0.220, green: 0.337, blue: 0.359, alpha: 1.0)
        
        
        initializeView()
    }
    
    private func initializeView()
    {
        //Determinar altura de los renglones automaticamente
        tableView.rowHeight = UITableViewAutomaticDimension
        //Estimado de 65 puntos de altura para renglones del table view
        tableView.estimatedRowHeight = 65
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        //Construir boton izquierdo de Edit
        //navigationItem.leftBarButtonItem = editButtonItem
        
    }//Fin constructor
    
    //Funciones necesrias por los protocolos
    
    //Cada vez que aparezca esta pantalla
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        //Hacer reload de los datos
        searchController.dismiss(animated: false)
        searchController.isActive = false
        getProducts()
        Model.delete_all()
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
                let item = Model.items[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item

                
            }//Fin if
            
        default:
            if let row = tableView.indexPathForSelectedRow?.row
            {
                //Get the item associated with this row and pass it along
                let item = Model.items[row]
                let detailViewController = segue.destination as! DetailViewController
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredItems.count
        }
        return Model.items.count
    }//Funcion table view
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : ItemCell
        var item : Item
        
        //self.tableView.register(ItemCell.self, forCellReuseIdentifier: "incel")

        //Create an isntance of UITableViewCell with default appereance
        cell = tableView.dequeueReusableCell(withIdentifier: "incel", for: indexPath) as! ItemCell
        //Set the text on the cell with the description of the item that is at the nth index where n = row this cell will appear in on the tableView
        if searchController.isActive && searchController.searchBar.text != "" {
            item = self.filteredItems[indexPath.row]
        } else {
            item = Model.items[indexPath.row]
        }

        cell.nombre.text = item.name
        
        
        cell.noserie.text = item.serialNumber
        cell.val.text = "$\(item.value)"
        
        return cell
        
    }
    
    /*override func numberOfSections(in tableView: UITableView) -> Int {
     return 1
     }*/
    
    
}//Fin clase ItemsViewController

