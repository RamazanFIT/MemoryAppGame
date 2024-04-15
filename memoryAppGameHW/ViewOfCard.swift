//  ViewOfCard.swift
//  memoryAppGameHW
//
//  Created by Сырлыбай Рамазан on 27.02.2024.
//

import SwiftUI
typealias Card = MainGame<String>.Card
struct ViewOfCard: View {
    typealias Card = MainGame<String>.Card
    let card: Card
    
    init(_ card: MainGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            if card.isFaceUp || !card.isMatched {
                Piece(endAngle: .degrees(card.bonusPercentRemaining * 360))
                    .opacity(Constants.Piece.opacity)
                    .overlay(cardContents.padding(Constants.Piece.inset))
                    .padding(Constants.inset)
                    .cardify(isFaceUp: card.isFaceUp)
                    .transition(.scale)
            } else {
                Color.clear
            }
        }
    }
    
    var cardContents: some View {
        Text(card.content)
            .font(.system(size: Constants.FontSize.largest))
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            .multilineTextAlignment(.center)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(.spin(duration: 1), value: card.isMatched)
    }
    
    private struct Constants {
        static let inset: CGFloat = 5
        
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
        
        struct Piece {
            static let opacity: CGFloat = 0.4
            static let inset: CGFloat = 5
        }
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .linear(duration: 1).repeatForever(autoreverses: false)
    }
}

#Preview {
    VStack {
        HStack {
            ViewOfCard(Card(isFaceUp: true, content: "X", id: "test1"))
            ViewOfCard(Card(content: "X", id: "test1"))
        }
        HStack {
            ViewOfCard(Card(isFaceUp: true, content: "That is too long", id: "test1"))
            ViewOfCard(Card(content: "X", id: "test1"))
        }
    }
    .padding()
    .foregroundColor(.blue)
}

