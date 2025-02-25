//
//  ContentView.swift
//  SharedImageGallery
//
//  Created by Carlos Aguilar on 2/24/25.
//

import Amplify
import Authenticator
import PhotosUI
import SwiftUI

struct ContentView: View {
    @State var viewModel: GalleryViewModel = GalleryViewModel()
    @State var isPresentingImagePicker: Bool = false

    var body: some View {
        Authenticator { state in
            NavigationStack {
                List(viewModel.posts, id: \.id) { post in
                    PostView(post: post)
                        .environment(viewModel)
                }
                .photosPicker(
                    isPresented: $isPresentingImagePicker,
                    selection: $viewModel.imageSelection,
                    maxSelectionCount: 18,
                    matching: .images
                )
                .toolbar {
                    Button("Add Photos", systemImage: "plus.circle") {
                        isPresentingImagePicker.toggle()
                    }
                }
                .navigationTitle(Text("Gallery"))
                .onChange(of: viewModel.imageSelection) {
                    Task {
                        for item in viewModel.imageSelection {
                            if let originalImageData = try? await item.loadTransferable(type: Data.self) {
                                await viewModel.uploadImage(from: originalImageData)
                            }
                        }
                        await viewModel.listPosts()
                    }
                }
                .refreshable {
                    await viewModel.listPosts()
                }
                .task {
                    await viewModel.listPosts()
                }
            }
        }
    }
}

struct PostView: View {
    var post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AmplifyImage(imageName: post.imageKey ?? "")

            Text("uploaded on: \(post.createdAt?.foundationDate ?? Date(), style: .date)")
        }
    }
}

struct AmplifyImage: View {
    var imageName: String
    @State private var isLoading: Bool = true
    @State private var image: UIImage?
    @Environment(GalleryViewModel.self) private var viewModel

    var body: some View {
        content
            .task {
                var imageName = imageName.hasPrefix("gallery/") ? imageName : "gallery/\(imageName)"
                if let data = await viewModel.downloadImage(forImageKey: imageName) {
                    image = UIImage(data: data)
                    isLoading = false
                }
            }
    }

    @ViewBuilder
    var content: some View {
        if isLoading {
            ProgressView()
        } else if let image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            EmptyView()
        }
    }

}

#Preview {
    ContentView()
}
