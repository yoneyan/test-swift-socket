//
//  TestRtkApp.swift
//  Shared
//
//  Created by 米田 悠人  on 2022/04/24.
//

import SwiftUI

@main
struct TestRtkApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(connection1: Connection1(hostName: "RTK2go.com", port: 2101))
        }
    }
}
