//
//  Pokemon.swift
//  pokedex
//
//  Created by Max Furman on 5/30/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import Foundation

class Pokemon{
    fileprivate var _pokedexId: Int!
    fileprivate var _name: String!
    
    var pokedexId: Int{
        return _pokedexId
    }
    
    var name: String{
        return _name
    }
    
    init(name: String, pokedexId: Int) {
        self._pokedexId = pokedexId
        self._name = name
    }
}
