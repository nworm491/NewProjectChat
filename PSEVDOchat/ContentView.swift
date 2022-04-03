
import SwiftUI
var sockserver:ClientSock = ClientSock()
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
                    NavigationLink(destination: Chat(), isActive: $isTrue){EmptyView()}
                    Button{
                        if(sock != ""){
                            //self.isTrue.toggle()
                            sockserver.Name = sock
                            
                                sockserver.StartConnecting()
                                if(sockserver.Connectings){
                                    self.isTrue.toggle()
                                    //NavigationLink(destination:Chat()) { EmptyView() }
                                }
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
    @State var Sms = ""
    @State var isReloar = false
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView{
                    VStack{
                         ForEach(sockserver.ReadSMS, id: \.self){sms in
                            let Name = sms.components(separatedBy: ":")[0]
                            let smsComponents = sms.replace(target: "\(Name):",withString:"")
                            if(Name.contains(sockserver.Name)){
                                if(smsComponents == ")"){
                                    Text(Name)
                                        .foregroundColor(Color.black)
                                        .frame(width: 200)
                                        .padding()
                                        .offset(x: 60)
                                    Image("smail")
                                        .frame(width: 32, height: 32)
                                        .offset(x: 60)
                                }
                                else if(smsComponents == ")<"){
                                    Text(Name)
                                        .foregroundColor(Color.black)
                                        .frame(width: 200)
                                        .padding()
                                        .offset(x: 60)
                                    Image("mad")
                                        .frame(width: 32, height: 32)
                                        .offset(x: 60)
                                }
                                else if(smsComponents == "XD"){
                                    Text(Name)
                                        .foregroundColor(Color.black)
                                        .frame(width: 200)
                                        .padding()
                                        .offset(x: 60)
                                    Image("XD")
                                        .frame(width: 32, height: 32)
                                        .offset(x: 60)
                                }
                                else{
                                    Text("\(Name)\n\(smsComponents)")
                                        .padding()
                                        .foregroundColor(Color.black)
                                        .frame(width: 200)
                                        .border(Color.black)
                                        .offset(x: 80)
                                }
                            }else{
                                if(smsComponents == ")"){
                                    Text(Name)
                                        .foregroundColor(Color.black)
                                        .frame(width: 200)
                                        .padding()
                                        .offset(x: -60)
                                    Image("smail")
                                        .frame(width: 32, height: 32)
                                        .offset(x: -60)
                                }
                                else if(smsComponents == ")<"){
                                    Text(Name)
                                        .foregroundColor(Color.black)
                                        .frame(width: 200)
                                        .padding()
                                        .offset(x: -60)
                                    Image("mad")
                                        .frame(width: 32, height: 32)
                                        .offset(x: -60)
                                }
                                else if(smsComponents == "XD")
                                {
                                    
                                    Text(Name)
                                        .foregroundColor(Color.black)
                                        .frame(width: 200)
                                        .padding()
                                        .offset(x: -60)
                                    Image("XD")
                                        .frame(width: 32, height: 32)
                                        .offset(x: -60)
                                }
                                else{
                                    Text("\(Name)\n\(smsComponents)")
                                        .padding()
                                        .foregroundColor(Color.black)
                                        .frame(width: 200)
                                        .border(Color.black)
                                        .offset(x: -80)
                                }
                            }
                        }.refreshable {
                            Sms+=" "
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
                        sockserver.SendSms(SMS: "\(sockserver.Name):\(Sms)")
                        Sms = ""
                        self.isReloar.toggle()
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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
