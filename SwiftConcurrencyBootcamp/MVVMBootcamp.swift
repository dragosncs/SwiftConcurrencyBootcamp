//
//  MVVMBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Dragos Neacsu on 09.11.2023.
//

import SwiftUI

actor MyManagerActor{
    func getData() async throws -> String {
        "Some data"
    }
}

final class MymanagerClass {
    func getData() async throws -> String {
        "Some data"
    }
    

}

@MainActor
class MVVMBootcampViewModel: ObservableObject {
    let managerClass = MymanagerClass()
    let managerActor = MyManagerActor()
  @Published private (set) var myData: String = "Starting Text"
    private var tasks: [Task<Void, Never>] = []
    
    
    func onCallToAction() {
       let task =  Task {
           
           do{
//               myData = try await managerClass.getData()
               myData = try await managerActor.getData()
               
           } catch {
               print(error)
           }
           
        }
        tasks.append(task)
    }
}

struct MVVMBootcamp: View {
    
    @StateObject private var viewModel = MVVMBootcampViewModel()
    
    var body: some View {
        Button(viewModel.myData) {
            viewModel.onCallToAction()
        }
    }
}

struct MVVMBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        MVVMBootcamp()
    }
}
