//
//  ContentView.swift
//  BetterRest
//
//  Created by Roman on 10/22/22.
//

import SwiftUI
struct Header : ViewModifier{
    func body(content: Content)-> some View{
        content
            .font(.footnote.bold())
            .foregroundColor(.white)
            
    }
}

//We can not use it as .modifier(Title())
//Or wecan make an extension

extension View {
    func sectionHeader() -> some View {
        modifier(Header())
    }
}
// We can now use it by calling the menthod .titleStyle()


struct NavAppearenceModifier: ViewModifier{
    init(backgroundColor: UIColor?, foreGroundColor: UIColor, tintColor: UIColor?, hideSeparator: Bool){
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor : foreGroundColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: foreGroundColor]
        navBarAppearance.configureWithTransparentBackground()

        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        if let backgroundColor = backgroundColor{
            navBarAppearance.backgroundColor = backgroundColor
        }
        
        if let tintColor = tintColor {
            UINavigationBar.appearance().tintColor = tintColor
        }
        if hideSeparator{
            navBarAppearance.shadowColor = .clear
        }
    }
    
    func body(content: Content) -> some View{
        content
    }
}


extension View {
    func navigationAppearance(backgroundColor: UIColor? = nil, foreGroundColor: UIColor, tintColor: UIColor? = nil, hideSeparator: Bool = false) -> some View{
        self.modifier(NavAppearenceModifier(backgroundColor: backgroundColor, foreGroundColor: foreGroundColor, tintColor: tintColor, hideSeparator: hideSeparator))
    }
}

struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    
    
    
    
    var body: some View{
        
       
            NavigationView{
                VStack{
                    
                    Form{
                        
                        Section(header: Text("Wake up time").sectionHeader()){
                            DatePicker("Enter a wake up time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                                
                                .frame(width: 310, height: 40, alignment: .trailing)
                        }
                           
                        
                        Section(header: Text("Sleep amount").sectionHeader()){
                            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        }
                        
                        Section(header: Text("Daily coffee intake").sectionHeader()){
                            Stepper(coffeeAmount == 1 ? " 1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                        }
                        
                    }
                    .onAppear {
                        UITableView.appearance().backgroundView = UIImageView(image: UIImage(named: "coffee"))
                    }
                    
                }.navigationBarTitle(Text("Better Rest")).foregroundColor(.white)
                    .navigationAppearance(foreGroundColor: .white, hideSeparator: true )
            }

        
    }
}



//    .background(Image("coffee")
//        .resizable())
//    .navigationTitle("Better Rest")
    
//       Form{
//           Stepper(String(format: "%.1f",sleepAmount), value: $sleepAmount, in: 4...12,step: 0.5)
//           DatePicker("Please enter a date", selection: $wakeUp,in: Date.now..., displayedComponents: .hourAndMinute)
//              // .labelsHidden()

//    func trivialExample(){
//        let components = Calendar.current.dateComponents([.hour,.minute], from: Date.now)
//        let hour = components.hour ?? 0
//        let minutes = components.minute ?? 0
//
//    }
    
//    func exampleDate(){
//        let tomorrow = Date.now.addingTimeInterval(86400)
//        let range = Date.now ... tomorrow
//    }
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

