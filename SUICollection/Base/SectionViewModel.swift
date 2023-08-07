//
//  SectionViewModel.swift
//  SUICollection
//
//  Created by Yaroslav on 05.08.2023.
//

import Foundation
import SwiftUI


protocol AnyCollectionLayout {
    func applyLayout(@ViewBuilder content: (() -> any View)) -> AnyView
}
extension AnyCollectionLayout where Self: BaseCollectionLayout {
    func applyLayout(content: (() -> any View)) -> AnyView {
        AnyView(
            self.layout(content: content)
        )
    }
}

struct CollectionLayout<Content: View>: View {
    
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        // Template UI here

        content()
    }
}


class BaseCollectionLayout: AnyCollectionLayout {
    func layout(@ViewBuilder content: (() -> any View)) -> any View {
        ScrollView(.horizontal) {
            LazyHStack {
                AnyView(content())
            }
        }
        .scrollIndicators(.hidden)
    }
}

class PromoZoneLayout: BaseCollectionLayout {
    override func layout(content: (() -> any View)) -> any View {
        ScrollView(.horizontal) {
            LazyHStack {
                AnyView(
                    content()
                        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: 300)
                )
            }
        }
        .scrollIndicators(.hidden)

    }
}

class HorizontalLayout: BaseCollectionLayout {
    override func layout(@ViewBuilder content: (() -> any View)) -> any View {
        ScrollView(.horizontal) {
            LazyHStack {
                AnyView(
                    content()
                        .frame(width: 200, height: 300)

                )
            }
        }
        .scrollIndicators(.hidden)
    }
}

class SectionViewModel: ObservableObject, Identifiable {
    @Published var title: String?
    @Published var items: [BaseCellViewModel]
    @Published var shouldShowHeader: Bool
    var layout: any AnyCollectionLayout
    init(title: String? = nil, items: [BaseCellViewModel], layout: any AnyCollectionLayout) {
        self.title = title
        self.items = items
        self.layout = layout
        self.shouldShowHeader = title?.isEmpty == false
    }
    
    @ViewBuilder
    func view() -> some View {
        if shouldShowHeader {
            Text(title ?? "")
                .padding(8)
        }
        layout.applyLayout {
            ForEach(items) { item in
                item.cellProvider.view()
            }
        }
        .listRowSeparator(.hidden)
        
//        ScrollView(.horizontal, showsIndicators: false) {
//            LazyHStack {
//            }
//        }
//        .listRowSeparator(.hidden)
    }
}
