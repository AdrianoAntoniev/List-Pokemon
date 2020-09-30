//
//  DetailsViewController.swift
//  List-Pokemon!
//
//  Created by Adriano Rodrigues Vieira on 29/09/20.
//  Copyright © 2020 Adriano Rodrigues Vieira. All rights reserved.
//

import UIKit
import TagListView

class DetailsViewController: UIViewController {
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    
    var pokemonUrl: String?
    var pokemonName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTagListView()
        
        if let name = pokemonName, let url = pokemonUrl {
            pokemonNameLabel.text = name
            
            if let safeUrl = URL(string: url) {
                let task = URLSession.shared.dataTask(with: safeUrl) { (data, response, error) in
                    guard let data = data else { return }
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let pokeDecoded = try! decoder.decode(PokemonDetailsData.self, from: data)
                                        
                    DispatchQueue.main.async {
                        if let safeFrontUrlImageString = pokeDecoded.sprites.other.officialArtwork.frontDefault {
                            if let safeUrlOfPokemonImage = URL(string: safeFrontUrlImageString) {
                                self.pokemonImage.loadImage(withUrl: safeUrlOfPokemonImage)
                                
                            }
                        } else {
                            self.pokemonImage.loadDefaultImage()
                        }
                        
                        for pokeType in pokeDecoded.types {
                            self.tagListView.addTag(pokeType.type.name!.capitalized)
                        }
                        
                        self.heightLabel.text = "Altura: \(pokeDecoded.height)"
                        self.weightLabel.text = "Peso: \(pokeDecoded.weight)"
                    }
                }
                
                task.resume()
            }
        }
    }

    private func configureTagListView() {
        tagListView.tintColor = .yellow
        tagListView.cornerRadius = 10
        tagListView.textFont = UIFont(name: Constants.FONT_NAME, size: CGFloat(Constants.FONT_SIZE))!
    }
}

extension UIImageView {
    func loadImage(withUrl url: URL, ifNeedConvertImageToThisSize size: CGSize? = nil) {
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func loadDefaultImage() {
        DispatchQueue.main.async {
            self.image = UIImage(named: Constants.BLANK_IMAGE_NAME)
        }
    }
}
