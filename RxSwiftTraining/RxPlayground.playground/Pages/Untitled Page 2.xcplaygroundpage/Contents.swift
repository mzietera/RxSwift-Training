//: [Previous](@previous)

import Foundation
struct Constants {

}
var str = "Hello, playground"
let testtext = "w[VKDS_F"

func xor(text:String, cipher:String) -> String {
    // Taken from: http://sketchytech.blogspot.de/2014/10/bytes-for-beginners-xor-encryption-and.html

    let textBytes = [UInt8](text.utf8)
    var cipherBytes = [UInt8](cipher.utf8)
    var encrypted = [UInt8]()

    if cipherBytes.count < textBytes.count {
        let cipherExtension = [UInt8](repeating:1, count:textBytes.count - cipherBytes.count)
        cipherBytes.append(contentsOf: cipherExtension)
    }
    // encrypt bytes
    for (index, element) in textBytes.enumerated() {
        encrypted.append(element ^ cipherBytes[index])
    }

    let xored = String(bytes: encrypted, encoding: String.Encoding.utf8) ?? ""

    return xored
}

xor(text: testtext, cipher: String(describing: Constants.self))
xor(text: "r\nVJ\u{10}\u{03}\u{08}@Dd6c`05897g5", cipher: String(describing: Constants.self))

//: [Next](@next)
