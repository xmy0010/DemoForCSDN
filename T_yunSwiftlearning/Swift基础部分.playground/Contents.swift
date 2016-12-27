//例子来源 http://wiki.jikexueyuan.com/project/swift/chapter2/01_The_Basics.html
//本页包含内容：
/*
 *常量和变量
 *声明常量和变量
 *类型标注
 *常量和变量的命名
 *输出常量和变量
 *注释
 *分号
 *整数
 *整数范围
 *Int
 *UInt
 *浮点数
 *类型安全和类型推断
 *数值型字面量
 *数值型类型转换
 *整数转换
 *数整数和浮点数转换
 *类型别名
 *布尔值
 *元组
 *可选
 *nil
 *if 语句以及强制解析
 *可选绑定
 *隐式解析可选类型
 *错误处理
 *断言
*/
/*Swift 包含了 C 和 Objective-C 上所有基础数据类型，Int表示整型值； Double 和 Float 表示浮点型值； Bool 是布尔型值；String 是文本型数据。 Swift 还提供了三个基本的集合类型，Array ，Set 和 Dictionary ，详见集合类型。*/

/*就像 C 语言一样，Swift 使用变量来进行存储并通过变量名来关联值。在 Swift 中，广泛的使用着值不可变的变量，它们就是常量，而且比 C 语言的常量更强大。在 Swift 中，如果你要处理的值不需要改变，那使用常量可以让你的代码更加安全并且更清晰地表达你的意图。*/

/*除了我们熟悉的类型，Swift 还增加了 Objective-C 中没有的高阶数据类型比如元组（Tuple）。元组可以让你创建或者传递一组数据，比如作为函数的返回值时，你可以用一个元组可以返回多个值。*/

/*Swift 还增加了可选（Optional）类型，用于处理值缺失的情况。可选表示 “那儿有一个值，并且它等于 x ” 或者 “那儿没有值” 。可选有点像在 Objective-C 中使用 nil ，但是它可以用在任何类型上，不仅仅是类。可选类型比 Objective-C 中的 nil 指针更加安全也更具表现力，它是 Swift 许多强大特性的重要组成部分。*/

/*Swift 是一门类型安全的语言，这意味着 Swift 可以让你清楚地知道值的类型。如果你的代码期望得到一个 String ，类型安全会阻止你不小心传入一个 Int 。同样的，如果你的代码期望得到一个 String，类型安全会阻止你意外传入一个可选的 String 。类型安全可以帮助你在开发阶段尽早发现并修正错误。*/
//常量和变量
//常量和变量把一个名字（比如 maximumNumberOfLoginAttempts 或者 welcomeMessage ）和一个指定类型的值（比如数字 10 或者字符串 "Hello" ）关联起来。常量的值一旦设定就不能改变，而变量的值可以随意更改。

//声明常量和变量
//常量和变量必须在使用前声明，用 let 来声明常量，用 var 来声明变量。下面的例子展示了如何用常量和变量来记录用户尝试登录的次数：
let maximumNumberOfLoginAttempts = 10
var currentLoginAttempt = 0
var x = 0.0, y = 0.0, z = 0.0

//类型标注
//当你声明常量或者变量的时候可以加上类型标注（type annotation），说明常量或者变量中要存储的值的类型。如果要添加类型标注，需要在常量或者变量名后面加上一个冒号和空格，然后加上类型名称。
//
//这个例子给 welcomeMessage 变量添加了类型标注，表示这个变量可以存储 String 类型的值：
var welcomMessage: String
welcomMessage = "Hello"
var red, green, blue: Double

//常量和变量的命名
//你可以用任何你喜欢的字符作为常量和变量名，包括 Unicode 字符
let π = 3.141592653
let 你好 = "你好"
let 🐶 = "dog"
//常量与变量名不能包含数学符号，箭头，保留的（或者非法的）Unicode 码位，连线与制表符。也不能以数字开头，但是可以在常量与变量名的其他地方包含数字。一旦你将常量或者变量声明为确定的类型，你就不能使用相同的名字再次进行声明，或者改变其存储的值的类型。同时，你也不能将常量与变量进行互转。
//注意： 如果你需要使用与Swift保留关键字相同的名称作为常量或者变量名，你可以使用反引号（`）将关键字包围的方式将其作为名字使用。无论如何，你应当避免使用关键字作为常量或变量名，除非你别无选择。
var friendlyWelcome = "Hello"
friendlyWelcome = "Bonjour"
print("The current value of friendlyWelcome is \(friendlyWelcome).")

//整数
//整数范围
//你可以访问不同整数类型的 min 和 max 属性来获取对应类型的最小值和最大值：
let minValue = UInt8.min
let maxValue = UInt8.max

//Int
//一般来说，你不需要专门指定整数的长度。Swift 提供了一个特殊的整数类型Int，长度与当前平台的原生字长相同：
//在32位平台上，Int 和 Int32 长度相同。
//在64位平台上，Int 和 Int64 长度相同。
//除非你需要特定长度的整数，一般来说使用 Int 就够了。这可以提高代码一致性和可复用性。即使是在32位平台上，Int 可以存储的整数范围也可以达到 -2,147,483,648 ~ 2,147,483,647 ，大多数时候这已经足够大了。

//浮点数
//浮点数是有小数部分的数字，比如 3.14159 ，0.1 和 -273.15。
//
//浮点类型比整数类型表示的范围更大，可以存储比 Int 类型更大或者更小的数字。Swift 提供了两种有符号浮点数类型：
//
//Double表示64位浮点数。当你需要存储很大或者很高精度的浮点数时请使用此类型。
//Float表示32位浮点数。精度要求不高的话可以使用此类型。
//注意：
//Double精确度很高，至少有15位数字，而Float只有6位数字。选择哪个类型取决于你的代码需要处理的值的范围，在两种类型都匹配的情况下，将优先选择 Double。

let pi  = 3.14159 //推断pi为 Double
let meaningOfLife = 42 //推断为Int
let anotherPi = 42 + 3.14159 //Doule


//数值型字面量
//整数字面量可以被写作：
//
//一个十进制数，没有前缀
//一个二进制数，前缀是0b
//一个八进制数，前缀是0o
//一个十六进制数，前缀是0x
let decimalInteger = 17
let binaryInteger = 0b0001
let octalInteger = 0o21
let hexadecimalInteger = 0x11

//浮点字面量可以是十进制（没有前缀）或者是十六进制（前缀是 0x ）。小数点两边必须有至少一个十进制数字（或者是十六进制的数字）。十进制浮点数也可以有一个可选的指数（exponent)，通过大写或者小写的 e 来指定；十六进制浮点数必须有一个指数，通过大写或者小写的 p 来指定。
//
//如果一个十进制数的指数为 exp，那这个数相当于基数和10^exp的乘积：
//
//1.25e2 表示 1.25 × 10^2，等于 125.0。
//1.25e-2 表示 1.25 × 10^-2，等于 0.0125。
//如果一个十六进制数的指数为exp，那这个数相当于基数和2^exp的乘积：
//
//0xFp2 表示 15 × 2^2，等于 60.0。
//0xFp-2 表示 15 × 2^-2，等于 3.75。
let decimalDouble = 12.1875
let exponentDouble = 1.21875e1
let hexadecimalDouble = 0xC.3p0
//数值类字面量可以包括额外的格式来增强可读性。整数和浮点数都可以添加额外的零并且包含下划线，并不会影响字面量
let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1


//要将一种数字类型转换成另一种，你要用当前值来初始化一个期望类型的新数字，这个数字的类型就是你的目标类型。在下面的例子中，常量twoThousand是UInt16类型，然而常量one是UInt8类型。它们不能直接相加，因为它们类型不同。所以要调用UInt16(one)来创建一个新的UInt16数字并用one的值来初始化，然后使用这个新数字来计算：
let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = twoThousand + UInt16(one)
//SomeType(ofInitialValue) 是调用 Swift 构造器并传入一个初始值的默认方法。在语言内部，UInt16 有一个构造器，可以接受一个UInt8类型的值，所以这个构造器可以用现有的 UInt8 来创建一个新的 UInt16。注意，你并不能传入任意类型的值，只能传入 UInt16 内部有对应构造器的值。不过你可以扩展现有的类型来让它可以接收其他类型的值（包括自定义类型）


//整数和浮点数转换
let three = 3
let pointOneFourOneFiveNine = 0.14159
let pi1 = Double(three) + pointOneFourOneFiveNine
let integerPi = Int(pi1)


//类型别名 类型别名（type aliases）就是给现有类型定义另一个名字。你可以使用typealias关键字来定义类型别名。
typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.min


//布尔值
let orangesAreOrange = true
let turnipsAreDelicious = false
if turnipsAreDelicious {
    print("Mmm, tasty turnips!")
} else {
    print("Eww, turnips Are horrible.")
}
//如果你在需要使用 Bool 类型的地方使用了非布尔值，Swift 的类型安全机制会报错
let i = 1
//if i {
//    报错
//}
if i == 1 {

    //成功
}


//元组
//元组（tuples）把多个值组合成一个复合值。元组内的值可以是任意类型，并不要求是相同类型。
let http404Error = (404, "Not Found")
//http404Error 的类型是 (Int, String), 值是 (404, "Not Found")
//你可以将一个元组的内容分解（decompose）成单独的常量和变量，然后你就可以正常使用它们了：
let (statusCode, StatusMessage) = http404Error
print("The status code is \(statusCode).")
print("The status message is \(StatusMessage).")
//如果你只需要一部分元组值，分解的时候可以把要忽略的部分用下划线（_）标记：
let (justTheStatusCode, _) = http404Error
print("The status code is \(justTheStatusCode).")
//此外，你还可以通过下标来访问元组中的单个元素，下标从零开始：
print("The status code is \(http404Error.0)")
print("The status message is \(http404Error.1)")

//你可以在定义元组的时候给单个元素命名：
let http200Status = (statusCode: 200, description: "OK")
//给元组中的元素命名后，你可以通过名字来获取这些元素的值：
print("The status code is \(http200Status.statusCode)")
print("The status message is \(http200Status.description)")
//元组在临时组织值的时候很有用，但是并不适合创建复杂的数据结构。如果你的数据结构并不是临时使用，请使用类或者结构体而不是元组


//可选类型
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
//convertedNumber 被推测为类型"Int?", 或者类型 "optional Int"
//因为该构造器可能会失败，所以它返回一个可选类型（optional）Int，而不是一个 Int。一个可选的 Int 被写作 Int? 而不是 Int。问号暗示包含的值是可选类型，也就是说可能包含 Int 值也可能不包含值。（不能包含其他任何值比如 Bool 值或者 String 值。只能是 Int 或者什么都没有。）


//nil
//你可以给可选变量赋值为nil来表示它没有值
var serverResponseCode: Int? = 404
// serverResponseCode 包含一个可选的Int值 404
serverResponseCode = nil //现在不包含值
//注意：nil不能用于非可选的常量和变量。如果你的代码中有常量或者变量需要处理值缺失的情况，请把它们声明成对应的可选类型。

var surveyAnswer: String? //自动设置为nil
//注意： Swift 的 nil 和 Objective-C 中的 nil 并不一样。在 Objective-C 中，nil 是一个指向不存在对象的指针。在 Swift 中，nil 不是指针——它是一个确定的值，用来表示值缺失。任何类型的可选状态都可以被设置为 nil，不只是对象类型。

//if 语句以及强制解析
//你可以使用 if 语句和 nil 比较来判断一个可选值是否包含值。你可以使用“相等”(==)或“不等”(!=)来执行比较。
if convertedNumber != nil {
    //如果可选类型有值，它将不等于 nil：
    print("convertedNumber contains some integer value.")
}
//注意： 使用 ! 来获取一个不存在的可选值会导致运行时错误。使用 ! 来强制解析值之前，一定要确定可选包含一个非 nil 的值。



//可选绑定 使用可选绑定（optional binding）来判断可选类型是否包含值，如果包含就把值赋给一个临时常量或者变量。可选绑定可以用在 if 和 while 语句中，这条语句不仅可以用来判断可选类型中是否有值，同时可以将可选类型中的值赋给一个常量或者变量。
var someOptional: String?
if let constantName = someOptional {
    print(1)
}
if let actualNumber = Int(possibleNumber) {
    print("\'\(possibleNumber)\' has an integer value of \(actualNumber)")
} else {
    print("\'\(possibleNumber)\'could not be converted to an integer")
}
//这段代码可以被理解为： “如果 Int(possibleNumber) 返回的可选 Int 包含一个值，创建一个叫做 actualNumber 的新常量并将可选包含的值赋给它。” 如果转换成功，actualNumber 常量可以在 if 语句的第一个分支中使用。它已经被可选类型 包含的 值初始化过，所以不需要再使用 ! 后缀来获取它的值。在这个例子中，actualNumber 只被用来输出转换结果。

//你可以在可选绑定中使用常量和变量。如果你想在if语句的第一个分支中操作 actualNumber 的值，你可以改成 if var actualNumber，这样可选类型包含的值就会被赋给一个变量而非常量。 你可以包含多个可选绑定或多个布尔条件在一个 if 语句中，只要使用逗号分开就行。只要有任意一个可选绑定的值为nil，或者任意一个布尔条件为false，则整个if条件判断为false，这时你就需要使用嵌套 if 条件语句来处理
if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}
if let firstNumber = Int("4") {
    if let secondNumber = Int("42") {
        if firstNumber < secondNumber && secondNumber < 100 {
            print("\(firstNumber) < \(secondNumber) < 100")
        }
    }
}
//注意： 在 if 条件语句中使用常量和变量来创建一个可选绑定，仅在 if 语句的句中(body)中才能获取到值。相反，在 guard 语句中使用常量和变量来创建一个可选绑定，仅在 guard 语句外且在语句后才能获取到值



//隐式解析可选类型
//如上所述，可选类型暗示了常量或者变量可以“没有值”。可选可以通过 if 语句来判断是否有值，如果有值的话可以通过可选绑定来解析值。

//有时候在程序架构中，第一次被赋值之后，可以确定一个可选类型_总会_有值。在这种情况下，每次都要判断和解析可选值是非常低效的，因为可以确定它总会有值。

//这种类型的可选状态被定义为隐式解析可选类型（implicitly unwrapped optionals）。把想要用作可选的类型的后面的问号（String?）改成感叹号（String!）来声明一个隐式解析可选类型。

//当可选类型被第一次赋值之后就可以确定之后一直有值的时候，隐式解析可选类型非常有用。隐式解析可选类型主要被用在 Swift 中类的构造过程中，请参考无主引用以及隐式解析可选属性。

//一个隐式解析可选类型其实就是一个普通的可选类型，但是可以被当做非可选类型来使用，并不需要每次都使用解析来获取可选值
let possibleString: String? = "An optional string."
let forcedString: String = possibleString! //需要感叹号来获取值

let assumedString: String! = "An implicitly unwrapped optional string."
let implicitSting: String = assumedString //不需要感叹号
//你可以把隐式解析可选类型当做一个可以自动解析的可选类型。你要做的只是声明的时候把感叹号放到类型的结尾，而不是每次取值的可选名字的结尾。
//注意：如果你在隐式解析可选类型没有值的时候尝试取值，会触发运行时错误。和你在没有值的普通可选类型后面加一个惊叹号一样。

//你仍然可以把隐式解析可选类型当做普通可选类型来判断它是否包含值
if assumedString != nil {
    print(assumedString)
}

//你也可以在可选绑定中使用隐式解析可选类型来检查并解析它的值：
if let definiteString = assumedString {
    print(definiteString)
}
//注意：如果一个变量之后可能变成nil的话请不要使用隐式解析可选类型。如果你需要在变量的生命周期中判断是否是nil的话，请使用普通可选类型。



//错误处理
//你可以使用 错误处理（error handling） 来应对程序执行中可能会遇到的错误条件。
//相对于可选中运用值的存在与缺失来表达函数的成功与失败，错误处理可以推断失败的原因，并传播至程序的其他部分。
//当一个函数遇到错误条件，它能报错。调用函数的地方能抛出错误消息并合理处理。
func canThrowAnError() throws {
    //这个函数有可能抛出错误
}
//一个函数可以通过在声明中添加throws关键词来抛出错误消息。当你的函数能抛出错误消息时, 你应该在表达式中前置try关键词。
do {
    try canThrowAnError()
    //没有错误消息抛出
} catch {
    //有一个错误消息抛出
}

//一个do语句创建了一个新的包含作用域,使得错误能被传播到一个或多个catch从句。
enum SandwichError: Error {
    case outOfCleanDishes
    case missingIngredients
}

func makeASandwich() throws {
    throw(SandwichError.missingIngredients)
}
func eatASandwich(){

}

do {
    try makeASandwich()
    eatASandwich()
} catch SandwichError.outOfCleanDishes {
    print("outOfCleanDished")
} catch SandwichError.missingIngredients(let ingredients) {
    print(ingredients)
}
//在此例中，makeASandwich()（做一个三明治）函数会抛出一个错误消息如果没有干净的盘子或者某个原料缺失。因为 makeASandwich() 抛出错误，函数调用被包裹在 try 表达式中。将函数包裹在一个 do 语句中，任何被抛出的错误会被传播到提供的 catch 从句中。

//如果没有错误被抛出，eatASandwich() 函数会被调用。如果一个匹配 SandwichError.outOfCleanDishes 的错误被抛出，print("outOfCleanDished")会被调用。如果一个匹配 SandwichError.missingIngredients 的错误被抛出，print(ingredients)会被调用，并且使用 catch 所捕捉到的关联值 [String] 作为参数。

//断言
//可选类型可以让你判断值是否存在，你可以在代码中优雅地处理值缺失的情况。然而，在某些情况下，如果值缺失或者值并不满足特定的条件，你的代码可能没办法继续执行。这时，你可以在你的代码中触发一个 断言（assertion） 来结束代码运行并通过调试来找到值缺失的原因。
//使用断言进行调试

//断言会在运行时判断一个逻辑条件是否为 true。从字面意思来说，断言“断言”一个条件是否为真。你可以使用断言来保证在运行其他代码之前，某些重要的条件已经被满足。如果条件判断为 true，代码运行会继续进行；如果条件判断为 false，代码执行结束，你的应用被终止。

//如果你的代码在调试环境下触发了一个断言，比如你在 Xcode 中构建并运行一个应用，你可以清楚地看到不合法的状态发生在哪里并检查断言被触发时你的应用的状态。此外，断言允许你附加一条调试信息。
//你可以使用全局 assert(_:_:file:line:) 函数来写一个断言。向这个函数传入一个结果为 true 或者 false 的表达式以及一条信息，当表达式的结果为 false 的时候这条信息会被显示：
let age = -3
assert(age <= 0, "A person's age cannot be less than zero")

//何时使用断言

//当条件可能为假时使用断言，但是最终一定要_保证_条件为真，这样你的代码才能继续运行。断言的适用情景：
//
//整数类型的下标索引被传入一个自定义下标实现，但是下标索引值可能太小或者太大。
//需要给函数传入一个值，但是非法的值可能导致函数不能正常执行。
//一个可选值现在是 nil，但是后面的代码运行需要一个非 nil 值。
