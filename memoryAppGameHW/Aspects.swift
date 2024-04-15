//
//  Aspects.swift
//  memoryAppGameHW
//
//  Created by Сырлыбай Рамазан on 27.02.2024.
//

import SwiftUI

struct Aspects<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio: CGFloat = 1
    var content: (Item) -> ItemView

    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = calculateGridItemSize(for: geometry.size)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(items, content: content)
                    .aspectRatio(aspectRatio, contentMode: .fit)
            }
        }
    }

    private func calculateGridItemSize(for size: CGSize) -> CGFloat {
        let count = CGFloat(items.count)
        var columnCount: CGFloat = 1.0

        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio

            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }

            columnCount += 1
        } while columnCount < count

        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}

