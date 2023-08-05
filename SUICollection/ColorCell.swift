//
//  ColorCell.swift
//  SUICollection
//
//  Created by Yaroslav on 05.08.2023.
//

import SwiftUI

class ColorCellViewModel: BaseCellViewModel {
    var color: Color?
    var isSkeleton: Bool { color == nil }
    
    init() {
        color = nil
        super.init(cellProvider: GenericCellProvider<ColorCell, ColorCellViewModel>())
    }
    
    init(color: Color, cellProvider: any CellProvider) {
        self.color = color
        super.init(cellProvider: cellProvider)
    }
    
}

struct ColorCell<VM: ColorCellViewModel>: BaseCellContent {
    typealias ViewModel = VM
    var cellViewModel: ViewModel
    init(cellViewModel: ViewModel) {
        self.cellViewModel = cellViewModel
    }
    
    var body: some View {
        Rectangle()
            .fill(cellViewModel.color ?? .gray)
            .cornerRadius(10)
            .frame(width: 200, height: 300)
        
    }
}
