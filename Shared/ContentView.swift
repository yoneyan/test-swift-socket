//
//  ContentView.swift
//  Shared
//
//  Created by 米田 悠人  on 2022/04/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
                .padding()
        Button(action: {
            print("タップされました")
//            ChatClient(ip: "rtk2go.com", port: 2101)
//            Connection().example()
            Connection1(hostName: "RTK2go.com", port: 2101).run()
        }) {
            Image(systemName: "video.fill")
            Text("Test").font(.largeTitle)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
