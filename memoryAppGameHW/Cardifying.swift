//  Cardifying.swift
//  memoryAppGameHW
//
//  Created by Сырлыбай Рамазан on 27.02.2024.
//

import SwiftUI

struct Cardifying: ViewModifier, Animatable {
    var isFaceUp: Bool {
        rotation < 90
    }
    var rotation: Double

    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }

    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }

    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .strokeBorder(lineWidth: Constants.lineWidth)
                .background(RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(.white))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)

            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(.orange)
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
    }

    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardifying(isFaceUp: isFaceUp))
    }
}
