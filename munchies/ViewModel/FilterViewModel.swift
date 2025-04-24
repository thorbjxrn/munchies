import Foundation

@MainActor
class FilterViewModel: ObservableObject {
    @Published var allFilters: [Filter] = []
    @Published var selectedFilterIDs: Set<String> = []

    var selectedFilters: [Filter] {
        allFilters.filter { selectedFilterIDs.contains($0.id) }
    }

    var isFiltering: Bool {
        !selectedFilterIDs.isEmpty
    }

    init() {
        Task {
            await fetchAllFilters()
        }
    }

    func fetchAllFilters() async {
        guard let url = URL(string: "https://food-delivery.umain.io/api/v1/filter") else { return }

        do {
            let filters: [Filter] = try await NetworkService.shared.fetchData(from: url)
            allFilters = filters
        } catch {
            print("⚠️ Failed to load filters: \(error.localizedDescription)")
        }
    }

    func toggleSelection(of filter: Filter) {
        if selectedFilterIDs.contains(filter.id) {
            selectedFilterIDs.remove(filter.id)
        } else {
            selectedFilterIDs.insert(filter.id)
        }
    }

    func isSelected(_ filter: Filter) -> Bool {
        selectedFilterIDs.contains(filter.id)
    }
}
