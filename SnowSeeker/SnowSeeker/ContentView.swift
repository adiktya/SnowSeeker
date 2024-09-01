import SwiftUI

enum SortOrder {
    case `default`, alphabetical, byCountry
}

struct ContentView: View {
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @StateObject var favorites = Favorites()
    
    @State private var searchText = ""

    @State private var isShowingSortingOptions = false
    @State private var sortOrder = SortOrder.default
    
    var filteredResorts: [Resort] {
            if searchText.isEmpty {
                return resorts
            } else {
                return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
    

    var sortedResorts: [Resort] {
        
        switch sortOrder {
            
        case .`default`:
            return filteredResorts
        case .alphabetical:
            return filteredResorts.sorted { $0.name < $1.name }
        case .byCountry:
            return filteredResorts.sorted { $0.country < $1.country }
        }
    }
    
    var body: some View {
        NavigationView {
            List(sortedResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {

                    ResortsView(resorts: resorts, resort: resort)
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search here for a resort")
            
            .toolbar {
                Button {
                    isShowingSortingOptions = true
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
            }
            .confirmationDialog("Sorting order", isPresented: $isShowingSortingOptions) {
                Button("Default") { sortOrder = .default }
                Button("Alphabetical") { sortOrder = .alphabetical }
                Button("By country") { sortOrder = .byCountry }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Sort by:")
            }
            
            WelcomeView()
        }
        .environmentObject(favorites)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

