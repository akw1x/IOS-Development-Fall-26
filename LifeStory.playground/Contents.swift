import Cocoa

var firstName: String = "Adel"
var lastName: String = "Kikbay"
var birthYear: Int = 2007
var isStudent: Bool = true
var height: Double = 1.68
var homeCity: String = "Astana"

let currentYear: Int = 2026
let age: Int = currentYear - birthYear

var hobby: String = "Singning and dancing"
var numberOfHobbies: Int = 2
var favoriteNumber: Int = 1
var isHobbyCreative: Bool = true
var favoriteGenreOfFilm: String = "Romantic and Comedy"

let lifeStory: String = """
My name is \(firstName) \(lastName). I am \(age) years old, born in \(birthYear) in \(homeCity).
Currently, my student status is \(isStudent). My height is \(height) meters.

My favorite hobby is \(hobby), which is creative: \(isHobbyCreative).
I have \(numberOfHobbies) hobbies in total, my favorite book genre is \(favoriteGenreOfFilm), and my favorite number is \(favoriteNumber).
"""

print(lifeStory)
