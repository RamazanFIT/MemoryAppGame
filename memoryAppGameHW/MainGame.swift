//  MainGame.swift
//  memoryAppGameHW
//
//  Created by Сырлыбай Рамазан on 27.02.2024.
//

import Foundation

struct MainGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score = 0

    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content: CardContent = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
    }

    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
    }

    mutating func choose(_ card: Card) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
              !cards[chosenIndex].isFaceUp,
              !cards[chosenIndex].isMatched else {
            return
        }

        if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
            updateScore(chosenIndex, potentialMatchIndex)
        } else {
            indexOfTheOneAndOnlyFaceUpCard = chosenIndex
        }

        cards[chosenIndex].isFaceUp = true
    }

    private mutating func updateScore(_ chosenIndex: Int, _ potentialMatchIndex: Int) {
        if cards[chosenIndex].content == cards[potentialMatchIndex].content {
            cards[chosenIndex].isMatched = true
            cards[potentialMatchIndex].isMatched = true
            score += 2 + cards[chosenIndex].bonus + cards[potentialMatchIndex].bonus
        } else {
            score -= penaltyForMismatch(chosenIndex, potentialMatchIndex)
        }
    }

    private func penaltyForMismatch(_ chosenIndex: Int, _ potentialMatchIndex: Int) -> Int {
        var penalty = 0
        if cards[chosenIndex].hasBeenSeen {
            penalty += 1
        }
        if cards[potentialMatchIndex].hasBeenSeen {
            penalty += 1
        }
        return penalty
    }

    mutating func shuffle() {
        cards.shuffle()
    }

    struct Card: Equatable, Identifiable, CustomStringConvertible {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        var hasBeenSeen = false
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        let content: CardContent

        var id: String
        var description: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down")\(isMatched ? " matched" : "")"
        }

        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }

        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }

        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }

        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        var bonusTimeLimit: TimeInterval = 6

        var lastFaceUpDate: Date?

        var pastFaceUpTime: TimeInterval = 0
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}

