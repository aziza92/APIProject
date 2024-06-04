//
//  APIProjectApp.swift
//  APIProject
//
//  Created by KARMANI Aziza on 19/09/2023.
//

import SwiftUI

@main
struct APIProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
