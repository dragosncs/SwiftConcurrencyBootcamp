//
//  AsyncAwait.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Dragos Neacsu on 06.11.2023.
//

import SwiftUI

class AsyncAwaitViewModel: ObservableObject{
    @Published var dataArray: [String] = []
    
    func addTitle() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title1: \(Thread.current)")
        }
        
    }
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            let title = "Title2: \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
                
                let title3 = "Title3 : \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }
    
    func addAuthor1() async {
        let author1 = "Author: \(Thread.current)"
        self.dataArray.append(author1)
        
       try? await Task.sleep(nanoseconds: 2_000_000_000)
        let author2 = "Author2: \(Thread.current)"
        
        
        await MainActor.run(body: {
            self.dataArray.append(author2)
            let author3 = "Author: \(Thread.current)"
            self.dataArray.append(author3)
        })
//        await doesSomething()
    }
    
    func doesSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let does1 = "doesSmth1: \(Thread.current)"
        
        
        await MainActor.run(body: {
            self.dataArray.append(does1)
            let does2 = "doesSmth2: \(Thread.current)"
            self.dataArray.append(does2)
        })
    }
    
}

struct AsyncAwait: View {
    
    @StateObject private var viewModel = AsyncAwaitViewModel()
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear{
            Task {
                await  viewModel.addAuthor1()
                await viewModel.doesSomething()
                let finalText = "Final Text: \(Thread.current)"
                viewModel.dataArray.append(finalText)
                
            }
           
//            viewModel.addTitle()
//            viewModel.addTitle2()
        }
    }
}

struct AsyncAwait_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwait()
    }
}
