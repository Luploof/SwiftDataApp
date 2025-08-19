import SwiftUI
import SwiftData

@main
struct CatMemeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: CatMeme.self)
    }
}
