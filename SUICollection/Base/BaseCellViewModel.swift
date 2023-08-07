//
//  BaseCellViewModel.swift
//  SUICollection
//
//  Created by Yaroslav on 05.08.2023.
//

class BaseCellViewModel: Identifiable {
    
    var cellProvider: any CellProvider
    
    init(cellProvider: any CellProvider) {
        self.cellProvider = cellProvider
        cellProvider.viewModel = self
    }
}
