import Cocoa

// MARK: - =================== STARTER CODE ===================

typealias Reading = (sensor: String, value: Int)

func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")


// MARK: - =================== YOUR SOLUTION ===================

// MARK: Level 1 · Decoding Telemetry

// Task 1.1: parseReading
func parseReading(raw: String) -> Reading? {
    guard let parts = splitOnce(raw, by: ":"),
          !parts.0.isEmpty,
          let val = Int(parts.1),
          val >= 0 || parts.0 == "TEMP" else {
        return nil
    }
    return (sensor: parts.0, value: val)
}

// Task 1.2: parseLog
func parseLog(lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var validReadings: [Reading] = []
    var invalid = 0
    
    for line in lines {
        if let reading = parseReading(raw: line) {
            validReadings.append(reading)
        } else {
            invalid += 1
        }
    }
    return (valid: validReadings, invalidCount: invalid)
}


// MARK: Level 2 · Analysis

// Task 2.1: Your own filter
func select(readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
    var result: [Reading] = []
    for r in readings {
        if isIncluded(r) {
            result.append(r)
        }
    }
    return result
}

func values(of readings: [Reading]) -> [Int] {
    var result: [Int] = []
    for r in readings {
        result.append(r.value)
    }
    return result
}

// Task 2.2: stats
func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard !values.isEmpty else { return nil }
    
    var currentMin = values[0]
    var currentMax = values[0]
    var sum = 0
    
    for val in values {
        if val < currentMin { currentMin = val }
        if val > currentMax { currentMax = val }
        sum += val
    }
    let avg = Double(sum) / Double(values.count)
    return (min: currentMin, max: currentMax, average: avg)
}

func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    stats(of: values)
}

// Task 2.3: The Closure Ladder
let parsedTelemetry = parseLog(lines: rawLog).valid

// 1. Full closure syntax with types and return
let sort1 = parsedTelemetry.sorted(by: { (a: Reading, b: Reading) -> Bool in
    return a.value > b.value
})

// 2. Types inferred from context
let sort2 = parsedTelemetry.sorted(by: { a, b in
    return a.value > b.value
})

// 3. Implicit return
let sort3 = parsedTelemetry.sorted(by: { a, b in
    a.value > b.value
})

// 4. Shorthand argument names $0, $1
let sort4 = parsedTelemetry.sorted(by: { $0.value > $1.value })

// 5. Trailing closure
let sort5 = parsedTelemetry.sorted { $0.value > $1.value }


// MARK: Level 3 · Temperature Stabilization

// Task 3.1: Protocols as values
func heatUp(_ temp: Int) -> Int { temp + 5 }
func coolDown(_ temp: Int) -> Int { temp - 3 }
func hold(_ temp: Int) -> Int { temp }

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18 {
        return heatUp
    } else if temp > 24 {
        return coolDown
    } else {
        return hold
    }
}

// Task 3.2: runUntilStable
func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
    var currentTemp = start
    var steps = 0
    
    while (currentTemp < 18 || currentTemp > 24) && steps < maxSteps {
        let proto = chooseProtocol(for: currentTemp)
        currentTemp = proto(currentTemp)
        steps += 1
    }
    let isStable = (currentTemp >= 18 && currentTemp <= 24)
    return (finalTemp: currentTemp, steps: steps, isStable: isStable)
}


// MARK: Level 4 · The Crew

// Task 4.1: oxygenLevel(of:)
func oxygenLevel(of member: CrewMember) -> Int? {
    member.module?.oxygenTank?.level
}

// Task 4.2: status(of:)
func status(of member: CrewMember) -> String {
    guard let mod = member.module else {
        return "\(member.name): no data (open space)"
    }
    
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data (\(mod.name))"
    }
    
    let statusText = level < 20 ? "CRITICAL" : "OK"
    return "\(member.name): \(level)% \(statusText)"
}

// Task 4.3: Oxygen Transfer
@discardableResult
func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
    guard amount > 0 else { return 0 }
    
    let availableInSource = source
    let capacityInTarget = 100 - target
    let actualTransfer = min(amount, min(availableInSource, capacityInTarget))
    
    source -= actualTransfer
    target += actualTransfer
    return actualTransfer
}

// Task 4.4: Evacuation Order
func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
    var foundCrew: [CrewMember] = []
    
    for name in names {
        guard let member = roster[name] else {
            print("Unknown crew member: \(name)")
            continue
        }
        foundCrew.append(member)
    }
    
    let sortedCrew = foundCrew.sorted { $0.priority < $1.priority }
    
    var sortedNames: [String] = []
    for member in sortedCrew {
        sortedNames.append(member.name)
    }
    return sortedNames
}


// MARK: Level 5 · The Saboteur's Logbook

/*
 Ошибки в коде саботажника:
 1. reportOxygen: member.module!.oxygenTank! вызовет crash, если член экипажа в открытом космосе (module == nil) или у модуля нет бака (Dock).
 2. reportOxygen: синтаксическая ошибка — переменная tank не была объявлена перед tank.level.
 3. firstCritical: oxygenLevel(of: member)! упадет с ошибкой, если у члена экипажа нет бака (возвращается nil).
 4. firstCritical: функция возвращает result!, что приводит к crash, если ни у кого нет уровня O2 < 20 (result останется nil).
 5. Логический баг: цикл перезаписывает result последним найденным членом экипажа, вместо того чтобы вернуть первого найденного (firstCritical).
*/

func reportOxygen(for member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no tank data"
    }
    return "\(member.name): \(level)%"
}

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        if let level = oxygenLevel(of: member), level < 20 {
            return member.name
        }
    }
    return nil
}

// MARK: Finale · Launch Code

let logData = parseLog(lines: rawLog)
let codeA = logData.invalidCount

let o2Readings = select(readings: logData.valid) { $0.sensor == "O2" }
let o2Values = values(of: o2Readings)
let o2Stats = stats(of: o2Values)
let codeB = Int(o2Stats?.average ?? 0)

let tempReadings = select(readings: logData.valid) { $0.sensor == "TEMP" }
let tempValues = values(of: tempReadings)
let tempStats = stats(of: tempValues)
let minTemp = tempStats?.min ?? 0
let tempRun = runUntilStable(from: minTemp)
let codeC = tempRun.steps

if let labTank = lab.oxygenTank, let habTank = hab.oxygenTank {
    transferOxygen(from: &labTank.level, to: &habTank.level, amount: 30)
}
let codeD = hab.oxygenTank?.level ?? 0

let launchCode = "\(codeA)-\(codeB)-\(codeC)-\(codeD)"
print("LAUNCH CODE: \(launchCode)")
