//
//  ContentView.swift
//  SUICollection
//
//  Created by Yaroslav on 04.08.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = CollectionViewModel()

    var body: some SwiftUI.View {
        List {
            ForEach(viewModel.sections) { section in
                section.view()
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
