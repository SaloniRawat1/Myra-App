import Foundation

class PeriodData {
    
    static let shared = PeriodData()
    
    var periodDays: Set<String> = []
    var lastPeriodStart: Date?
    
    let cycleLength = 28
    let periodLength = 5
    
    private init() {
        load()
    }
    
    // MARK: Toggle Day
    func togglePeriod(on date: Date) {
        let key = format(date)
        
        if periodDays.contains(key) {
            periodDays.remove(key)
        } else {
            periodDays.insert(key)
            lastPeriodStart = date
            autoFillPeriod(from: date)
        }
        
        save()
    }
    
    // MARK: Auto Fill 5 Days
    private func autoFillPeriod(from start: Date) {
        for i in 0..<periodLength {
            if let next = Calendar.current.date(byAdding: .day, value: i, to: start) {
                periodDays.insert(format(next))
            }
        }
    }
    
    // MARK: Check Period Day
    func isPeriodDay(_ date: Date) -> Bool {
        periodDays.contains(format(date))
    }
    
    // MARK: Fertile Window
    func isFertileDay(_ date: Date) -> Bool {
        guard let last = lastPeriodStart else { return false }
        
        guard let ovulation = Calendar.current.date(byAdding: .day, value: 14, to: last) else { return false }
        
        let start = Calendar.current.date(byAdding: .day, value: -2, to: ovulation)!
        let end = Calendar.current.date(byAdding: .day, value: 2, to: ovulation)!
        
        return date >= start && date <= end
    }
    
    // MARK: Save
    private func save() {
        UserDefaults.standard.set(Array(periodDays), forKey: "periodDays")
        UserDefaults.standard.set(lastPeriodStart, forKey: "lastPeriodStart")
    }
    
    // MARK: Load
    private func load() {
        if let saved = UserDefaults.standard.array(forKey: "periodDays") as? [String] {
            periodDays = Set(saved)
        }
        
        lastPeriodStart = UserDefaults.standard.object(forKey: "lastPeriodStart") as? Date
    }
    
    private func format(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
    
    // MARK: - Next Period Prediction
    func nextPredictedDate() -> Date? {
        guard let last = lastPeriodStart else { return nil }
        return Calendar.current.date(byAdding: .day, value: cycleLength, to: last)
    }

    // MARK: - Current Cycle Length
    func currentCycleLength() -> Int? {
        guard let last = lastPeriodStart else { return nil }
        let days = Calendar.current.dateComponents([.day], from: last, to: Date()).day
        return days
    }

    // MARK: - Previous Cycle Length (dummy for now — later we improve)
    func previousCycleLength() -> Int {
        return cycleLength
    }

    
    // MARK: - Cycle Phase
    func getCyclePhase(for date: Date = Date()) -> String {
        
        guard let lastStart = lastPeriodStart else {
            return "No Data"
        }
        
        let calendar = Calendar.current
        
        // days passed since last period
        let days = calendar.dateComponents([.day], from: lastStart, to: date).day ?? 0
        
        // convert into cycle day (1–28)
        let cycleDay = (days % cycleLength) + 1
        
        switch cycleDay {
        case 1...5:
            return "Menstrual Phase"
            
        case 6...13:
            return "Follicular Phase"
            
        case 14:
            return "Ovulation Phase"
            
        case 15...28:
            return "Luteal Phase"
            
        default:
            return "Unknown"
        }
    }

    // MARK: - Cycle Day
    func getCycleDay(for date: Date = Date()) -> Int {
        
        guard let lastStart = lastPeriodStart else { return 0 }
        
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: lastStart, to: date).day ?? 0
        
        return (days % cycleLength) + 1
    }

}
