//
//  Item.swift
//  MyToDo
//
//  Created by Anil Thomas on 12/21/21.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
  //  var parentCategory = LinkingObjects(fromType: Category.self,property: "items")
    
  //  var parentCategory = LinkingObjects(fromType: Category, property: "items")
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
