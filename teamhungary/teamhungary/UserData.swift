import Foundation
import UIKit
struct UserData: Hashable {
    let url:URL?
    let uid:String
    let name:String
    let email:String
    let gradYear: String
    let igprof: String
    let school: String
    
    init(url: URL?, uid: String, name: String, email: String, gradYear: String, igprof: String, school: String) {
        self.url = url
        self.uid = uid
        self.name = name
        self.email = email
        self.gradYear = gradYear
        self.igprof = igprof
        self.school = school
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(uid)
        hasher.combine(name)
        hasher.combine(email)
        hasher.combine(gradYear)
        hasher.combine(igprof)
        hasher.combine(school)
    }
}
class UserDataObservable: ObservableObject {
    @Published var userData: UserData = UserData(url: nil, uid: "", name: "", email: "", gradYear: "", igprof: "", school: "")
}
