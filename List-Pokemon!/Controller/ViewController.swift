//
//  ViewController.swift
//  List-Pokemon!
//
//  Created by Adriano Rodrigues Vieira on 29/09/20.
//  Copyright © 2020 Adriano Rodrigues Vieira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var pokemonsNameAndUrl: [PokemonNameAndUrl] = []
    var filteredPokemons: [PokemonNameAndUrl] = []
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defineDelegatesAndDependencies()
        populateTableView()
    }
    
    private func defineDelegatesAndDependencies() {
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.SEARCH_BAR_PLACEHOLDER
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func populateTableView() {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.DETAILS_SEGUE_NAME {
            if let detailsViewController = segue.destination as? DetailsViewController {
                if let pokemon = sender as? PokemonNameAndUrl {
                    detailsViewController.pokemonUrl = pokemon.url
                    detailsViewController.pokemonName = pokemon.name
                }
            }
        }
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        filteredPokemons = pokemonsNameAndUrl.filter { (pokemon: PokemonNameAndUrl) -> Bool in
            return pokemon.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredPokemons.count : pokemonsNameAndUrl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if isFiltering {
            cell?.textLabel?.text = filteredPokemons[indexPath.row].name
        } else {
            cell?.textLabel?.text = pokemonsNameAndUrl[indexPath.row].name
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemonToDetail: PokemonNameAndUrl = isFiltering ? filteredPokemons[indexPath.row] : pokemonsNameAndUrl[indexPath.row]
        
        performSegue(withIdentifier: Constants.DETAILS_SEGUE_NAME, sender: pokemonToDetail)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
