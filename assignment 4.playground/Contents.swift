import Cocoa

// MARK: - =================== STARTER DATA ===================

func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================

// MARK: Level 1 · The Deck Register

enum Deck: String, CaseIterable {
    case bridge, lab, cargo, medbay, engine

    var evacuationPriority: Int {
        switch self {
        case .bridge: return 1
        case .medbay: return 2
        case .lab: return 3
        case .engine: return 4
        case .cargo: return 5
        }
    }
}

print("--- Level 1.1 ---")
for deck in Deck.allCases {
    print("\(deck.rawValue): priority \(deck.evacuationPriority)")
}

enum AlarmLevel: Int {
    case green = 0, yellow, orange, red

    static func level(forTotalMass mass: Int) -> AlarmLevel {
        let steps = mass / 500
        if steps >= 3 { return .red }
        if let level = AlarmLevel(rawValue: steps) {
            return level
        }
        return .green
    }
}

print("--- Level 1.2 ---")
print("Mass 0: \(AlarmLevel.level(forTotalMass: 0))")
print("Mass 940: \(AlarmLevel.level(forTotalMass: 940))")
print("Mass 4000: \(AlarmLevel.level(forTotalMass: 4000))")


// MARK: Level 2 · The Manifest

enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}

func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)
    if parts.isEmpty { return .unknown(raw: line) }

    let type = parts[0]
    if type == "crate" {
        if parts.count == 3, let id = Int(parts[1]), let mass = Int(parts[2]) {
            return .crate(id: id, massKg: mass)
        }
    } else if type == "container" {
        if parts.count == 3, let mass = Int(parts[2]) {
            return .container(code: parts[1], massKg: mass)
        }
    } else if type == "livestock" {
        if parts.count == 4, let count = Int(parts[2]), let unitMass = Int(parts[3]) {
            return .livestock(species: parts[1], count: count, massPerUnitKg: unitMass)
        }
    }

    return .unknown(raw: line)
}

func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case .crate(_, let massKg): return massKg
    case .container(_, let massKg): return massKg
    case .livestock(_, let count, let massPerUnitKg): return count * massPerUnitKg
    case .unknown: return 0
    }
}

print("--- Level 2.3 ---")
var totalManifestMass = 0
var unknownCount = 0

for line in rawManifest {
    let entry = parseEntry(line)
    totalManifestMass += mass(of: entry)
    if case .unknown = entry {
        unknownCount += 1
    }
}

print("Total mass: \(totalManifestMass) kg, Unknown lines: \(unknownCount)")
let A = totalManifestMass


// MARK: Level 3 · Crew Snapshots

struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

    mutating func breathe(amount: Int) {
        oxygen -= amount
        if oxygen < 0 { oxygen = 0 }
    }

    mutating func move(to deck: Deck) {
        self.deck = deck
    }

    mutating func reviveInMedbay() {
        self = CrewSnapshot(name: self.name, deck: .medbay, oxygen: 100)
    }

    static func rookie(named name: String) -> CrewSnapshot {
        return CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }
}

var crewRosterArray: [CrewSnapshot] = []

print("--- Level 3.2 ---")
for record in crewData {
    if let deck = Deck(rawValue: record.deck) {
        crewRosterArray.append(CrewSnapshot(name: record.name, deck: deck, oxygen: record.oxygen))
    } else {
        print("Warning: Deck '\(record.deck)' non-existent. Skipping \(record.name).")
    }
}
let crewRoster = crewRosterArray

for member in crewRoster {
    print("\(member.name): \(member.deck), O2: \(member.oxygen)")
}

print("--- Level 3.3 ---")

var orig1 = CrewSnapshot(name: "Test1", deck: .bridge, oxygen: 80)
var copy1 = orig1
copy1.move(to: .lab)
print("1. Copy -> Original: \(orig1.deck), Copy: \(copy1.deck)")

func tryToModify(_ snapshot: CrewSnapshot) {
    var copy = snapshot
    copy.breathe(amount: 50)
}
var orig2 = CrewSnapshot(name: "Test2", deck: .cargo, oxygen: 100)
tryToModify(orig2)
print("2. Non-inout -> Before: 100, After: \(orig2.oxygen)")

func modifyInout(_ snapshot: inout CrewSnapshot) {
    snapshot.breathe(amount: 50)
}
var orig3 = CrewSnapshot(name: "Test3", deck: .engine, oxygen: 100)
modifyInout(&orig3)
print("3. Inout -> Before: 100, After: \(orig3.oxygen)")


// MARK: Level 4 · The Teleport Pod

final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    func load(crew: CrewSnapshot) -> Bool {
        if occupant != nil || chargeLevel < 20 { return false }
        occupant = crew
        return true
    }

    func fire() -> CrewSnapshot? {
        if occupant == nil || chargeLevel < 20 { return nil }
        let fired = occupant
        chargeLevel -= 20
        occupant = nil
        return fired
    }
}

print("--- Level 4.2 ---")
let pod1 = TeleportPod(id: "P-1", chargeLevel: 100)

_ = pod1.load(crew: crewRoster[0])
_ = pod1.fire()
print("1. After Timur: \(pod1.chargeLevel)")

_ = pod1.load(crew: crewRoster[1])
_ = pod1.fire()
print("2. After Dana: \(pod1.chargeLevel)")

_ = pod1.load(crew: crewRoster[3])
_ = pod1.fire()
print("3. After Nurlan: \(pod1.chargeLevel)")

_ = pod1.fire()
print("4. After empty fire: \(pod1.chargeLevel)")

let C = pod1.chargeLevel

print("--- Level 4.3 ---")
let podRefA = TeleportPod(id: "RefPod", chargeLevel: 80)
let podRefB = podRefA
podRefB.chargeLevel = 10
print("Class -> podA: \(podRefA.chargeLevel), podB: \(podRefB.chargeLevel)")

var structA = CrewSnapshot(name: "StructTest", deck: .bridge, oxygen: 90)
var structB = structA
structB.oxygen = 10
print("Struct -> structA: \(structA.oxygen), structB: \(structB.oxygen)")


// MARK: Level 5 · Station Systems

final class Station {
    let callSign: String

    var hullIntegrity: Int = 100 {
        willSet {
            print("hullIntegrity will set to \(newValue)")
        }
        didSet {
            if hullIntegrity < 0 { hullIntegrity = 0 }
            else if hullIntegrity > 100 { hullIntegrity = 100 }
        }
    }

    lazy var fullDiagnostics: String = {
        print("Running full scan...")
        return "ALMA-7 status OK"
    }()

    var oxygenByDeck: [Deck: Int] = [:]

    var totalOxygen: Int {
        var sum = 0
        for val in oxygenByDeck.values { sum += val }
        return sum
    }

    var averageOxygen: Int {
        get {
            if oxygenByDeck.isEmpty { return 0 }
            return totalOxygen / oxygenByDeck.count
        }
        set {
            for key in oxygenByDeck.keys {
                oxygenByDeck[key] = newValue
            }
        }
    }

    init(callSign: String, readings: [(deck: String, oxygen: Int)]) {
        self.callSign = callSign
        for reading in readings {
            if let deck = Deck(rawValue: reading.deck) {
                self.oxygenByDeck[deck] = reading.oxygen
            }
        }
    }
}

print("--- Level 5.1 ---")
let station = Station(callSign: "ALMA-7", readings: deckReadings)
let B = station.averageOxygen
print("Starting average oxygen (B): \(B)")

print(station.fullDiagnostics)

print("--- Level 5.2 ---")
station.hullIntegrity = 130
print("hullIntegrity: \(station.hullIntegrity)")
station.hullIntegrity = -40
print("hullIntegrity: \(station.hullIntegrity)")
station.hullIntegrity = 55
print("hullIntegrity: \(station.hullIntegrity)")


// MARK: Level 6 · Incident Reports

print("--- Level 6 ---")

var rosterFix = crewRoster
for i in 0..<rosterFix.count {
    rosterFix[i].oxygen -= 10
}
print("Report 1 Fix -> Roster[0] oxygen: \(rosterFix[0].oxygen)")

let podA_fix = TeleportPod(id: "A", chargeLevel: 100)
let podB_fix = TeleportPod(id: "B", chargeLevel: 100)
podB_fix.chargeLevel = 0
print("Report 2 Fix -> podA chargeLevel: \(podA_fix.chargeLevel)")

struct LogbookFix {
    var entries: [String] = []
    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}
var logbook = LogbookFix()
logbook.add("Entry 1")
print("Report 3 Fix -> Logbook count: \(logbook.entries.count)")

var snapshotFix = CrewSnapshot.rookie(named: "Dana")
snapshotFix.oxygen = 40
let podFix = TeleportPod(id: "B", chargeLevel: 50)
podFix.chargeLevel = 10
print("Report 4 Fix -> Dana O2: \(snapshotFix.oxygen), Pod charge: \(podFix.chargeLevel)")


// MARK: Level 7 · Sealing the Black Box

final class FlightRecorder {
    private(set) var entries: [String] = []
    private(set) var isSealed = false

    func addEntry(_ entry: String) {
        if !isSealed { entries.append(entry) }
    }

    func seal() {
        isSealed = true
    }

    fileprivate func formattedTranscript() -> String {
        var result = "TRANSCRIPT:\n"
        for entry in entries { result += "- \(entry)\n" }
        return result
    }
}

func auditTranscript(of recorder: FlightRecorder) -> String {
    return recorder.formattedTranscript()
}

print("--- Level 7 ---")
let recorder = FlightRecorder()
recorder.addEntry("Flight engine initialized")
print(auditTranscript(of: recorder))
recorder.seal()


// MARK: Final · Integrity Code

let D = AlarmLevel.level(forTotalMass: A).rawValue
let integrityCode = "\(A)-\(B)-\(C)-\(D)"

print("--- INTEGRITY CODE ---")
print("INTEGRITY CODE: \(integrityCode)")
