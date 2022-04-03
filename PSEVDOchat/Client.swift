//
//  Client.swift
//  PSEVDOchat
//
//  Created by Admin on 03.03.2022.
//

import Foundation
import SwiftUI



public class ClientSock: NSObject {
    public  let mainViewHeight = UIScreen.main.nativeBounds.height
    public  let mainViewWidth = UIScreen.main.nativeBounds.width
    public  var Connectings = false
    public  var Offset = 4
    //public static var Buffer:[Byte]
    public  var Header = 0
    // public static var Sock = new TcpClient
    public  var Name = ""
    public  var ReadSMS:[String] = []
    public  var inputStream: InputStream!
    public  var outputStream: OutputStream!
    
    func streamsToHost(name hostname: String, port: Int){
        Stream.getStreamsToHost(withName: hostname, port: port, inputStream: &inputStream, outputStream: &outputStream)
    }
    public  func StartConnecting() {
        Connectings = false
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           "92.46.87.15" as CFString,
                                           2000,
                                           &readStream,
                                           &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        inputStream.delegate = self
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        inputStream.open()
        outputStream.open()
        Connectings = true
        SendSms(SMS: Name)
    }
    private  func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 4090)
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: 4090)
            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }
            var str = String(
                bytesNoCopy: buffer,
                length: numberOfBytesRead,
                encoding: .utf8,
                freeWhenDone: true)
            if(str != ""){
                ReadSMS.append(str ?? "")
            }
            delegate?.received(message: str ?? "")
        }
    }
    public  func SendSms(SMS:String){
        ReadSMS.append("\(Name):\(SMS)")
        if(Connectings){
            let data = SMS.data(using: .utf8)!
            _ = data.withUnsafeBytes {
                guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    print("Error joining chat")
                    return
                }
                
                outputStream.write(pointer, maxLength: data.count)
            }
        }
    }
    weak var delegate: ChatRoomDelegate?
}
protocol ChatRoomDelegate: class {
  func received(message: String)
}


extension ClientSock: StreamDelegate {
    
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            print("new message received")
            readAvailableBytes(stream: aStream as! InputStream)
        case .endEncountered:
            print("The end of the stream has been reached.")
        case .errorOccurred:
            print("error occurred")
        case .hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
        }
    }
    
    
}
