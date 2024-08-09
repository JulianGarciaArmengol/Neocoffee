//
//  FavoritesViewModel.swift
//  Neocoffee
//
//  Created by julian.garcia on 31/07/24.
//

import Foundation
import Combine

final class FavoritesViewModel {
    private let bannerStore: BannerStore
    private let favoritesStore: FavoritesStore
    
    let allFavorites = CurrentValueSubject<[Favorite], Never>([])
    
    var banners = CurrentValueSubject<[Banner], Never>([])
    var favorites = CurrentValueSubject<[Favorite], Never>([])
    
    private var page = CurrentValueSubject<Int, Never>(1)
    private let itemsPerPage = 8
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        BannerStore: BannerStore = BannerStore(),
        FavoritesStore: FavoritesStore = FavoritesStore()
    ) {
        self.bannerStore = BannerStore
        self.favoritesStore = FavoritesStore
        
        setupBindings()
    }
    
    func setupBindings() {
        // banners
        bannerStore.banners
            .sink {[weak self] banners in
                print("banners recived")
                self?.banners.send(banners)
            }
            .store(in: &cancellables)
        
        // favorites
        favoritesStore.favorites
            .sink {[weak self] result in
                switch result {
                case .success(let favorites):
                    self?.allFavorites.send(favorites)
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
        
        allFavorites
            .combineLatest(page)
            .sink {[weak self] (favorites, page) in
                guard let self else { return }
                
                let numberOfItems = self.itemsPerPage * page
                let count = favorites.count
                
                if count <= numberOfItems {
                    self.favorites.send(favorites)
                } else {
                    self.favorites.send(Array(favorites[0..<numberOfItems]))
                }
            }
            .store(in: &cancellables)
    }
    
    func getAllItems() {
        bannerStore.getBanners()
        favoritesStore.getFavorites(email: "julian.garcia@neoris.com")
    }
    
    func nextPage() {
        page.send(page.value + 1)
    }
    
    func deleteItemAt(indexPath: IndexPath) {
        let itemToDelete = favorites.value[indexPath.row]
        
        favoritesStore.deleteFavorite(email: "julian.garcia@neoris.com", dessert: itemToDelete)
    }
}
