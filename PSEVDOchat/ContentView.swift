
import SwiftUI
var sockserver:ClientSock = ClientSock()
struct ContentView: View {
     
    @State var sock: String = sockserver.Name
    @State var login = false
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
                            self.isTrue.toggle()
                            sockserver.Name = sock
                            /*
                            if(!login){
                                login = true
                                sockserver.StartConnecting()
                                if(sockserver.Connectings){
                                    self.isTrue.toggle()
                                    //NavigationLink(destination:Chat()) { EmptyView() }
                                }
                                login = false
                             }*/
                                
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


func getMessage(allMessage: [String]) -> String{
    var finalMessage = ""
    for message in allMessage {
        finalMessage += message
    }
    
    return finalMessage
}

//этот код отвечает за чат
struct Chat: View {
    let WighitMax:CGFloat = 100
    @State var Sms = ""
    var body: some View {
        NavigationView{
            VStack{
                ScrollView{
                    VStack{
                        ForEach(sockserver.ReadSMS, id: \.self){sms in
                            var allMessage = sms.components(separatedBy: ":")
                            let Name = sms.components(separatedBy: ":")[0]
                            allMessage.removeFirst()
                            var smsComponents: String = getMessage(allMessage: allMessage)
                            
                            
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
                                else if(smsComponents == "("){
                                    Text(Name)
                                        .foregroundColor(Color.black)
                                        .frame(width: 200)
                                        .padding()
                                        .offset(x: 60)
                                    Image("obi")
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
                                /*else if(smsComponents.contains("http") && (smsComponents.contains(".jpg") || smsComponents.contains(".png"))){
                                     AsyncImage(url: URL(string: smsComponents))
                                         .frame(width: 200, height: 200)
                                         .offset(x: 60)
                                 }*/
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
                                else if(smsComponents == "(")
                                {
                                    Text(Name)
                                        .foregroundColor(Color.black)
                                        .frame(width: 200)
                                        .padding()
                                        .offset(x: -60)
                                    Image("obi")
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
                                /*else if(smsComponents.contains("http") && (smsComponents.contains(".jpg") || smsComponents.contains(".png") ) ){
                                    AsyncImage(url: URL(string: smsComponents))
                                        .frame(width: 200, height: 200)
                                        .offset(x: -60)
                                }*/
                                else{
                                    Text("\(Name)\n\(smsComponents)")
                                        .padding()
                                        .foregroundColor(Color.black)
                                        .frame(width: 200)
                                        .border(Color.black)
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
                    sockserver.SendSms(SMS: Sms)
                    Sms = ""
                }label:{
                    Text("Send")
                        .foregroundColor(Color.black)
                        .padding()
                }
            }}
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
