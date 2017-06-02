//
//  Pokemon.swift
//  pokedex
//
//  Created by Max Furman on 5/30/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    private var _pokedexId: Int!
    private var _name: String!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _defense: String!
    private var _baseAttack: String!
    private var _nextEvoTxt: String!
    private var _nextEvoName: String!
    private var _nextEvoLvl: String!
    private var _nextEvoId: String!
    private var _pokeURL: String!
    
    
    var description: String{
        if _description == nil{
            return ""
        }
        return _description
    }
    
    var type: String{
        if _type == nil{
            return ""
        }
        return _type
    }
    
    var height: String{
        if _height == nil{
            return ""
        }
        return _height
    }
    var weight: String{
        if _weight == nil{
            return ""
        }
        return _weight
    }
    var defense: String{
        if _defense == nil{
            return ""
        }
        return _defense
    }
    var baseAttack: String{
        if _baseAttack == nil{
            return ""
        }
        return _baseAttack
    }
    var nextEvoTxt: String{
        if _nextEvoTxt == nil{
            return ""
        }
        return _nextEvoTxt
    }
    
    var nextEvoName: String{
        if _nextEvoName == nil{
            return ""
        }
        return _nextEvoName
    }
    
    var nextEvoLvl: String{
        if _nextEvoLvl == nil{
            return ""
        }
        return _nextEvoLvl
    }
    
    var nextEvoId: String{
        if _nextEvoId == nil{
            return ""
        }
        return _nextEvoId
    }
    
    
    var pokedexId: Int{
        return _pokedexId
    }
    
    var name: String{
        return _name
    }
    
    init(name: String, pokedexId: Int) {
        self._pokedexId = pokedexId
        self._name = name
        self._pokeURL = "\(URL_BASE)\(URL_POKEMON)/\(pokedexId)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete){
        
        Alamofire.request(_pokeURL, method: HTTPMethod.get).responseJSON{ response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String,AnyObject>{
                
                if let attack = dict["attack"] as? Int{
                    self._baseAttack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                
                if let height = dict["height"] as? String{
                    self._height = height
                }
                
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                
                if let types = dict["types"] as? [Dictionary<String,AnyObject>], types.count > 0{
                    
                    var firstType = true
                    var typeText = ""
                    
                    for type in types{
                        if let name = type["name"] as? String{
                            if firstType{
                                typeText.append(name.capitalized)
                                firstType = false
                            } else {
                                typeText.append("/\(name.capitalized)")
                            }
                        }
                        self._type = typeText
                    }
                    
                } else {
                    self._type = "-"
                }
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String,AnyObject>], descriptions.count > 0{
                    
                    if let url = descriptions[0]["resource_uri"]{
                        let descURL = "\(URL_BASE)\(url)"
                        Alamofire.request(descURL, method: HTTPMethod.get).responseJSON{ response in
                            let result = response.result
                            if let dict = result.value as? Dictionary<String,AnyObject>{
                                if let desc = dict["description"] as? String{
                                    let desc0 = desc.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = desc0
                                }
                            }
                            completed()
                        }
                        
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>], evolutions.count > 0{
                    if let nextEvo = evolutions[0]["to"] as? String{
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvoName = nextEvo
                            
                            
                            if let level = evolutions[0]["level"] as? Int{
                                self._nextEvoLvl = "\(level)"
                            } else {
                                self._nextEvoLvl = ""
                            }
                            
                            if let uri = evolutions[0]["resource_uri"] as? String{
                                var newStrId = uri.replacingOccurrences(of: URL_POKEMON, with: "")
                                newStrId = newStrId.replacingOccurrences(of: "/", with: "")
                                self._nextEvoId = newStrId
                            }
                        } else {
                            self._nextEvoName = ""
                            self._nextEvoLvl = ""
                            self._nextEvoId = ""
                        }
                    }
                }
                
            }
            
            completed()
            
        }
    }
}
