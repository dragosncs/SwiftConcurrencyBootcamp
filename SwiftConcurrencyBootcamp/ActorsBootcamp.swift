//
//  ActorsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Dragos Neacsu on 08.11.2023.
//

import SwiftUI

class MyDataManager {
    
    static let instance = MyDataManager()
    private init() { }
    
    var data: [String] = []
    
    private let queue = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> ()) {
        queue.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
        
        
    }
}

actor MyActorDataManager {
    
    static let instance = MyActorDataManager()
    private init() { }
    
    var data: [String] = []
    
    nonisolated let myRandomText = "asdfasdfadfsfdsdfs"
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
    
    nonisolated func getSavedData() -> String {
        return "NEW DATA"
    }
    
}


struct HomeView: View {
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let manager = MyActorDataManager.instance
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onAppear{
            let newString = manager.myRandomText
            
            Task {
                let newString = manager.getSavedData()
            }
        }
        .onReceive(timer) { _ in
            
            DispatchQueue.global(qos: .background).async {
                Task{
                    if let data = await manager.getRandomData() {
                        await MainActor.run(body: {
                            self.text = data
                        })
                    }
                }
                
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//
//                }
//
//                }
                            
            }
        }
    }
}

struct BrowseView: View {
    
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    let manager = MyActorDataManager.instance
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            DispatchQueue.global(qos: .default).async {
                
                Task{
                    if let data = await manager.getRandomData() {
                        await MainActor.run(body: {
                            self.text = data
                        })
                    }
                }
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//
//                }
//            }
            
            }
        }
    }
}


struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

struct ActorsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ActorsBootcamp()
    }
}



