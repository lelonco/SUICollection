//
//  CellProvider.swift
//  SUICollection
//
//  Created by Yaroslav on 05.08.2023.
//

import SwiftUI

protocol CellProvider: AnyObject {
    var viewModel: BaseCellViewModel? { get set }
        
    @ViewBuilder
    func view() -> AnyView
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
