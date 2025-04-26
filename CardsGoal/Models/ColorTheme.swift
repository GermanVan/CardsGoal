import UIKit

struct ColorTheme {
    let name: String
    let smallTaskColor: UIColor
    let mediumTaskColor: UIColor
    let globalTaskColor: UIColor
    
    static let themes: [ColorTheme] = [
        ColorTheme(
            name: "Классическая",
            smallTaskColor: UIColor.systemYellow,
            mediumTaskColor: UIColor.systemGreen,
            globalTaskColor: UIColor.systemRed
        ),
        ColorTheme(
            name: "Морская",
            smallTaskColor: UIColor.systemTeal,
            mediumTaskColor: UIColor.systemBlue,
            globalTaskColor: UIColor.systemIndigo
        ),
        ColorTheme(
            name: "Тёплая",
            smallTaskColor: UIColor.systemOrange,
            mediumTaskColor: UIColor.systemPink,
            globalTaskColor: UIColor.systemPurple
        ),
        ColorTheme(
            name: "Монохромная",
            smallTaskColor: UIColor.lightGray,
            mediumTaskColor: UIColor.darkGray,
            globalTaskColor: UIColor.black
        )
    ]
}
