import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeLimit = 25

    @Published var items: [Milestone] = []
    @Published var isPro: Bool = false

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        self.fileURL = dir.appendingPathComponent("thesispace_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Milestone) {
        items.append(item)
        save()
    }

    func update(_ item: Milestone) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Milestone) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            items = seedData()
            save()
            return
        }
        if let decoded = try? JSONDecoder().decode([Milestone].self, from: data) {
            items = decoded
        } else {
            items = seedData()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL)
        }
    }

    private func seedData() -> [Milestone] {
        [
        Milestone(title: "Sample Title 1", status: "Sample Status 1"),
        Milestone(title: "Sample Title 2", status: "Sample Status 2"),
        Milestone(title: "Sample Title 3", status: "Sample Status 3")
        ]
    }
}
