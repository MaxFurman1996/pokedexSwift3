//
//  ViewController.swift
//  pokedex
//
//  Created by Max Furman on 5/30/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    var musicPlayer: AVAudioPlayer!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var inSearchMode = false
    
    var nextEvoId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = .done
        
        
        parsePokemonCSV()
        initAudio()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if(nextEvoId != 0){
            let poke: Pokemon!
            
            for pok in pokemons{
                if pok.pokedexId == nextEvoId{
                    poke = pok
                    performSegue(withIdentifier: "PokemonDetailsVC", sender: poke)
                    break
                }
            }
            
        }
        
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows{
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemons.append(poke)
                
            }
            
        } catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if let cell = collection.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            cell.layer.cornerRadius = 5.0
            
            let poke: Pokemon!
            
            if inSearchMode{
                poke = filteredPokemons[indexPath.row]
            } else {
                poke = pokemons[indexPath.row]
            }
            
            cell.configureCell(pokemon: poke)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredPokemons.count
        }
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let poke: Pokemon!
        
        if inSearchMode{
            poke = filteredPokemons[indexPath.row]
        } else {
            poke = pokemons[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailsVC", sender: poke)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            searchBar.endEditing(true)
            collection.reloadData()
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            filteredPokemons = pokemons.filter({$0.name.contains(lower)})
            collection.reloadData()
        }
    }
    
    @IBAction func onSoundBtnPressed(_ sender: UIButton) {
        
        if(musicPlayer.isPlaying){
            musicPlayer.stop()
            sender.alpha = 0.5
        } else {
            musicPlayer.play()
            sender.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PokemonDetailsVC" {
            if let detailsVC = segue.destination as? PokemonDetailsVC{
                detailsVC.delegate = self
                if let poke = sender as? Pokemon{
                    detailsVC.pokemon = poke
                }
            }
        }
            
    }
    
}

extension MainVC: VCTwoDelegate{
    func updateData(data: Int){
        self.nextEvoId = data
    }
}

