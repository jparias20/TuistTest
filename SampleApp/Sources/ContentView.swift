import SwiftUI
import TuistTestLibrary

struct ContentView: View {
    var body: some View {
        Text(LibraryModule.message)
            .foregroundStyle(LibraryModule.color)
    }
}

#Preview {
    ContentView()
}
