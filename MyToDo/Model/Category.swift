//
//  Category.swift
//  MyToDo
//
//  Created by Anil Thomas on 12/21/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
