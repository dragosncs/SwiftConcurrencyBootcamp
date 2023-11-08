//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Dragos Neacsu on 08.11.2023.
//

import SwiftUI

actor CurrentUserManager {
    
    func updateDatabase(userInfo: MyClassUserInfo) {
        
    }
    
}
struct MyUserInfo: Sendable {
    let name: String
}

final class MyClassUserInfo: @unchecked Sendable {
    private var name: String
    let queue = DispatchQueue(label: "com.MyApp.MyClassUserInfo")
    
    init(name: String) {
        self.name = name
    }
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableBootcampViewModel: ObservableObject {
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        
        let info =  MyClassUserInfo(name: "info")
        await manager.updateDatabase(userInfo: info)
    }
}

struct SendableBootcamp: View {
    
    @StateObject private var viewModel = SendableBootcampViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                
            }
    }
}

struct SendableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SendableBootcamp()
    }
}
