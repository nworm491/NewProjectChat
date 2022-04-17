//
//  Client.swift
//  PSEVDOchat
//
//  Created by Admin on 03.03.2022.
//

import Foundation
import SwiftUI



public class ClientSock: NSObject {
    public  var Connectings = false
    public  var Name = ""
    public  var ReadSMS:[String] = []
    public  var inputStream: InputStream!
    public  var outputStream: OutputStream!
    public  var window = UIApplication.shared.windows.first
    /*
    func showModal() {
            //нельзя мой код воровать ай ай ай
            let window = UIApplication.shared.windows.first
            window?.rootViewController?.present(UIHostingController(rootView: Chat()), animated: true)
            
        
    }*/
    public  func StartConnecting() {
        if(!Connectings){
            ReadSMS = []
            window = UIApplication.shared.windows.first
            window?.rootViewController?.present(UIHostingController(rootView: Chat()), animated: true)
            var readStream: Unmanaged<CFReadStream>?
            var writeStream: Unmanaged<CFWriteStream>?
            CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                               "2.135.131.169" as CFString,
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
        }
    }
    public func Exit(){
        if(Connectings){
            inputStream.close()
            outputStream.close()
            window?.rootViewController?.dismiss(animated: true, completion: nil)
            Connectings = false
        }
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
                freeWhenDone: true
            )
            if(str != ""){
                ReadSMS.append(str ?? "")
                window?.rootViewController?.dismiss(animated: false, completion: nil)
                window?.rootViewController?.present(UIHostingController(rootView: Chat()), animated: false)
            }
        }
    }
    public  func SendSms(SMS:String){
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
