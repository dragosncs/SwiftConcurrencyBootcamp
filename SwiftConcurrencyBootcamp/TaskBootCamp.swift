//
//  TaskBootCamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Dragos Neacsu on 06.11.2023.
//

import SwiftUI

class TaskBootCampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fecthImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
//        for x in array {
//            // work
//            try Task.checkCancellation()
//        }
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let(data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
                print("IMAGE RETURNED SUCCESSFULLY!")
            })        } catch  {
            print(error.localizedDescription)
        }
    }
     func fecthImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/2500") else { return }
            let(data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image2 = UIImage(data: data)
            })
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    
}

struct TaskBootcampHomeView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("CLICK ME! 🤓") {
                    TaskBootCamp()
                }
            }
        }
    }
}

struct TaskBootCamp: View {
    
    @StateObject private var viewModel = TaskBootCampViewModel()
//    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
        }
        

        .task {
            await viewModel.fecthImage()

        }
        
//        .onDisappear{
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//           fetchImageTask = Task {
////                print(Thread.current)
////                print(Task.currentPriority)
//                await viewModel.fecthImage()
//
//            }
////            Task{
////                print(Thread.current)
////                print(Task.currentPriority)
////                await viewModel.fecthImage2()
////            }
////            Task(priority: .high) {
//////                    try? await Task.sleep(nanoseconds: 2_000_000_000)
////                await Task.yield()
////                print("high : \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .userInitiated) {
////                print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .medium) {
////                print("medium : \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .low) {
////                print("low : \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .utility) {
////                print("utility : \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .background) {
////                print("background : \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .low) {
////                print("low : \(Thread.current) : \(Task.currentPriority)")
////
////                Task.detached {
////                    print("detached : \(Thread.current) : \(Task.currentPriority)")
////                }
////        }
//        }
    }
}

struct TaskBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcampHomeView()
    }
}
