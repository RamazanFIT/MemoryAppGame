//  MemoryGameEmoji.swift
//  memoryAppGameHW
//
//  Created by Сырлыбай Рамазан on 27.02.2024.
//

import SwiftUI

class MemoryGameEmoji: ObservableObject {
    typealias Card = MainGame<String>.Card
    private static let emojis = ["🌈", "🚀", "🎈", "🌟", "🦊", "🍕", "🚲", "🌺", "📚", "🎸", "🍦", "🏖️"]


    private var model = createMemoryGame()

    @Published private(set) var cards: Array<Card>
    @Published private(set) var score: Int

    var color: Color {
        .orange
    }

    init() {
        cards = model.cards
        score = model.score
    }

    

    func shuffle() {
        model.shuffle()
        updateModel()
    }

    func choose(_ card: Card) {
        model.choose(card)
        updateModel()
    }

    private func updateModel() {
        cards = model.cards
        score = model.score
    }

    private static func createMemoryGame() -> MainGame<String> {
        return MainGame<String>(numberOfPairsOfCards: 8) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }
}

