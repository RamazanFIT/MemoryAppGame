//
//  memoryAppGameHWApp.swift
//  memoryAppGameHW
//
//  Created by Сырлыбай Рамазан on 27.02.2024.
//

import SwiftUI

@main
struct memoryAppGameHWApp: App {
    @StateObject private var game = MemoryGameEmoji()

    var body: some Scene {
        WindowGroup {
            EmojiView(viewModel: game)
        }
    }
}
