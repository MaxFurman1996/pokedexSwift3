//
//  PokeCell.swift
//  pokedex
//
//  Created by Max Furman on 5/30/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {

    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        layer.cornerRadius = 5.0
//    }
    
    func configureCell(pokemon : Pokemon){
        self.thumbImg.image = UIImage(named: "\(pokemon.pokedexId)")
        self.nameLbl.text = pokemon.name.capitalized
    }
    
    
}
