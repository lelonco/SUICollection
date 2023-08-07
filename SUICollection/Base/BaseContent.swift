//
//  BaseContent.swift
//  SUICollection
//
//  Created by Yaroslav on 05.08.2023.
//

import SwiftUI

protocol BaseCellContent: View {
    associatedtype ViewModel
    var cellViewModel: ViewModel { get set }
    
    init(cellViewModel: ViewModel)
}
