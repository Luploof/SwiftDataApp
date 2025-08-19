import Foundation
import SwiftData

@Model
class CatMeme {
    var id: UUID
    var nickname: String
    var breed: String
    var info: String
    var photoData: Data?
    
    init(nickname: String = "", breed: String = "", info: String = "", photoData: Data? = nil) {
        self.id = UUID()
        self.nickname = nickname
        self.breed = breed
        self.info = info
        self.photoData = photoData
    }
}
