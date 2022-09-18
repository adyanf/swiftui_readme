//
//  ReadMeApp.swift
//  ReadMe
//
//  Created by Adya Naufal Fikri on 17/09/22.
//

import SwiftUI

@main
struct ReadMeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Library())
        }
    }
}
