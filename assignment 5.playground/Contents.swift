import Cocoa

// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Drone records recovered from the fleet registry.
let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

/// Hull sensors. These are NOT drones — they never move and never work a shift.
let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

/// Hardware from the original station. You may not add anything to this declaration.
struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================

// MARK: Level 1 · The Power Cell

// Why a class and not a struct here?  ->
//PowerCell - это class , потому что аккумулятором пользуются сразу несколько систем, и он должен быть один на всех. Если одна система потратит заряд, остальные сразу должны это увидеть.
final class PowerCell {
    private var charge: Int
    
    init(charge: Int) {
        if charge < 0 {
            self.charge = 0
        } else if charge > 100 {
            self.charge = 100
        } else {
            self.charge = charge
        }
    }
    
    func level() -> Int {
        return charge
    }
    
    func spend(amount: Int) -> Bool {
        guard amount > 0, charge >= amount else { return false }
        charge -= amount
        return true
    }
    
    func recharge(by amount: Int) {
        guard amount > 0 else { return }
        charge = min(100, charge + amount)
    }
}

// Encapsulation proof (leave this commented, with the compiler error):
// let cell = PowerCell(charge: 50)
// cell.charge = 100
// error: 'charge' is inaccessible due to 'private' protection level


// MARK: Level 2 · The Fleet

// 2.1 What does `final` on runOnce() buy you?  ->
// final нужен для того, чтобы запретить другим классам переписывать этот метод.
class Drone {
    let id: String
    let cell: PowerCell
    
    init(id: String, cell: PowerCell) {
        self.id = id
        self.cell = cell
    }
    
    var powerCost: Int { 10 }
    
    var statusLine: String {
        return "\(id): \(cell.level().powerBar)"
    }
    
    func performTask() -> Int { 0 }
    
    final func runOnce() -> Int {
        guard cell.spend(amount: powerCost) else { return 0 }
        return performTask()
    }
}

// 2.2
final class WelderDrone: Drone {
    override var powerCost: Int { 25 }
    override func performTask() -> Int { 40 }
    
    func weldSeam() -> String {
        return "Seam welded by \(id)"
    }
}

class ScannerDrone: Drone {
    override var powerCost: Int { 10 }
    override func performTask() -> Int { 15 }
    
    override var statusLine: String {
        return super.statusLine + " [scanner]"
    }
}

final class CargoDrone: Drone {
    override var powerCost: Int { 20 }
    override func performTask() -> Int { 25 }
}

// 2.3
func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
    let cell = PowerCell(charge: charge)
    switch kind {
    case "welder":
        return WelderDrone(id: id, cell: cell)
    case "scanner":
        return ScannerDrone(id: id, cell: cell)
    case "cargo":
        return CargoDrone(id: id, cell: cell)
    default:
        print("Warning: Unknown drone kind '\(kind)' for ID '\(id)'. Skipping record.")
        return nil
    }
}

var fleet: [Drone] = []
for record in fleetData {
    if let drone = makeDrone(kind: record.kind, id: record.id, charge: record.charge) {
        fleet.append(drone)
    }
}


// MARK: Level 3 · The Shift

func runShift(_ fleet: [Drone], rounds: Int) -> Int {
    var totalWork = 0
    for _ in 1...rounds {
        for drone in fleet {
            totalWork += drone.runOnce()
        }
    }
    return totalWork
}

let A = runShift(fleet, rounds: 3)

var sumCharge = 0
var readyCount = 0

print("\n--- Fleet Status After Shift ---")
for drone in fleet {
    print(drone.statusLine)
    let currentCharge = drone.cell.level()
    sumCharge += currentCharge
    if currentCharge >= drone.powerCost {
        readyCount += 1
    }
}

let B = sumCharge
let C = readyCount


// MARK: Level 4 · Diagnostics

// 4.1
protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }
    func diagnose() -> String
}

// 4.2
protocol Rechargeable {
    mutating func recharge(by amount: Int)
}

// Why does Drone implement recharge(by:) without `mutating`?  ->
// Drone — это класс, а классы могут изменять свои свойства или свойства своих объектов (PowerCell) без ключевого слова mutating.
extension Drone: Diagnosable, Rechargeable {
    var componentID: String { id }
    
    var statusCode: Int {
        return healthStatusCode(for: cell.level())
    }
    
    func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

struct SensorModule: Diagnosable, Rechargeable {
    let id: String
    var chargeLevel: Int
    
    var componentID: String { id }
    
    var statusCode: Int {
        return healthStatusCode(for: chargeLevel)
    }
    
    mutating func recharge(by amount: Int) {
        guard amount > 0 else { return }
        chargeLevel = min(100, chargeLevel + amount)
    }
}

// 4.3
// Why could [Drone] never have held the sensors?  ->
// [Drone] может хранить только объекты класса Drone или его подклассов, а SensorModule — это структура, не имеющая отношения к иерархии Drone.
func diagnosticsReport(_ components: [Diagnosable]) -> String {
    var report = "=== DIAGNOSTICS REPORT ===\n"
    for comp in components {
        report += comp.diagnose() + "\n"
    }
    return report
}


// MARK: Level 5 · Shared Behaviour

// 5.1 · default diagnose() + the single home of the Health Rule
extension Diagnosable {
    func diagnose() -> String {
        return "\(componentID): code \(statusCode)"
    }
    
    func healthStatusCode(for val: Int) -> Int {
        if val < 20 {
            return 2
        } else if val < 50 {
            return 1
        } else {
            return 0
        }
    }
}

// 5.2 · the beacon you cannot edit
extension LegacyBeacon: Diagnosable {
    var componentID: String { name }
    
    var statusCode: Int {
        return healthStatusCode(for: signalStrength)
    }
    
    func diagnose() -> String {
        return "[LEGACY BEACON] \(componentID): code \(statusCode)"
    }
}

var sensors: [SensorModule] = []
for s in sensorData {
    sensors.append(SensorModule(id: s.id, chargeLevel: s.charge))
}

var allComponents: [Diagnosable] = []
for drone in fleet {
    allComponents.append(drone)
}
for sensor in sensors {
    allComponents.append(sensor)
}
allComponents.append(beacon)

print("\n" + diagnosticsReport(allComponents))

var totalStatusCodeSum = 0
for comp in allComponents {
    totalStatusCodeSum += comp.statusCode
}

let D = totalStatusCodeSum

// 5.3
extension Int {
    var powerBar: String {
        let clamped = Swift.max(0, Swift.min(100, self))
        let hashCount = clamped / 10
        let dotCount = 10 - hashCount
        return String(repeating: "#", count: hashCount) + String(repeating: ".", count: dotCount)
    }
}


// MARK: Level 6 · Incident Reports

/*
Report 1:
- Expectation: Дрон-ремонтник переписывает логику работы под свои задачи.
- Actual behaviour: НЕ КОМПИЛИРУЕТСЯ. Ошибка: Swift требует слово 'override'.
- Language rule: Если подкласс переделывает метод базового класса, обязательно нужно ставить 'override', чтобы Swift понимал, что это сделано специально.
- Fix: Написать 'override func performTask() -> Int'.

Report 2:
- Expectation: Тяжелый сварщик делает смену по-своему и выдает 999 очков.
- Actual behaviour: НЕ КОМПИЛИРУЕТСЯ. Ошибка: нельзя переопределить метод 'runOnce()', потому что он помечен как 'final'.
- Language rule: Если у метода стоит 'final', базовый класс «запрещает» подклассам его изменять.
- Fix: Не трогать 'runOnce()', а переопределить 'performTask()', который как раз и задумывался для изменений.

Report 3:
- Expectation: Вызвать 'weldSeam()' у первого дрона в списке.
- Actual behaviour: НЕ КОМПИЛИРУЕТСЯ. Ошибка: у общего типа 'Drone' нет метода 'weldSeam()'.
- Language rule: Массив хранит элементы с типом [Drone], поэтому компилятор знает только базовые функции Drone. Чтобы добраться до функций конкретного WelderDrone, нужно уточнить тип прямо во время работы программы (downcast).
- Fix: Сделать безопасное приведение через 'as?':
  if let welder = reportFleet[0] as? WelderDrone {
      print(welder.weldSeam())
  }
  (Пояснение: 'as?' возвращает опционал, потому что в массиве на первом месте может лежать не сварщик, а любой другой дрон).

Report 4:
- Expectation: Вывести на экран "thruster T-1".
- Actual behaviour: КОМПИЛИРУЕТСЯ, но печатает стандартную фразу "generic component".
- Language rule: Метод 'label()' написали только в расширении (extension), но забыли занести в сам 'protocol Labelled'. Из-за этого Swift выказывает «дефолтную» версию из расширения (статическая диспетчеризация), а не версию конкретного объекта.
- Fix: Добавить строку 'func label() -> String' внутрь самого 'protocol Labelled'.
*/


// MARK: Finale · Mission Code

let missionCode = "\(A)-\(B)-\(C)-\(D)"
print("MISSION CODE: \(missionCode)")
