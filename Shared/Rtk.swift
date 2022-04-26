//
//  Rtk.swift
//  TestRtk
//
//  Created by 米田 悠人  on 2022/04/24.
//

import Darwin
import Foundation
import Network

class ObservedData : ObservableObject {
    @Published var text: String = ""
}

//class Connection {
//    func send(connection: NWConnection) {
//        let _mountPoint = "/otkck"
//        let userAgent = "NTRIP Client0.1"
//        var message = "GET " + _mountPoint + " HTTP/1.1\r\nUser-Agent: " + userAgent + "\r\n"
//        message += "Accept: */*\r\nConnection: close\r\n"
//
//        /* 送信データ生成 */
//        let data = message.data(using: .utf8)!
//        let semaphore = DispatchSemaphore(value: 0)
//
//        NSLog(message)
//
//        /* データ送信 */
//        connection.send(content: data, completion: .contentProcessed { error in
//            if let error = error {
//                NSLog("\(#function), \(error)")
//            } else {
//                semaphore.signal()
//            }
//        })
//        /* 送信完了待ち */
//        semaphore.wait()
//    }
//
//    func recv(connection: NWConnection) {
//        NSLog("recv process...")
//        let semaphore = DispatchSemaphore(value: 0)
//        /* データ受信 */
//        connection.receive(minimumIncompleteLength: 0, maximumLength: 65535, completion: { (data, context, isDone, error) in
//            if let error = error {
//                NSLog("\(#function), \(error)")
//            } else {
//                if let data = data, !data.isEmpty {
//                    NSLog("did receive, data: %@", data as NSData)
//                }
//                if let error = error {
//                    NSLog("did receive, error: %@", "\(error)")
////                    self.stop()
////                    return
//                }
//                if isDone {
//                    NSLog("did receive, EOF")
////                    self.stop()
////                    return
//                }
//            }
//        })
//        /* 受信完了待ち */
//        semaphore.wait()
//        recv(connection: connection)
//    }
//
//    func disconnect(connection: NWConnection) {
//        /* コネクション切断 */
//        connection.cancel()
//    }
//
//    func connect(host: String, port: String) -> NWConnection {
//        let t_host = NWEndpoint.Host(host)
//        let t_port = NWEndpoint.Port(port)
//        let connection: NWConnection
//        let semaphore = DispatchSemaphore(value: 0)
//
//        /* コネクションの初期化 */
//        connection = NWConnection(host: t_host, port: t_port!, using: .tcp)
//
//        /* コネクションのStateハンドラ設定 */
//        connection.stateUpdateHandler = { (newState) in
//            switch newState {
//            case .ready:
//                NSLog("Ready to send")
//                semaphore.signal()
//            case .waiting(let error):
//                NSLog("\(#function), \(error)")
//            case .failed(let error):
//                NSLog("\(#function), \(error)")
//            case .setup: break
//            case .cancelled: break
//            case .preparing: break
//            @unknown default:
//                fatalError("Illegal state")
//            }
//        }
//
//        /* コネクション開始 */
//        let queue = DispatchQueue(label: "example")
//        connection.start(queue: queue)
//
//        /* コネクション完了待ち */
//        semaphore.wait()
//        return connection
//    }
//
//    func example() {
//        let connection: NWConnection
//        let host = "RTK2go.com"
//        let port = "2101"
//
//        /* コネクション開始 */
//        connection = connect(host: host, port: port)
//        /* データ送信 */
//        send(connection: connection)
//        /* データ受信 */
//        recv(connection: connection)
////        recv(connection: connection)
//        /* コネクション切断 */
////        disconnect(connection: connection)
//    }
//}

class Test: ObservableObject {
    
    @Published var data: Int = 0
    
    func plus(){
        self.data += 1
    }
    
    func mainasu(){
        self.data -= 1
    }
}

class Connection: ObservableObject {
    @Published var data: String = ""

    func rtkConnection(connection1: Connection1){
        let tmpData: String = connection1.data1
        DispatchQueue.main.async {
          self.data = tmpData
        }
        
    }
}

extension Data {
    var hex: String {
        return self.map { b in String(format: "%02X", b) }.joined()
    }
}

class Connection1: NSObject,ObservableObject {
    
    @Published var data: String = ""
    var data1: String = ""

    init(hostName: String, port: Int) {
        let host = NWEndpoint.Host(hostName)
        let port = NWEndpoint.Port("\(port)")!
        self.connection = NWConnection(host: host, port: port, using: .tcp)
//        self.connection.start()
//        self.connection.send()
    }

    let connection: NWConnection

    func start() {
        NSLog("will start")
        self.connection.stateUpdateHandler = self.didChange(state:)
        self.startReceive()
        self.connection.start(queue: .main)
    }

    func stop() {
        self.connection.cancel()
        NSLog("did stop")
    }

    private func didChange(state: NWConnection.State) {
        switch state {
        case .setup:
            break
        case .waiting(let error):
            NSLog("is waiting: %@", "\(error)")
        case .preparing:
            break
        case .ready:
            break
        case .failed(let error):
            NSLog("did fail, error: %@", "\(error)")
            self.stop()
        case .cancelled:
            NSLog("was cancelled")
            self.stop()
        @unknown default:
            break
        }
    }

    private func startReceive() {
        self.connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { data, _, isDone, error in
            if let error = error {
                NSLog("did receive, error: %@", "\(error)")
                self.stop()
                return
            }
            if isDone {
                NSLog("did receive, EOF")
                self.stop()
                return
            }
            if let data = data, !data.isEmpty {
                let dt = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy-MM-dd HH:mm:ss", options: 0, locale: Locale(identifier: "ja_JP"))

                self.data = dateFormatter.string(from: dt) + "| length: "+String(data.count) + " hex: " + data.hex  + "\n"
//                self.data += "length: "+String(data.count) + "\n"
                self.data1 += "length: "+String(data.count) + "\n"
//                let tmp = NSString(data: data.length!, encoding: NSUTF8StringEncoding)
//                if let text = tmp {
//                    NSLog(text)
//                    self.object.text += text
//                }
                NSLog("did receive, data: %@", data as NSData)
//                NSLog("data: %@", self.data)

            }
            self.startReceive()
        }
    }

    func send() {
        let _mountPoint = "/otkck"
        let userAgent = "NTRIP Client0.1"
        var message = "GET " + _mountPoint + " HTTP/1.1\r\nUser-Agent: " + userAgent + "\r\n"
        message += "Accept: */*\r\nConnection: close\r\n"

        let data = message.data(using: .utf8)!
        self.connection.send(content: data, completion: NWConnection.SendCompletion.contentProcessed { error in
            if let error = error {
                NSLog("did send, error: %@", "\(error)")
                self.stop()
            } else {
                NSLog("did send, data: %@", data as NSData)
            }
        })
    }

    func run() {
        let m = Connection1(hostName: "RTK2go.com", port: 2101)
        m.start()

//        let t = DispatchSource.makeTimerSource(queue: .main)
        m.send()
//        t.schedule(wallDeadline: .now() + 1.0, repeating: 1.0)
//        t.activate()

//        dispatchMain()
    }
}
