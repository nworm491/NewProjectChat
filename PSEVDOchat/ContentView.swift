
import SwiftUI
var sockserver:ClientSock = ClientSock()
var Chats = Chat()
struct ContentView: View {
    
    @State var sock: String = sockserver.Name
    @State var isTrue = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Rectangle()
                    .frame(height: 1000)
                    .foregroundColor(Color.yellow)
                VStack{
                    TextField("Name", text: $sock)
                        .foregroundColor(Color.black)
                        .background(Color.yellow)
                    Button{
                        if(sock != ""){
                            sockserver.Name = sock
                            sockserver.StartConnecting()
                        }
                    }label:{
                        Text("Login in chat")
                            .foregroundColor(Color.black)
                        
                    }
                }
            }
        }
    }
}


extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

//этот код отвечает за чат
struct Chat: View {
    let WighitMax:CGFloat = 100
    @State var isReloar = false
    @State var ks = true
    @State var Sms = ""
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView{
                    VStack{
                         ForEach(sockserver.ReadSMS, id: \.self){sms in
                            let Name = sms.components(separatedBy: ":")[0]
                            let smsComponents = sms.replace(target: "\(Name):",withString:"")
                            if(Name.contains(sockserver.Name)){
                                if(smsComponents == ")")
                                {
                                    VStack{
                                        Text(Name)
                                            .foregroundColor(Color.black)
                                            .frame(width: 200)
                                            .padding()
                                        Image("smail")
                                            .frame(width: 32, height: 32)
                                            .padding()
                                            .padding()
                                    }
                                    .background(Color.gray)
                                    .cornerRadius(5)
                                    .offset(x: 60)
                                }
                                else if(smsComponents == ")<")
                                {
                                    VStack{
                                        Text(Name)
                                            .foregroundColor(Color.black)
                                            .frame(width: 200)
                                            .padding()
                                        Image("mad")
                                            .frame(width: 32, height: 32)
                                            .padding()
                                            .padding()
                                    }
                                    .background(Color.gray)
                                    .cornerRadius(5)
                                    .offset(x: 60)
                                }
                                else if(smsComponents == "XD")
                                {
                                    VStack{
                                        Text(Name)
                                            .foregroundColor(Color.black)
                                            .frame(width: 200)
                                            .padding()
                                        Image("XD")
                                            .frame(width: 32, height: 32)
                                            .padding()
                                            .padding()
                                    }
                                    .background(Color.gray)
                                    .cornerRadius(5)
                                    .offset(x: 60)
                                }
                                else if(smsComponents == "test"){
                                    Text(Name)
                                        .foregroundColor(Color.black)
                                        .frame(width: 200)
                                        .padding()
                                    VStack{
                                        AsyncImage(url: URL(string: "https://developer.apple.com/news/images/og/swiftui-og-twitter.png")) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Color.gray
                                        }
                                        .frame(width: 200, height: 200)
                                    }
                                    .background(Color.gray)
                                    .cornerRadius(5)
                                    .offset(x: 60)
                                }
                                else
                                {
                                    Text("\(Name)\n\(smsComponents)")
                                        .padding()
                                        .foregroundColor(Color.black)
                                        .background(Color.gray)
                                        .cornerRadius(5)
                                        .frame(width: 200)
                                        .offset(x: 80)
                                }
                             }
                             else
                             {
                                if(smsComponents == ")")
                                 {
                                    VStack{
                                        Text(Name)
                                            .foregroundColor(Color.black)
                                            .frame(width: 200)
                                            .padding()
                                        Image("smail")
                                            .frame(width: 32, height: 32)
                                            .padding()
                                            .padding()
                                    }
                                    .background(Color.gray)
                                    .cornerRadius(5)
                                    .offset(x: -60)
                                }
                                else if(smsComponents == ")<")
                                {
                                    VStack{
                                        Text(Name)
                                            .foregroundColor(Color.black)
                                            .frame(width: 200)
                                            .padding()
                                        Image("mad")
                                            .frame(width: 32, height: 32)
                                            .padding()
                                            .padding()
                                    }
                                    .background(Color.gray)
                                    .cornerRadius(5)
                                    .offset(x: -60)
                                }
                                else if(smsComponents == "XD")
                                {
                                    VStack{
                                        Text(Name)
                                            .foregroundColor(Color.black)
                                            .frame(width: 200)
                                            .padding()
                                        Image("XD")
                                            .frame(width: 32, height: 32)
                                            .padding()
                                            .padding()
                                    }
                                    .background(Color.gray)
                                    .cornerRadius(5)
                                    .offset(x: -60)
                                }
                                else
                                {
                                    Text("\(Name)\n\(smsComponents)")
                                        .padding()
                                        .foregroundColor(Color.black)
                                        .background(Color.gray)
                                        .cornerRadius(5)
                                        .frame(width: 200)
                                        .offset(x: -80)
                                        
                                }
                            }
                        }
                    }.frame(width: 450)
                }.navigationTitle("Psevdo Online Chat")
                    .frame(height: 500)
                HStack{
                    TextField("Message",text: $Sms)
                        .foregroundColor(Color.black)
                        .frame(height: 50)
                        .padding()
                    Button{
                        if(Sms != "" || Sms != " "){
                            sockserver.SendSms(SMS: "\(sockserver.Name):\(Sms)")
                            sockserver.ReadSMS.append("\(sockserver.Name):\(Sms)")
                            Sms = ""
                        }
                    }label:{
                        Text("Send")
                            .foregroundColor(Color.black)
                            .padding()
                    }
                }
            }
        }
    }
}
//эльдарадо
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
