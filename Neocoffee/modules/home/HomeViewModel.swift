//
//  HomeViewModel.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import Foundation
import Combine

final class HomeViewModel {
//    private let dataStore: DataStore
    private let bannerStore: BannerStore
    private let dessertStore: DessertStore
    private let recommendedStore: RecommendedStore
    
    var banners = CurrentValueSubject<[Banner], Never>([])
    var desserts = CurrentValueSubject<[Dessert], Never>([])
    var recommended = CurrentValueSubject<[Recommended], Never>([])
    
    var selectedFeature = PassthroughSubject<Dessert, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        bannerStore: BannerStore = BannerStore(),
        dessertStore: DessertStore = DessertStore(),
        recommendedStore: RecommendedStore = RecommendedStore()
    ) {
        self.bannerStore = bannerStore
        self.dessertStore = dessertStore
        self.recommendedStore = recommendedStore
        
        setupBindings()
    }
    
    func setupBindings() {
        bannerStore.banners
            .sink {[weak self] banners in
                self?.banners.send(banners)
            }
            .store(in: &cancellables)
        
        dessertStore.desserts
            .sink {[weak self] result in
                switch result {
                case .success(let desserts):
                    // TODO: paginate desserts!
                    self?.desserts.send(desserts)
                case .failure(let error):
                    print("error: " +  error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        recommendedStore.recommended
            .sink {[weak self] recommended in
                self?.recommended.send(recommended)
            }
            .store(in: &cancellables)
    }
    
    func getAllData() {
        // get banners
        getBanners()
        
        // get desserts
        getDesserts()
        
        // get recomended
        getRecommended()
        
    }
    
    func getBanners() {
        bannerStore.getBanners()
    }
    
    func getDesserts(page: Int = 0) {
        dessertStore.getDesserts()
    }
    
    func getRecommended() {
        recommendedStore.getRecommended()
    }
    
    func didSelectFeatureAt(_ indexPath: IndexPath) {
        selectedFeature.send(desserts.value[indexPath.row])
    }
}
