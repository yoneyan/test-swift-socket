//
//  ContentView.swift
//  Shared
//
//  Created by 米田 悠人  on 2022/04/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var connection1 = Connection1(hostName: "RTK2go.com", port: 2101)
    @ObservedObject var connection = Connection()
    @ObservedObject var test = Test()
    
    var body: some View {
//        Button(action: {
//            print("タップされました")
//            self.test.plus()
//        }) {
//            Image(systemName: "video.fill")
//            Text("足し算").font(.largeTitle)
//        }
//        Button(action: {
//            print("タップされました")
//            self.test.mainasu()
//        }) {
//            Text("引き算").font(.largeTitle)
//        }
//        Text("Value: " + String(self.test.data))
//
//        Text("Connection: " + String(self.connection.data))
        
        Button(action: {
            print("タップされました")
//            ChatClient(ip: "rtk2go.com", port: 2101)
//            Connection().example()
            Task{
                self.connection1.start()
                self.connection1.send()
            }
//            self.connection1.run()
            self.connection.rtkConnection(connection1: connection1)

        }) {
            Image(systemName: "video.fill")
            Text("情報取得テスト").font(.largeTitle)
        }
        ScrollView(.vertical, showsIndicators: true) {
            Text(self.connection1.data)
        }
        .frame(maxWidth: .infinity, maxHeight: 500.0)
        .background(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(connection1: Connection1(hostName: "RTK2go.com", port: 2101))
    }
}
