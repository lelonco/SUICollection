//
//  CollectionViewModel.swift
//  SUICollection
//
//  Created by Yaroslav on 04.08.2023.
//

import Combine
import Foundation
import SwiftUI

class CollectionViewModel: ObservableObject {
    
    private var definedSections: [DefinedSections] = DefinedSections.allCases
    @Published var sections: [SectionViewModel] = []
    
    init() {
        buildSections()
    }
    
    func buildSections() {
        sections = definedSections.map { defSection in
            SectionViewModel(
                title: defSection.title,
                items: [ColorCellViewModel(),ColorCellViewModel(),ColorCellViewModel()],
                layout: defSection.layout
            )
        }
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] _ in
            guard let self else { return }
            removeSkeletons()
        }
    }
    
    func removeSkeletons() {
        sections = definedSections.map { defSection in
            SectionViewModel(
                title: defSection.title,
                items: defSection.items.map {
                    let cellProvider = GenericCellProvider<ColorCell, ColorCellViewModel>()
                    let viewModel = ColorCellViewModel(color: $0, cellProvider: cellProvider)
                    cellProvider.viewModel = viewModel
                    return viewModel
                },
                layout: defSection.layout
            )
        }
    }
}

private extension CollectionViewModel {
    enum DefinedSections: CaseIterable {
        case promo
        case contentGorup
        case liveContnetGroup
        case contentArea
        case promoPacket
        
        var layout: any AnyCollectionLayout {
            switch self {
            case .promo:
                return PromoZoneLayout()
            case .contentGorup:
                return HorizontalLayout()
            case .liveContnetGroup:
                return HorizontalLayout()
            case .contentArea:
                return HorizontalLayout()
            case .promoPacket:
                return HorizontalLayout()
            }
        }
        
        var title: String? {
            switch self {
            case .promo:
                return nil
            case .contentGorup:
                return "CG"
            case .liveContnetGroup:
                return "LiveCG"
            case .contentArea:
                return nil
            case .promoPacket:
                return nil
            }
        }
        var items: [Color] {
            switch self {
            case .promo:
                return [.black,.blue,.brown,.cyan,.green,.indigo]
            case .contentGorup:
                return [.black,.blue,.brown,.cyan,.green,.indigo].reversed()
            case .liveContnetGroup:
                return [.black,.blue,.brown,.cyan,.green,.indigo].reversed()
            case .contentArea:
                return [.black,.blue,.brown,.cyan,.green,.indigo]
            case .promoPacket:
                return [.red]
            }
        }
    }
}
