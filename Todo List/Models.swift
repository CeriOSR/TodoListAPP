//
//  Models.swift
//  Todo List
//
//  Created by Rey Cerio on 2017-03-26.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import Foundation

struct Task {
    
    var taskId :Int?
    var title :String
}

extension Task {
    
    init(title :String) {
        self.title = title
    }
    
}
