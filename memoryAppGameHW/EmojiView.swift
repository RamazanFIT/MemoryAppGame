//  EmojiView.swift
//  memoryAppGameHW
//
//  Created by Сырлыбай Рамазан on 27.02.2024.
//

import SwiftUI

struct EmojiView: View {
    typealias Cards = MainGame<String>.Card
    @ObservedObject var viewModel: MemoryGameEmoji

    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    private let dealInterval: TimeInterval = 0.15
    private let deckWidth: CGFloat = 50

    var body: some View {
        VStack {
            cardGrid.foregroundColor(viewModel.color)
            HStack {
                score
                Spacer()
                deck.foregroundColor(viewModel.color)
                Spacer()
                shuffleButton
            }
            .font(.largeTitle)
        }
        .padding()
    }

    private var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }

    private var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation {
                viewModel.shuffle()
            }
        }
    }

    private var cardGrid: some View {
        Aspects(viewModel.cards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                dealtCardView(card)
            }
        }
    }

    @State private var dealt = Set<Cards.ID>()

    private func isDealt(_ card: Cards) -> Bool {
        dealt.contains(card.id)
    }

    private var undealtCards: [Cards] {
        viewModel.cards.filter { !isDealt($0) }
    }

    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                undealtCardView(card)
            }
            .frame(width: deckWidth, height: deckWidth/aspectRatio)
            .onTapGesture {
                deal()
            }
        }
    }

    private func dealtCardView(_ card: Cards) -> some View {
        ViewOfCard(card)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .transition(.asymmetric(insertion: .identity, removal: .identity))
            .padding(spacing)
            .overlay(FlyToNumber(number: scoreChange(causedBy: card)))
            .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
            .onTapGesture {
                choose(card)
            }
    }

    private func undealtCardView(_ card: Cards) -> some View {
        ViewOfCard(card)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .transition(.asymmetric(insertion: .identity, removal: .identity))
    }

    private func deal() {
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
    }

    private func choose(_ card: Cards) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }

    @State private var lastScoreChange = (0, causedByCardId: "")

    private func scoreChange(causedBy card: Cards) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }

    @Namespace private var dealingNamespace
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiView(viewModel: MemoryGameEmoji())
    }
}


