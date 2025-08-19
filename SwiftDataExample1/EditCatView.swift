import SwiftUI
import PhotosUI
import SwiftData

struct EditCatView: View {
    @Bindable var cat: CatMeme
    @State private var pickerItem: PhotosPickerItem?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Text("Edit Cat Meme")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Spacer()
                }
                .padding(.bottom, 20)
                
                VStack {
                    if let photoData = cat.photoData, let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 3))
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.gray)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 3))
                    }
                    
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Label("Select Photo", systemImage: "photo.on.rectangle")
                    }
                    .onChange(of: pickerItem) { _, _ in
                        Task {
                            cat.photoData = try await pickerItem?.loadTransferable(type: Data.self)
                        }
                    }
                    
                    Button("Remove Photo") {
                        cat.photoData = nil
                    }
                    .foregroundColor(.red)
                    .disabled(cat.photoData == nil)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
                
                Group {
                    Text("Nickname:")
                        .foregroundColor(.blue)
                    TextField("Nickname", text: $cat.nickname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Breed:")
                        .foregroundColor(.blue)
                    TextField("Breed", text: $cat.breed)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Info:")
                        .foregroundColor(.blue)
                    TextEditor(text: $cat.info)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    
                }
                
                Spacer()
            }
            .padding(20)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: CatMeme.self, configurations: config)
    
    let cat = CatMeme(nickname: "Sample Cat", breed: "Sample Breed", info: "Sample info")
    return EditCatView(cat: cat)
        .modelContainer(container)
}
