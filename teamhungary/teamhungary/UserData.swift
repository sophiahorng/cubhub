import Foundation
import UIKit
struct UserData: Hashable {
    let url:URL?
    let uid:String
    let name:String
    let email:String
    let gradYear: String
    let bio: String
    let igprof: String
    let school: String
    let major: String
    
    init(url: URL?, uid: String, name: String, email: String, gradYear: String, bio: String, igprof: String, school: String, major: String) {
        self.url = url
        self.uid = uid
        self.name = name
        self.email = email
        self.gradYear = gradYear
        self.bio = bio
        self.igprof = igprof
        self.school = school
        self.major = major
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(uid)
        hasher.combine(name)
        hasher.combine(email)
        hasher.combine(gradYear)
        hasher.combine(igprof)
        hasher.combine(school)
        hasher.combine(bio)
        hasher.combine(major)
    }
}
class UserDataObservable: ObservableObject {
    @Published var userData: UserData = UserData(url: nil, uid: "", name: "", email: "", gradYear: "", bio: "", igprof: "", school: "", major: "")
}
