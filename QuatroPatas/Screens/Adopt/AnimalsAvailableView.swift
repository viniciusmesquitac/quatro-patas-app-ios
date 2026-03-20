import SwiftUI

struct AnimalsAvailableView: View {
    @Binding var filter: AnimalFilter
    @Binding var location: String
    @Binding var animals: [Animal]
    @Binding var isLoading: Bool

    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var navigator: Navigator
    @Environment(\.toast) var toast

    @State private var isInteractionEnabled = false
    @State private var enableInteractionTask: Task<Void, Never>?

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }

    var body: some View {
        ZStack {
            VStack(spacing: Spacing.large.rawValue) {
                if !filter.isEmpty {
                    FilterView(filter: $filter)
                        .padding(.horizontal, Padding.large.rawValue)
                        .padding(.bottom, Padding.medium.rawValue)
                }

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredAnimals, id: \.id) { animal in
                        AnimalCardViewV2(animal: animal) {
                            guard isInteractionEnabled else { return }
                            navigator.navigate(to: .details(animal))
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .opacity
                        ))
                        .allowsHitTesting(isInteractionEnabled)
                    }
                }
                .padding(.horizontal, Padding.large.rawValue)
            }
            .padding(.bottom, Padding.large.rawValue)
            .allowsHitTesting(!isLoading)

            if isLoading {
                ZStack {
                    Color.clear
                        .ignoresSafeArea()

                    LoadingView()
                }
                .transition(.opacity)
            }
        }
        .onChange(of: location) { _, newValue in
            Task {
                await fetchNGOs(for: newValue)
            }
        }
        .onChange(of: isLoading) { _, newValue in
            if !newValue {
                startInteractionDelay()
            }
        }
        .onAppear {
            startInteractionDelay()

            Task {
                if animals.isEmpty {
                    await fetchNGOs(for: location)
                } else {
                    isLoading = false
                }
            }
        }
        .onDisappear {
            enableInteractionTask?.cancel()
        }
        .padding(.bottom, Padding.large.rawValue)
    }

    @MainActor
    private func fetchAllAnimals(ongIds: [String]) async {
        do {
            var allAnimals: [Animal] = []

            for id in ongIds {
                let fetched: [Animal] = try await databaseProvider.fetch(from: "users/\(id)/animals") {
                    $0
                        .whereField("isMissing", isEqualTo: false)
                        .whereField("isAdopted", isEqualTo: false)
                        .order(by: "position", descending: false)
                }
                allAnimals.append(contentsOf: fetched)
            }

            withAnimation(.spring()) {
                self.animals = allAnimals
            }

            isLoading = false
        } catch {
            toast(error.localizedDescription, .error)
            isLoading = false
        }
    }

    @MainActor
    private func fetchNGOs(for location: String) async {
        enableInteractionTask?.cancel()
        isInteractionEnabled = false
        isLoading = true

        do {
            let items: [User] = try await databaseProvider.fetch(from: "users") { ref in
                var query = ref.whereField("type", isEqualTo: "usertype.ngo")

                if !location.isEmpty {
                    query = query.whereField("location", isEqualTo: location)
                }

                return query
            }

            let ids = items.compactMap { $0.id }
            await fetchAllAnimals(ongIds: ids)

        } catch {
            toast("Erro ao carregar as ONGs", .error)
            print("❌ Fetch error: \(error.localizedDescription)")
            isLoading = false
        }
    }

    private func startInteractionDelay() {
        enableInteractionTask?.cancel()

        isInteractionEnabled = false

        enableInteractionTask = Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            guard !Task.isCancelled else { return }

            await MainActor.run {
                isInteractionEnabled = true
            }
        }
    }
}
