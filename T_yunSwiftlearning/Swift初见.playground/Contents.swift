//来源:http://wiki.jikexueyuan.com/project/swift/chapter1/02_a_swift_tour.html
//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var hour = 24

var PI = 3.14

var swiftIsFun = true

var boxue = "boxue"

//高级类型
//Tuple
var me = ("Mars", 11, "18144200589@163.com")

me.0
me.1
me.2

//Optional

//常量
let minutes = 60
let fireIsHot = true

//Type inference
var x:Int
var s:String

//print(x) 不能直接用

print("hello,swift")
//简单值
var myVariable = 42
myVariable = 50
let myConstant = 42

let implicitInteger = 70
let implicitDouble = 70.0
let explicitDouble:Double = 70
let p1:Float = 4

//显示转换值
let label = "the width is"
let width = 94
let widthLabel = label + String(width);
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let fruitSummary = "I have \(apples + oranges) pieces of fruits."

//容器
var shoppingList = ["catfish", "water", "tulips","blue paint"]
shoppingList[1] = "bottle of water"
var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
]
occupations["Jayne"] = "Public Relations"
occupations["Malcolm"] = "New Value"
print(occupations)
print(shoppingList)

//空 指定类型和不指定
let emptyArray = [String]()
let emptyDictionary = [String:Float]()
shoppingList = []
occupations = [:]

//控制流
let individualScores = [75, 43, 103, 87, 12]
var teamScore = 0
for score in individualScores {
    
    if score > 50 {
        teamScore += 3
    } else {
        teamScore += 1
    }
}

print(teamScore)

var optionalString: String? = "Hello"
print(optionalString == nil)

var optionalName:String? = "Tyun"
var greeting = "Hello!"
if  let name = optionalName {
    
    greeting = "Hello, \(name)"
}

//?? 操作符来提供一个默认值。如果可选值缺失的话，可以使用默认值来代替。
let nickName: String? = nil
let fullName: String = "John Appleseed"
let informalGreeting = "Hi \(nickName ?? fullName)"

//switch支持任意类型的数据以及各种比较操作——不仅仅是整数以及测试相等。
let vegetable = "red pepper"
switch vegetable {
case "celery":
    print("Add some raisins and make ants on a log.")
case "cucumber", "watercress":
    print("That would make a good tea sandwich.")
case let x where x.hasSuffix("pepper"):
    print("Is it a spicy \(x)?")
default:
    print("Everything tasted good in soup")
}

//for-in来遍历字典，需要两个变量来表示每个键值对。字典是一个无序的集合，所以他们的键和值以任意顺序迭代结束。
let interestingNumbers = [
    "prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]

var largest = 0
var kingString: String = ""

for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            
            largest = number
            kingString = kind
        }
    }
    
}

print(largest, kingString)

//使用while来重复运行一段代码直到不满足条件。循环条件也可以在结尾，保证能至少循环一次。
var n = 2
while n < 100 {
    
    n = n * 2
}
print(n)

var m = 2
repeat {
    m = m * 2
} while m < 100

print(m)

//你可以在循环中使用..<来表示范围。使用..<创建的范围不包含上界，如果想包含的话需要使用...。
var total = 0
for i in 0...4 {
    total += i
}
print(total)

//使用func来声明一个函数，使用名字和参数来调用函数。使用->来指定函数返回值的类型。
func greet (person: String, lauch: String) -> String {

    return "Hello \(person), lauch is \(lauch)."
}

greet(person: "Bob", lauch: "Apple")

//默认情况下，函数使用它们的参数名称作为它们参数的标签，在参数名称前可以自定义参数标签，或者使用 _ 表示不使用参数标签。
func greet (_ person:String, on day:String) ->String{

    return"Hello \(person), today is \(day)."
}

greet("John", on: "Wdnesday")

//使用元组来让一个函数返回多个值。该元组的元素可以用名称或数字来表示。
func calculateStatistics(scores: [Int]) ->(min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0
    
    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }
    
    return(min, max, sum)
}
let statistics = calculateStatistics(scores:[5, 3, 100, 3, 9] )
print(statistics.sum)
print(statistics.2)

//函数可以带有可变个数的参数，这些参数在函数内表现为数组的形式：
func sumOf(numbers: Int...) ->Int {
    var sum = 0
    for number in numbers {
        sum += number
    }
    return sum
}
sumOf()
sumOf(numbers: 42, 589, 12)

func averageOf(numbers: Double...) ->Double {
    var sum:Double = 0
    for number in numbers {
        
        sum += number
    }
    
    return sum / Double(numbers.count)
}

averageOf(numbers: 1, 3, 4, 5)

//函数可以嵌套。被嵌套的函数可以访问外侧函数的变量，你可以使用嵌套函数来重构一个太长或者太复杂的函数。
func returnFifteen() ->Int {
    var y = 10
    func add() {
        y += 5
    }
    
    add()
    return y
}

//函数是第一等类型，这意味着函数可以作为另一个函数的返回值。
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}

//makeIncrementer(6) error
var increment = makeIncrementer()
increment(7)

//函数也可以当做参数传入另一个函数。
func hasAnyMatches(list:[Int], condition: (Int) -> Bool) ->Bool {
    for item in list {
        if condition(item) {
            
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {

    return number < 10
}
var numbers = [22, 13, 73, 12]
hasAnyMatches(list: numbers, condition: lessThanTen)


//函数实际上是一种特殊的闭包:它是一段能之后被调取的代码。闭包中的代码能访问闭包所建作用域中能得到的变量和函数，即使闭包是在一个不同的作用域被执行的 - 你已经在嵌套函数例子中所看到。你可以使用{}来创建一个匿名闭包。使用in将参数和返回值类型声明与闭包函数体进行分离。
let numbersMap = numbers.map({
            (number: Int) -> Int in
            let result =  number
            if ((result % 2) != 0) {
                return 0
            } else {
                return result
            }
            })

print(numbersMap)

//有很多种创建更简洁的闭包的方法。如果一个闭包的类型已知，比如作为一个回调函数，你可以忽略参数的类型和返回值。单个语句闭包会把它语句的值当做结果返回。
let mappedNumbers = numbers.map({ number in 3 * number})
print(mappedNumbers)

//你可以通过参数位置而不是参数名字来引用参数——这个方法在非常短的闭包中非常有用。当一个闭包作为最后一个参数传给一个函数的时候，它可以直接跟在括号后面。当一个闭包是传给函数的唯一参数，你可以完全忽略括号。
let sortedNumbers = numbers.sorted{ $0 > $1}
print(sortedNumbers)

/***********对象和类************/
//使用class和类名来创建一个类。类中属性的声明和常量、变量声明一样，唯一的区别就是它们的上下文是类。同样，方法和函数声明也一样。
class Shape {
    var numberOfSides = 0
    let numberOfSidesContent = 2
    
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
    
    func hardDescription(side:Int) -> String {
        return "A road with \(side) sides."
    }
}

//要创建一个类的实例，在类名后面加上括号。使用点语法来访问实例的属性和方法。
var shape = Shape()
shape.numberOfSides = 7
var shapeDescription = shape.simpleDescription()
var roadDescription = shape.hardDescription(side: 3)

//这个版本的Shape类缺少了一些重要的东西：一个构造函数来初始化类实例。使用init来创建一个构造器。
class NamedShape {
    var numberOfSides: Int = 0
    var name: String
    
    init(name:String) {
        
        self.name = name
    }
    
    func simpleDescription() -> String {
        
        return "A shape with \(numberOfSides) sides."
    }
}
//注意self被用来区别实例变量。当你创建实例的时候，像传入函数参数一样给类传入构造器的参数。每个属性都需要赋值——无论是通过声明（就像numberOfSides）还是通过构造器（就像name）。如果你需要在删除对象之前进行一些清理工作，使用deinit创建一个析构函数。

//子类的定义方法是在它们的类名后面加上父类的名字，用冒号分割。创建类的时候并不需要一个标准的根类，所以你可以忽略父类。子类如果要重写父类的方法的话，需要用override标记——如果没有添加override就重写父类方法的话编译器会报错。编译器同样会检测override标记的方法是否确实在父类中。
class Square: NamedShape {
    var sideLength: Double
    
    init(sideLength:Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }
    
    func area() -> Double {
        return sideLength * sideLength
    }
    
    override func simpleDescription() -> String {
        
        return "A square with sides of length \(sideLength)."
    }
}

let test = Square(sideLength: 5, name: "Square")
test.area()
test.simpleDescription()

class Circle:NamedShape {
    var radius: Float
    
    init(radius: Float, name: String) {
        
        self.radius = radius
        super.init(name: name)
    }
    func area() -> Float {
        
        return Float(PI) * radius * radius
    }
    
    override func simpleDescription() -> String {
        
        return "A cicle with radius \(radius)."
    }
    
}

let circleTest = Circle(radius: 4, name: "圆")
circleTest.area()
circleTest.simpleDescription()

//除了储存简单的属性之外，属性可以有 getter 和 setter 。
class EquilateralTriangle: NamedShape {
    var sideLength: Double = 0.0
    
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }
    
    var perimeter: Double {
        get {
        
            return 3.0 * sideLength
        }
        
        set {
            sideLength = newValue / 3.0
        }
    }
    
    override func simpleDescription() -> String {
        return "An equilateral triagle with sides of length \(sideLength)."
    }
}
var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
print(triangle.perimeter)
triangle.perimeter = 9.9
print(triangle.sideLength)

//在perimeter的 setter 中，新值的名字是newValue。你可以在set之后显式的设置一个名字。

//注意EquilateralTriangle类的构造器执行了三步：
//
//设置子类声明的属性值
//调用父类的构造器
//改变父类定义的属性值。其他的工作比如调用方法、getters 和 setters 也可以在这个阶段完成。

//如果你不需要计算属性，但是仍然需要在设置一个新值之前或者之后运行代码，使用willSet和didSet。
class TriangleAndSquare {
    var triangle: EquilateralTriangle {
    
        willSet {
            square.sideLength = newValue.sideLength
        }
    }
    
    var square:Square {
        willSet {
            triangle.sideLength  = newValue.sideLength
        }
    }
    init(size: Double, name: String) {
        
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}
var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
print(triangleAndSquare.square.sideLength)
print(triangleAndSquare.triangle.sideLength)
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
print(triangleAndSquare.triangle.sideLength)
//处理变量的可选值时，你可以在操作（比如方法、属性和子脚本）之前加?。如果?之前的值是nil，?后面的东西都会被忽略，并且整个表达式返回nil。否则，?之后的东西都会被运行。在这两种情况下，整个表达式的值也是一个可选值。
let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let sideLength = optionalSquare?.sideLength

//枚举和结构体
//使用enum来创建一个枚举。就像类和其他所有命名类型一样，枚举可以包含方法。
enum Rank:Int {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    func simpleDescription() -> String {
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}
let ace = Rank.Ace
let aceRawValue = ace.rawValue

func compareRank(rankA:Rank, rankB:Rank)-> Int {

    if rankA.rawValue > rankB.rawValue {
        
        return 1
    } else if rankA.rawValue < rankB.rawValue {
        return -1
    } else {
        return 0
    }
}

let resultCompare = compareRank(rankA: .King, rankB: .Eight)

//默认情况下，Swift 按照从 0 开始每次加 1 的方式为原始值进行赋值，不过你可以通过显式赋值进行改变。在上面的例子中，Ace被显式赋值为 1，并且剩下的原始值会按照顺序赋值。你也可以使用字符串或者浮点数作为枚举的原始值。使用rawValue属性来访问一个枚举成员的原始值。
//使用init?(rawValue:)初始化构造器在原始值和枚举值之间进行转换。
if let convertedRank = Rank(rawValue: 3) {

    let threeDescription = convertedRank.simpleDescription()
    
}
//枚举的成员值是实际值，并不是原始值的另一种表达方法。实际上，如果没有比较有意义的原始值，你就不需要提供原始值。
enum Suit {
    case Spades, Hearts, Diamonds, Clubs
    func simpleDescription() -> String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    }
    
    func color() -> String {
        
        switch self {
        case .Spades, .Clubs:
            return "black"
        case .Hearts, .Diamonds:
            return "red"
        }
    }
}
let hearts = Suit.Hearts
let heartsDescription = hearts.simpleDescription()
let heartsColor = hearts.color()
//注意，有两种方式可以引用Hearts成员：给hearts常量赋值时，枚举成员Suit.Hearts需要用全名来引用，因为常量没有显式指定类型。在switch里，枚举成员使用缩写.Hearts来引用，因为self的值已经知道是一个suit。已知变量类型的情况下你可以使用缩写。

//一个枚举成员的实例可以有实例值。相同枚举成员的实例可以有不同的值。创建实例的时候传入值即可。实例值和原始值是不同的：枚举成员的原始值对于所有实例都是相同的，而且你是在定义枚举的时候设置原始值。
enum ServerResponse {

    case Result(String, String)
    case Failure(String)
}

let success = ServerResponse.Result("6:00 am", "8:00 pm")
let failure = ServerResponse.Failure("Out of cheese.")

switch success {
case let .Result(sunrise, sunset):
    let serverResponse = "Sunrise is at \(sunrise) and sunset is at \(sunset)."
case let .Failure(message):
    print("Failure... \(message)")
}
//使用struct来创建一个结构体。结构体和类有很多相同的地方，比如方法和构造器。它们之间最大的一个区别就是结构体是传值，类是传引用。
struct Card {
    var rank: Rank
    var suit: Suit
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())."
    }
    
}

let threeOfSpades = Card(rank: .Three, suit: .Spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()

//协议和扩展
protocol ExampleProtocol {
    var simpleDescription: String{ get }
    mutating func adjust()
}

//类、枚举和结构体都可以实现协议。
class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty:Int = 69105
    func adjust() {
        simpleDescription += " Now 100% adjusted."
    }
}
var a = SimpleClass()
a.adjust()
let aDescription = a.simpleDescription

struct simpleStructure:ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    mutating func adjust() {
        simpleDescription += " (adjusted)"
    }
    
}
var b = simpleStructure()
b.adjust()
let bDescription = b.simpleDescription

enum simpleEnum:ExampleProtocol {
    case First, Second
    var simpleDescription: String {
        switch self {
        case .First:
            return "First"
        case .Second:
            return "Second"
        }
    }
    
    mutating func adjust() {
        
        switch self {
        case .First:
            print("1")
        case .Second:
            print("2")
        }
    }
}

var enumConformTest = simpleEnum.First
enumConformTest.simpleDescription
enumConformTest.adjust()
//注意声明SimpleStructure时候mutating关键字用来标记一个会修改结构体的方法。SimpleClass的声明不需要标记任何方法，因为类中的方法通常可以修改类属性（类的性质）。

//使用extension来为现有的类型添加功能，比如新的方法和计算属性。你可以使用扩展在别处修改定义，甚至是从外部库或者框架引入的一个类型，使得这个类型遵循某个协议。
extension Int: ExampleProtocol {
    var simpleDescription: String {
        return "The number \(self)"
    }
    mutating func adjust() {
        self += 42
    }
}
print(7.simpleDescription)
var intExtension = 7
intExtension.adjust()

extension Double: ExampleProtocol {
    var simpleDescription: String {
        return "The number \(self)"
    }
    
    mutating func adjust() {
        
        self += 1.1
    }
    
    mutating func absoluteValue()->Int {
        return Int(self)
    }
}

var doubleExtension: Double = 2.1
doubleExtension.simpleDescription
doubleExtension.adjust()
doubleExtension.absoluteValue()


//你可以像使用其他命名类型一样使用协议名——例如，创建一个有不同类型但是都实现一个协议的对象集合。当你处理类型是协议的值时，协议外定义的方法不可用。
let protocolValue: ExampleProtocol = a
print(protocolValue.simpleDescription)
//print(protocolValue.anotherProperty)
//即使protocolValue变量运行时的类型是simpleClass，编译器会把它的类型当做ExampleProtocol。这表示你不能调用类在它实现的协议之外实现的方法或者属性。

//错误处理
//使用采用Error协议的类型来表示错误
enum PrinterError: Error {
    case OutOfPaper
    case NoToner
    case OnFire
}
//使用throw来抛出一个错误并使用throws来表示一个可以抛出错误的函数。如果在函数中抛出一个错误，这个函数会立刻返回并且调用该函数的代码会进行错误处理。
func send(job:Int, toPrinter priterName: String) throws -> String {
    if priterName == "Never Has Toner" {
        throw PrinterError.NoToner
    }
    return "Job sent"
}
//有多种方式可以用来进行错误处理。一种方式是使用do-catch。在do代码块中，使用try来标记可以抛出错误的代码。在catch代码块中，除非你另外命名，否则错误会自动命名为error。
do {
    let printerResponse = try send(job: 1040, toPrinter: "Never Has Toner")
    print(printerResponse)
} catch {
    print(error)
}

//可以使用多个catch块来处理特定的错误。参照 switch 中的case风格来写catch。
do {
    let printResponse = try send(job: 1440, toPrinter: "Never Has Toner")
    print(printResponse)
} catch PrinterError.OnFire {
    print("I'll just put this over here, with the rest of the fire.")
} catch let printerError as PrinterError {
    print("Printer error: \(printerError).")
} catch {
    print(error)
}

//另一种处理错误的方式使用try?将结果转换为可选的。如果函数抛出错误，该错误会被抛弃并且结果为nil。否则的话，结果会是一个包含函数返回值的可选值。
let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")


//使用defer代码块来表示在函数返回前，函数中最后执行的代码。无论函数是否会抛出错误，这段代码都将执行。使用defer，可以把函数调用之初就要执行的代码和函数调用结束时的扫尾代码写在一起，虽然这两者的执行时机截然不同
var fridgeIsOpen = false
let fridgeContent = ["milk", "eggs", "leftovers"]
func fridgeContains(_ food: String) -> Bool {
    fridgeIsOpen = true
    defer {
        fridgeIsOpen = false
    }
    
    let result = fridgeContent.contains(food)
    return result
}
fridgeContains("milk")
print(fridgeIsOpen)

//泛型 在尖括号里写一个名字来创建一个泛型函数或者类型。
func repeatItem<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
    var result = [Item]()
    for _ in 0..<numberOfTimes {
        result.append(item)
    }
    return result
}
repeatItem(repeating: "knock", numberOfTimes: 4)
//你也可以创建泛型函数、方法、类、枚举和结构体。
enum OptionalVaule<Wrapped> {
    case None
    case Some(Wrapped)
}
var possibleInteger:OptionalVaule<Int> = .None
possibleInteger = .Some(100)
//在类型名后面使用where来指定对类型的需求，比如，限定类型实现某一个协议，限定两个类型是相同的，或者限定某个类必须有一个特定的父类。
func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs:U) -> [Int]
    where T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element {
        var result = [Int]()
        
        for lhsItem in lhs {
            for rhsItem in rhs {
                if lhsItem == rhsItem {
                    result.append(lhsItem as! Int)
                }
            }
        }
        return result
}
anyCommonElements([1, 2, 3, 4, 5, 6, 7], [3, 5, 7])
