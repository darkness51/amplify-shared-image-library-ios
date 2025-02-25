//
//  GalleryViewModel.swift
//  SharedImageGallery
//
//  Created by Carlos Aguilar on 2/24/25.
//

import Amplify
import os
import PhotosUI
import SwiftUI

@Observable
final class GalleryViewModel {
    // MARK: - Public Properties
    var posts: [Post] = []
    var imageSelection: [PhotosPickerItem] = []

    // MARK: - Private Properties
    @ObservationIgnored private lazy var logger: os.Logger = {
        Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: self))
    }()

    // MARK: - Helper Methods
    func uploadImage(from data: Data) async {
        let imageKey = "gallery/\(UUID().uuidString).jpg"
        let uploadTask = Amplify.Storage.uploadData(path: .fromString(imageKey), data: data)
        do {
            let result = try await uploadTask.value
            logger.info("Upload data completed with result: \(result)")
            let post = Post(imageKey: imageKey, uploadedDate: Temporal.Date.now())
            await save(post)
        } catch {
            logger.error("Upload data failed with error: \(error)")
        }
    }

    func downloadImage(forImageKey imageKey: String) async -> Data? {
        let task = Amplify.Storage.downloadData(
            path: .fromString(imageKey)
        )
        do {
            let result = try await task.value
            logger.info("Download data completed")
            return result
        } catch {
            logger.error("Download data failed with error: \(error)")
            return nil
        }
    }

    func listPosts() async {
        do {
            let result = try await Amplify.API.query(request: .list(Post.self))
            switch result {
                case let .success(posts):
                    self.posts = posts.elements
                case let .failure(error):
                    logger.error("Failed to fetch the list of posts: \(error.errorDescription)")
            }
        } catch {
            logger.error("Failed to fetch the list of posts: \(error)")
        }
    }
}

// MARK: - Private Helpers
private extension GalleryViewModel {
    func save(_ post: Post) async {
        do {
            let postCreationResult = try await Amplify.API.mutate(request: .create(post))
            switch postCreationResult {
                case let .success(serverPost):
                    logger.info("Successfully saved post to DataStore: \(serverPost.id)")
                case let .failure(error):
                    logger.error("Error saving to DataStore: \(error)")
            }
        } catch {
            logger.error("Failed to save post to DataStore: \(error)")
        }
    }
}
