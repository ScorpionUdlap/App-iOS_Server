//
//  Item.swift
//  TableComida
//
//  Created by UDLAP24 on 2/5/19.
//  Copyright © 2019 UDLAP24. All rights reserved.
//

import Foundation
//Objeto que es subclase de NsObject
class Item:NSObject
{
    var name:String
    var value:String
    var serialNumber:String
    var quantity:String
    
    //Override constructor de NSObject
    init(name1: String, value1: String, serialNumber1: String, quantity1: String)
    {
        name = name1
        value = value1
        serialNumber = serialNumber1
        quantity = quantity1
        //print(name, value, serialNumber, quantity)
        
    }//Fin constructor init
    func printThis(){
        print(name, value, serialNumber, quantity)
    }
    
}//Fin clase item

