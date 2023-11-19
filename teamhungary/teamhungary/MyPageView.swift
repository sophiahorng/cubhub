import SwiftUI
import GoogleSignIn

struct MyPageView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var userData: UserData
    
    var body: some View {
        let imagePath = Bundle.main.path(forResource: "bg", ofType: "png")
        let img = UIImage(contentsOfFile: imagePath! )
        ZStack {
            Image(uiImage: img! )
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack (spacing: 30) {
                AsyncImage(url: userData.url)
                    .imageScale(.small)
                    .frame(width: 180, height: 180, alignment: .center)
                    .padding(EdgeInsets(top: 60, leading: 0, bottom: 0, trailing: 0))
                Text(userData.name)
                Text(userData.email)
                Spacer()
                HStack {
                    Button {
                        logout()
                    } label: {
                        Text("logout")
                    }
                    .frame(width: 60, height: 33, alignment: .bottom)
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 0))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 100)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
    
    private func logout() {
        GIDSignIn.sharedInstance.signOut()
        dismiss()
    }
}
