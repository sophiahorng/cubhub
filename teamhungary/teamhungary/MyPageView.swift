import SwiftUI
import GoogleSignIn

struct MyPageView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var userData: UserData
    @Binding var isLogin: Bool
    @State private var showMapView = false
    
    var body: some View {
        let imagePath = Bundle.main.path(forResource: "bg", ofType: "png")
        let img = UIImage(contentsOfFile: imagePath! )
        NavigationStack {
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
                        Spacer()
                        Button {
                            logout()
                        } label: {
                            Text("logout")
                                .bold()
                                .font(Font.custom("Helvetica Neue", size: 24.0))
                                .padding(20)
                                .foregroundColor(Color.white)
                                .background(Color.purple)
                                .cornerRadius(12)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer(minLength: 100)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
    
    private func logout() {
        GIDSignIn.sharedInstance.signOut()
        isLogin = false
        dismiss()
    }

}