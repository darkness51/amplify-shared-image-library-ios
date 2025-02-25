// swiftlint:disable all
import Amplify
import Foundation

public struct Post: Model {
  public let id: String
  public var imageKey: String?
  public var uploadedDate: Temporal.Date?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      imageKey: String? = nil,
      uploadedDate: Temporal.Date? = nil) {
    self.init(id: id,
      imageKey: imageKey,
      uploadedDate: uploadedDate,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      imageKey: String? = nil,
      uploadedDate: Temporal.Date? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.imageKey = imageKey
      self.uploadedDate = uploadedDate
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}