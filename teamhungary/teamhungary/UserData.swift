import Foundation
import UIKit

struct UserData: Hashable {
    let url:URL?
    let uid:String
    let name:String
    let email:String
    
    init(url: URL?, uid: String, name: String, email: String) {
        self.url = url
        self.uid = uid
        self.name = name
        self.email = email
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(uid)
        hasher.combine(name)
        hasher.combine(email)
    }
}
