//
//  CollectionViewModel.swift
//  SUICollection
//
//  Created by Yaroslav on 04.08.2023.
//

import Combine
import Foundation
import SwiftUI

protocol CellProvider: AnyObject {
    var viewModel: BaseCellViewModel? { get set }
        
    @ViewBuilder
    func view() -> AnyView
}

protocol BaseCellContent: View {
    associatedtype ViewModel
    var cellViewModel: ViewModel { get set }
    
    init(cellViewModel: ViewModel)
}

protocol AnyBaseCellViewModel: AnyObject {
    var cellProvider: any CellProvider { get set }
    
    init(cellProvider: any CellProvider)
}

class BaseCellViewModel: AnyBaseCellViewModel, Identifiable {
    
    var cellProvider: any CellProvider
    
    required init(cellProvider: any CellProvider) {
        self.cellProvider = cellProvider
        cellProvider.viewModel = self
    }
}

class GenericCellProvider<Cell: BaseCellContent, ViewModel: BaseCellViewModel>: CellProvider where ViewModel == Cell.ViewModel {
    var viewModel: BaseCellViewModel?
    
    private func getView() -> AnyView {
        if let viewModel = self.viewModel as? ViewModel {
            return AnyView(Cell(cellViewModel: viewModel))
        } else {
            assertionFailure("Can't get or cast view model")
            return AnyView(EmptyView())
        }
    }
    
    @ViewBuilder
    func view() -> AnyView {
        getView()
    }
}

class SectionViewModel: ObservableObject, Identifiable {
    @Published var title: String?
    @Published var items: [BaseCellViewModel]
    @Published var shouldShowHeader: Bool
    
    init(title: String? = nil, items: [BaseCellViewModel]) {
        self.title = title
        self.items = items
        self.shouldShowHeader = title?.isEmpty == false
    }
    
    @ViewBuilder
    func view() -> some View {
        if shouldShowHeader {
            Text(title ?? "")
                .padding(8)
        }
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(items) { item in
                    item.cellProvider.view()
                }
            }
        }
        .listRowSeparator(.hidden)
    }
}


class CollectionViewModel: ObservableObject {
    
    private var definedSections: [DefinedSections] = DefinedSections.allCases
    @Published var sections: [SectionViewModel] = []
    
    init() {
        buildSections()
    }
    
    func buildSections() {
        sections = definedSections.map { defSection in
            SectionViewModel(title: defSection.title, items: [ColorCellViewModel(),ColorCellViewModel(),ColorCellViewModel()])
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
                }
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
