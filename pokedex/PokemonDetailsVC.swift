//
//  PokemonDetailsVC.swift
//  pokedex
//
//  Created by Max Furman on 5/31/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import UIKit

class PokemonDetailsVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pokeImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var pokeIdLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var currentEboImg: UIImageView!
    @IBOutlet weak var nextEvoBtn: UIButton!
    
    var delegate: VCTwoDelegate!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name.capitalized
        pokemon.downloadPokemonDetail {
            self.updateUI()
        }
        
    }
    
    func updateUI(){
        
        pokeIdLbl.text = "\(pokemon.pokedexId)"
        descriptionLbl.text = pokemon.description
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        baseAttackLbl.text = pokemon.baseAttack
        defenseLbl.text = pokemon.defense
        typeLbl.text = pokemon.type
        pokeImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
        if pokemon.nextEvoId == ""{
            evoLbl.text = "No Evolutions"
            currentEboImg.isHidden = true
            nextEvoBtn.isHidden = true
            nextEvoBtn.isEnabled = false
        } else {
            
            if pokemon.nextEvoLvl == ""{
                evoLbl.text = "Next Evolution: \(pokemon.nextEvoName)"
            }else {
                evoLbl.text = "Next Evolution: \(pokemon.nextEvoName) - LVL \(pokemon.nextEvoLvl)"
            }
            
            currentEboImg.isHidden = false
            currentEboImg.image = UIImage(named : "\(pokemon.pokedexId)")
            nextEvoBtn.isHidden = false
            nextEvoBtn.isEnabled = true
            nextEvoBtn.setImage(UIImage(named: pokemon.nextEvoId), for: .normal)
            
        }
        
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.delegate?.updateData(data: 0)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextEvoBtnPressed(_ sender: UIButton) {
        self.delegate?.updateData(data: (self.pokemon.pokedexId+1))
        dismiss(animated: true, completion: nil)
    }

}

protocol VCTwoDelegate{
    func updateData(data: Int)
}
