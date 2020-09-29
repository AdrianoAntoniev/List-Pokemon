//
//  ViewController.swift
//  List-Pokemon!
//
//  Created by Adriano Rodrigues Vieira on 29/09/20.
//  Copyright © 2020 Adriano Rodrigues Vieira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var pokemonsNameAndUrl: [PokemonNameAndUrl] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let url = URL(string: Constants.POKEMON_API) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                
                let decoder = JSONDecoder()
                let allData = try! decoder.decode(ContentData.self, from: data)
                
                if let pokemonsNameAndUrlArrayJSON = allData.results {
                    for pokemonNameAndURLJSON in pokemonsNameAndUrlArrayJSON {
                        if let pokemonName = pokemonNameAndURLJSON["name"],
                                let pokemonUrl = pokemonNameAndURLJSON["url"] {
                            let pokemon = PokemonNameAndUrl(name: pokemonName.replacingOccurrences(of: "-", with: " ").capitalized,
                                                            url: pokemonUrl)
                            
                            self.pokemonsNameAndUrl.append(pokemon)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonsNameAndUrl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel?.text = pokemonsNameAndUrl[indexPath.row].name
        
        return cell!
    }
    
}
