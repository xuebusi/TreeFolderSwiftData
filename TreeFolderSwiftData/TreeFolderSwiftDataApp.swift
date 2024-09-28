//
//  TreeFolderSwiftDataApp.swift
//  TreeFolderSwiftData
//
//  Created by shiyanjun on 2024/9/28.
//

import SwiftUI
import SwiftData

@main
struct TreeFolderSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Directory.self)
    }
}
