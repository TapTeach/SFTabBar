import SwiftUI

struct ColorDemoView: View {
    @State private var selectedColor: Color = .white
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("fun with Colors")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(1)
                    
                    Text("Color Demo")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("This view demonstrates how background elements affect the tab bar's glass effects")
                        .font(.title2)
                        .italic()
                        .foregroundColor(.secondary)
                    Divider()
                        .padding(.vertical, 10)
                    HStack {
                        ColorPicker(selection: $selectedColor, supportsOpacity: true) {
                            Text("Select Background Color")
                        }
                            .padding(.horizontal,4)
                        
                    }
                    .font(.body)
                    .frame(height: 24)
                    .foregroundColor(.primary)
                }
                .padding()
                selectedColor
                    .ignoresSafeArea()
            }
            //.padding()
            .background(.primary.opacity(0.05))
            

        }

    }
}

#Preview {
    ColorDemoView()
}

