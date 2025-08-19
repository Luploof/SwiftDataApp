import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \CatMeme.nickname, order: .forward) var catMemes: [CatMeme]
    
    @State var catsToEdit: [CatMeme] = []
    
    func addSamples() {
        guard let image1 = UIImage(named: "OM"),
              let image2 = UIImage(named: "angryCat"),
              let imageData1 = image1.pngData(),
              let imageData2 = image2.pngData() else { return }
        
        let c1 = CatMeme(nickname: "OM", breed: "Бродяга", info: "Интересный мем созданный в 2023", photoData: imageData1)
        let c2 = CatMeme(nickname: "Angry cat", breed: "Сиамский", info: "Злой котик", photoData: imageData2)
        modelContext.insert(c1)
        modelContext.insert(c2)
        try? modelContext.save()
    }
    
    func deleteCats(_ indexSet: IndexSet) {
        for index in indexSet {
            let catToDelete = catMemes[index]
            modelContext.delete(catToDelete)
        }
    }
    
    func addNewCat() {
        let newCat = CatMeme(nickname: "New Cat", breed: "Unknown", info: "Add info")
        modelContext.insert(newCat)
        catsToEdit.append(newCat)
    }
    
    var body: some View {
        NavigationStack(path: $catsToEdit) {
            VStack {
                HStack {
                    Button("Add samples", systemImage: "photo", action: addSamples)
                        .padding(.leading, 20)
                    Spacer()
                    Button("Add new", systemImage: "plus", action: addNewCat)
                        .foregroundColor(.green)
                        .padding(.trailing, 20)
                }
                
                List {
                    ForEach(catMemes) { cat in
                        NavigationLink(value: cat) {
                            HStack {
                                if let photoData = cat.photoData, let uiImage = UIImage(data: photoData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(cat.nickname)
                                        .font(.headline)
                                    Text(cat.breed)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()

                            }
                        }
                    }
                    .onDelete(perform: deleteCats)
                }
                .listStyle(.plain)
                .navigationDestination(for: CatMeme.self, destination: EditCatView.init)
            }
            .navigationTitle("Cat Memes")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: CatMeme.self)
}
