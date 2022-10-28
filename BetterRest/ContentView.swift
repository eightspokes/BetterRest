//
//  ContentView.swift
//  BetterRest
//
//  Created by Roman on 10/22/22.
//
import CoreML
import SwiftUI
struct Header : ViewModifier{
    func body(content: Content)-> some View{
        content
            .font(.footnote.bold())
            .foregroundColor(.black)
        
    }
}

extension View {
    func sectionHeader() -> some View {
        modifier(Header())
    }
}

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
    
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = "Set the parameters above"
    @State private var showingAlert = false
    
    static var defaultWakeTime : Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View{
               
        NavigationView{
            Form{
                Section(header: Text("Wake up time").sectionHeader()){
                    DatePicker("Enter a wake up time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    
                        .frame(width: 340, height: 20, alignment: .trailing)
                        .pickerStyle(InlinePickerStyle())
                        .onChange(of: wakeUp){ newValue in
                            calculateBedtime()
                        }
                }
                
                Section(header: Text("Sleep amount").sectionHeader()){
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .onChange(of: sleepAmount){ newValue in
                            calculateBedtime()
                        }
                }

                Section(header: Text("Daily coffee intake").sectionHeader()){
                    Picker("Daily coffee intake", selection: $coffeeAmount) {
                        ForEach(1..<8) {
                            Text("\($0)")
                        }
                    }.onChange(of: coffeeAmount){ newValue in
                        calculateBedtime()
                    }
                }
                Section(header: Text("Recomended bed time: ").font(.footnote.bold()).foregroundColor(.red)){
                    
                    Text(alertMessage)
                }
            }
            //.onAppear {
            // UITableView.appearance().backgroundView = UIImageView(image: UIImage(named: "coffee"))
            //}
            
            .navigationBarTitle(Text("Better Rest").foregroundColor(.black))
            .navigationAppearance(foreGroundColor: .black, hideSeparator: true )
            .alert(alertTitle, isPresented: $showingAlert){
                Button("OK"){}
            }message:{
                Text(alertMessage)
            }
        }
    }
    func calculateBedtime()  {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date:.omitted, time:.shortened)
            
        }catch{
            alertTitle = "Error"
            alertMessage = "Sorry, there is a problem calculation your bedtime"
        }
        //showingAlert = true
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

