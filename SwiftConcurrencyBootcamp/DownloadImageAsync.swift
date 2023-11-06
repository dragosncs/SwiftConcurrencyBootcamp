//
//  DownloadImageAsync.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Dragos Neacsu on 06.11.2023.
//

import SwiftUI
import Combine

class ImageLoader {
    let url = URL(string: "https://picsum.photos/1209")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
           
            return nil
        }
        return image
    }
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?,_ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
               completionHandler(image, error)
        }
        .resume()
    }
    
    func  downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({$0})
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync() async throws -> UIImage?{
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return  handleResponse(data: data, response: response)
        } catch  {
            throw error
        }
        
       
    }
}

//@MainActor
class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    var cancellables = Set<AnyCancellable>()
    
    let loader = ImageLoader()
    
    func fetchImage() async {
        /*
       loader.downloadWithEscaping {[weak self] image, error in
            DispatchQueue.main.async {
                self?.image = image
            }

       }
        loader.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellables)
*/
        let image = try? await loader.downloadWithAsync()
        await MainActor.run(body: {
            self.image = image
        })
        
    }
}

struct DownloadImageAsync: View {
    
    @StateObject private var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400,height: 400)
            }
        }
        .onAppear {
            Task{
                await viewModel.fetchImage()
            }
        }
    }
}

struct DownloadImageAsync_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsync()
    }
}
