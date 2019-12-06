//
//  Model.swift
//
//  Created by Leonardo Moya on 2-5-19.
//  Copyright © 2019 UDLAP. All rights reserved.
//

import Foundation

class Model{
    
    static var items: Array<Item> = []
    
    static func addItem(_ item: Item){
        items.append(item)
    }
    
    static func delete_all(){
        items = []
    }
    
    static func filter(filter: String) -> Array<Item> {
        var search: Array<Item> = []
        for item in items{
            if item.name.lowercased().contains(filter){
                search.append(item)
            }
        }
        return search
    }
}
