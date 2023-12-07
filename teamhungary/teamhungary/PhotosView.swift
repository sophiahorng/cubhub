import SwiftUI
import FirebaseFirestore

struct EventPhotosView: View {
    var eventId: String
    @State private var images: [UIImage] = []

    private var gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    init(eventId: String) {
        self.eventId = eventId
        self.images = []
        self.gridLayout = Array(repeating: .init(.flexible()), count: 3)
    }
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, spacing: 20) {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                }
            }
            .refreshable {
                loadImages()
            }
        }
        .onAppear(perform: loadImages)
        .navigationTitle("Event Photos")
        .padding()
    }

    private func loadImages() {
        FirebaseUtilities.retrieveEventPhotos(eventID: eventId) { fetchedImages in
            DispatchQueue.main.async {
                if let fetchedImages = fetchedImages {
                    self.images = fetchedImages
                }
            }
        }
    }
}

//struct EventPhotosView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventPhotosView(eventId: "yourEventId")
//    }
//}
