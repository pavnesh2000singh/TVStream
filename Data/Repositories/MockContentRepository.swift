import Foundation

struct MockContentRepository: ContentRepository {
    private let delay: Duration
    private let shouldFail: Bool
    private let shouldReturnEmpty: Bool

    init(
        delay: Duration = .milliseconds(450),
        shouldFail: Bool = false,
        shouldReturnEmpty: Bool = false
    ) {
        self.delay = delay
        self.shouldFail = shouldFail
        self.shouldReturnEmpty = shouldReturnEmpty
    }

    func fetchFeaturedContent() async throws -> [StreamContent] {
        try await fetchHomeSections().flatMap(\.items)
    }

    func fetchHomeSections() async throws -> [ContentSection] {
        try await Task.sleep(for: delay)

        if shouldFail {
            throw MockContentRepositoryError.unavailable
        }

        if shouldReturnEmpty {
            return []
        }

        return Self.sections
    }

    func fetchMovieDetails(id: String) async throws -> MovieDetails {
        try await Task.sleep(for: delay)

        if shouldFail {
            throw MockContentRepositoryError.unavailable
        }

        guard let movie = Self.allMovies.first(where: { $0.id == id }) else {
            throw MockContentRepositoryError.notFound
        }

        return MovieDetails(
            movie: movie,
            cast: Self.castMembers(for: movie),
            similarMovies: try await fetchSimilarMovies(for: id)
        )
    }

    func fetchSimilarMovies(for id: String) async throws -> [StreamContent] {
        let selectedMovie = Self.allMovies.first { $0.id == id }
        let selectedGenres = Set(selectedMovie?.genres ?? [])

        return Self.allMovies
            .filter { $0.id != id }
            .sorted { first, second in
                let firstScore = Set(first.genres).intersection(selectedGenres).count
                let secondScore = Set(second.genres).intersection(selectedGenres).count
                return firstScore > secondScore
            }
            .prefix(8)
            .map { $0 }
    }

    func searchContent(query: String) async throws -> [StreamContent] {
        try await Task.sleep(for: delay)

        if shouldFail {
            throw MockContentRepositoryError.unavailable
        }

        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalizedQuery.isEmpty else { return [] }

        return Self.allMovies.filter { movie in
            movie.title.lowercased().contains(normalizedQuery)
                || movie.subtitle.lowercased().contains(normalizedQuery)
                || movie.description.lowercased().contains(normalizedQuery)
                || movie.genres.contains { $0.lowercased().contains(normalizedQuery) }
                || movie.cast.contains { $0.lowercased().contains(normalizedQuery) }
        }
    }

    func fetchSearchSuggestions(query: String) async throws -> [String] {
        try await Task.sleep(for: .milliseconds(120))

        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalizedQuery.isEmpty else { return [] }

        let titles = Self.allMovies.map(\.title)
        let genres = Set(Self.allMovies.flatMap(\.genres)).sorted()
        let cast = Set(Self.allMovies.flatMap(\.cast)).sorted()

        return (titles + genres + cast)
            .filter { $0.lowercased().contains(normalizedQuery) }
            .prefix(6)
            .map { $0 }
    }

    func fetchTrendingKeywords() async throws -> [String] {
        try await Task.sleep(for: .milliseconds(150))
        return ["Sci-Fi", "Action", "Drama", "Mystery", "Comedy", "Thriller", "2026", "Crime"]
    }
}

enum MockContentRepositoryError: LocalizedError {
    case unavailable
    case notFound

    var errorDescription: String? {
        switch self {
        case .unavailable:
            "Mock content is temporarily unavailable."
        case .notFound:
            "Movie details could not be found."
        }
    }
}

private extension MockContentRepository {
    static var allMovies: [StreamContent] {
        sections.flatMap(\.items)
    }

    static let sections: [ContentSection] = [
        ContentSection(id: "trending", title: "Trending", items: [
            movie("1", "Midnight Signal", "A missing astronaut sends one final transmission.", ["Sci-Fi", "Mystery"], 2026, "TV-14", nil, "27374D", "C84B31", "antenna.radiowaves.left.and.right"),
            movie("2", "Northline", "A detective follows a trail through frozen border towns.", ["Crime", "Thriller"], 2025, "TV-MA", nil, "1B2430", "4E8FB9", "snowflake"),
            movie("3", "Afterglow", "Four friends rebuild their lives after a citywide blackout.", ["Drama"], 2024, "TV-14", nil, "3D2C3E", "D07E59", "sunset.fill"),
            movie("4", "The Last Harbor", "A smuggler protects a family stranded at sea.", ["Action"], 2026, "PG-13", nil, "203A43", "E0A458", "ferry.fill")
        ]),
        ContentSection(id: "popular", title: "Popular", items: [
            movie("5", "Redline District", "A courier races through a city split by rival crews.", ["Action", "Crime"], 2025, "TV-MA", nil, "45171D", "D72638", "bolt.car.fill"),
            movie("6", "Orbit Nine", "A station crew discovers they are not alone.", ["Sci-Fi"], 2023, "PG-13", nil, "17213A", "6C7FD8", "circle.hexagongrid.fill"),
            movie("7", "Glass Crown", "A royal fixer uncovers a conspiracy inside the palace.", ["Drama"], 2024, "TV-14", nil, "2E2238", "C7A35A", "crown.fill"),
            movie("8", "Deep Current", "A rescue diver enters a flooded research facility.", ["Thriller"], 2026, "PG-13", nil, "12343B", "3CAEA3", "water.waves")
        ]),
        ContentSection(id: "continue", title: "Continue Watching", items: [
            movie("9", "Station 42", "Episode 6", ["Sci-Fi"], 2025, "TV-14", 0.62, "202A44", "6A8DFF", "play.tv.fill"),
            movie("10", "Paper Trails", "Episode 3", ["Mystery"], 2024, "TV-14", 0.35, "3C2F2F", "D99A5B", "doc.text.magnifyingglass"),
            movie("11", "Harbor Lights", "Episode 8", ["Drama"], 2026, "TV-PG", 0.78, "183A37", "7CCBA2", "light.beacon.max.fill"),
            movie("12", "Long Way Home", "Episode 2", ["Drama"], 2023, "TV-14", 0.18, "292B2F", "B0B7C3", "road.lanes")
        ]),
        ContentSection(id: "action", title: "Action", items: [
            movie("13", "Steel Run", "An ex-driver takes one impossible job.", ["Action"], 2025, "PG-13", nil, "202020", "D94A38", "flame.fill"),
            movie("14", "Vector Strike", "A tactical unit tracks a weaponized drone network.", ["Action", "Thriller"], 2026, "TV-MA", nil, "192B33", "4CA1AF", "scope"),
            movie("15", "No Safe Exit", "A witness fights through a locked-down tower.", ["Action"], 2024, "R", nil, "332020", "C9483A", "figure.run"),
            movie("16", "Blacktop Kings", "Street racers pull a high-stakes rescue.", ["Action"], 2023, "PG-13", nil, "252525", "F2B544", "car.fill")
        ]),
        ContentSection(id: "comedy", title: "Comedy", items: [
            movie("17", "Roommates Again", "Old friends share a tiny apartment and bigger problems.", ["Comedy"], 2025, "TV-PG", nil, "314137", "E7C66B", "house.fill"),
            movie("18", "The Backup Plan", "A substitute teacher becomes a local celebrity.", ["Comedy"], 2024, "PG", nil, "38412F", "B8D477", "person.3.fill"),
            movie("19", "Office Hours", "A quiet workplace turns into a startup circus.", ["Comedy"], 2026, "TV-14", nil, "23313D", "7BC6D3", "briefcase.fill"),
            movie("20", "Weekend Rules", "A family reunion goes spectacularly off-script.", ["Comedy"], 2023, "PG-13", nil, "43362F", "E19755", "party.popper.fill")
        ]),
        ContentSection(id: "drama", title: "Drama", items: [
            movie("21", "Small Fires", "A journalist returns home to face an old story.", ["Drama"], 2025, "TV-14", nil, "3B2F36", "C66A6A", "newspaper.fill"),
            movie("22", "Blue Valley", "A coach and player rebuild after a lost season.", ["Drama", "Sports"], 2024, "PG", nil, "26394A", "6BA4D8", "sportscourt.fill"),
            movie("23", "Quiet Rooms", "Three families cross paths inside a city hospital.", ["Drama"], 2026, "TV-14", nil, "323A42", "A8B2BD", "cross.case.fill"),
            movie("24", "Letters From June", "A box of letters changes two generations.", ["Drama", "Romance"], 2023, "PG", nil, "3E303C", "D996B3", "envelope.fill")
        ])
    ]

    static func movie(
        _ id: String,
        _ title: String,
        _ subtitle: String,
        _ genres: [String],
        _ year: Int,
        _ rating: String,
        _ progress: Double?,
        _ primaryHexColor: String,
        _ secondaryHexColor: String,
        _ symbolName: String
    ) -> StreamContent {
        StreamContent(
            id: id,
            title: title,
            subtitle: subtitle,
            genres: genres,
            year: year,
            rating: rating,
            runtime: runtime(for: genres),
            description: description(for: title, subtitle: subtitle, genres: genres),
            cast: castNames(for: title),
            progress: progress,
            artworkStyle: ArtworkStyle(
                primaryHexColor: primaryHexColor,
                secondaryHexColor: secondaryHexColor,
                symbolName: symbolName
            )
        )
    }

    static func runtime(for genres: [String]) -> String {
        if genres.contains("Drama") {
            return "2h 04m"
        }

        if genres.contains("Comedy") {
            return "1h 42m"
        }

        if genres.contains("Action") {
            return "1h 56m"
        }

        return "1h 49m"
    }

    static func description(for title: String, subtitle: String, genres: [String]) -> String {
        let genreText = genres.joined(separator: ", ").lowercased()
        return "\(subtitle) This \(genreText) title blends cinematic scale with character-driven tension, built for a premium streaming night."
    }

    static func castNames(for title: String) -> [String] {
        let names = [
            "Maya Rao",
            "Elias Stone",
            "Nora Kim",
            "Julian Cross",
            "Sofia Vale",
            "Theo Mercer"
        ]

        let offset = abs(title.hashValue) % names.count
        return Array((names + names).dropFirst(offset).prefix(4))
    }

    static func castMembers(for movie: StreamContent) -> [CastMember] {
        movie.cast.enumerated().map { index, name in
            CastMember(
                id: "\(movie.id)-cast-\(index)",
                name: name,
                role: ["Lead", "Supporting", "Director", "Creator"][index % 4],
                artworkStyle: ArtworkStyle(
                    primaryHexColor: movie.artworkStyle.secondaryHexColor,
                    secondaryHexColor: movie.artworkStyle.primaryHexColor,
                    symbolName: "person.fill"
                )
            )
        }
    }
}
