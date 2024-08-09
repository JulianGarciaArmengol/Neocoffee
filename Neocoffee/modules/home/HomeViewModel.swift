//
//  HomeViewModel.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import Foundation
import Combine

final class HomeViewModel {
    private let bannerStore: BannerStore
    private let dessertStore: DessertStore
    private let recommendedStore: RecommendedStore
    
    let allDesserts = CurrentValueSubject<[Dessert], Never>([])
    
    let banners = CurrentValueSubject<[Banner], Never>([])
    let desserts = CurrentValueSubject<[Dessert], Never>([])
    let recommended = CurrentValueSubject<[Recommended], Never>([])
    
    var selectedFeature = PassthroughSubject<Dessert, Never>()
    
    private var page = CurrentValueSubject<Int, Never>(1)
    private let itemsPerPage = 8
    
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
    
    private func setupBindings() {
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
                    self?.allDesserts.send(desserts)
                case .failure(let error):
                    print("error: " +  error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        allDesserts
            .combineLatest(page)
            .sink {[weak self] (desserts, page) in
            guard let self else { return }
            
            let numberOfItems = self.itemsPerPage * page
            let count = desserts.count
            
            if count <= numberOfItems {
                self.desserts.send(desserts)
            } else {
                self.desserts.send(Array(desserts[0..<numberOfItems]))
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
    
    func getDesserts() {
        dessertStore.getDesserts()
    }
    
    func getRecommended() {
        recommendedStore.getRecommended()
    }
    
    func nextPage() {
        page.send(page.value + 1)
    }
    
    func didSelectFeatureAt(_ indexPath: IndexPath) {
        selectedFeature.send(desserts.value[indexPath.row])
    }
}
