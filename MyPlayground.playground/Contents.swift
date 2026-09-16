import Cocoa

//Easy
var fruits: [String] = ["Apple", "Banana", "Kiwi", "Orange", "Mango"]
print(fruits[2])

var favnumber: Set<Int> = [1,3,5,7,9]
favnumber.insert(13)
print(favnumber)

var languages: [String: Int] = ["Python": 1991, "Swift": 2014, "Java": 1995]
print(languages["Swift"]!)

var colors: [String] = ["Red", "Green", "Blue", "Yellow"]
colors[1] = "Purple"
print(colors)

// Medium
let a: Set<Int> =  [1, 2, 3, 4]
let b: Set<Int> = [3, 4, 5, 6]
let intersection = a.intersection(b)
print(intersection)

var studentscore: [String:Int] = ["Nariman": 85, "Adel": 92, "Temirlan": 78]
studentscore.updateValue(95, forKey: "Sarbi")
print(studentscore)

let firstArray: [String] = ["apple", "banana"]
let secondArray: [String] = ["cherry", "kiwi"]
let mergedArray = firstArray + secondArray
print(mergedArray)

//Hard
var countrypopulation: [String: Int] = ["Kazakhstan": 20000000, "Japan": 125000000]
countrypopulation["France"] = 68000000
print(countrypopulation)

let animals1: Set<String> = ["cat", "dog"]
let animals2: Set<String> = ["dog", "mouse"]
let unionset = animals1.union(animals2)
let finalset = unionset.subtracting(animals2)
print(finalset)

let grades: [String: [Int]] = ["Adel": [90,95,88] , "Nari": [80,85,90]]
print(grades["Adel"]![1])
