import Foundation

struct Milestone: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var title: String
    var status: String

    init(id: UUID = UUID(), createdAt: Date = Date(), title: String, status: String) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.status = status
    }
}
