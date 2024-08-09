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
        
    var banners = CurrentValueSubject<[Banner], Never>([])
    var favorites = CurrentValueSubject<[Favorite], Never>([])
    
    private var currentPage: Int = 0
    
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
                    self?.favorites.send(favorites)
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
    
    func getAllItems() {
        bannerStore.getBanners()
        favoritesStore.getFavorites(email: "julian.garcia@neoris.com")
    }
    
    func getNewItems() {
        // Add Pagination
    }
    
    func deleteItemAt(indexPath: IndexPath) {
        let itemToDelete = favorites.value[indexPath.row]
        
        favoritesStore.deleteFavorite(email: "julian.garcia@neoris.com", dessert: itemToDelete)
    }
}
