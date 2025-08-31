import SwiftUI
import PhotosUI

struct UploadDemoView: View {
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                // Top UI section
                VStack(alignment: .leading, spacing: 8) {
                    Text("fun with Images")
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(.secondary)
                        .tracking(1)
                    Text("Image Upload Demo")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("This view demonstrates how uploaded images affect the tab bar's glass effects")
                        .font(.title2)
                        .italic()
                        .foregroundColor(.secondary)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    HStack {
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Text("Select Image")
                            if selectedImage != nil {
                                Button("Reset") {
                                    selectedImage = nil
                                }
                                .font(.body)
                                .foregroundColor(.pink)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                            }
                            Spacer()
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.title2)
                                .foregroundColor(.pink)
                        }
                        .padding(.horizontal, 4)
                    }
                    .font(.body)
                    .frame(height: 24)
                    .foregroundColor(.primary)
                }
                .padding()
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                        .clipped()
                } else {
                    Image("illus_winesburg")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                        .clipped()
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.2))
//                        .frame(maxWidth: .infinity, minHeight: geometry.size.height)
//                        .clipped()
                }
            }
            .background(.primary.opacity(0.05))
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
    }
}

#Preview {
    UploadDemoView()
}

