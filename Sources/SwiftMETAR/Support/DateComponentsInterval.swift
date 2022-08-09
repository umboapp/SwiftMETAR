import Foundation


public class MetarDateInterval: Comparable {
    var start: Date
    var end: Date
    
    var duration: TimeInterval {
        return end.timeIntervalSince1970 - start.timeIntervalSince1970
    }
    
    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }
    
    public static func < (lhs: MetarDateInterval, rhs: MetarDateInterval) -> Bool {
        lhs.duration < rhs.duration
    }
    
    public static func == (lhs: MetarDateInterval, rhs: MetarDateInterval) -> Bool {
        lhs.start == rhs.start && lhs.end == rhs.end
    }
    
    public func contains(_ date: Date) -> Bool {
        start.timeIntervalSince1970 < date.timeIntervalSince1970 && end.timeIntervalSince1970 > date.timeIntervalSince1970
    }
}
/**
 This class is used to replicate the functionality of the Foundation class
 `DateInterval`, but while storing a range of dates as components, rather than a
 timestamp. This class is 100% API-compatible with `DateInterval`.
 */
public struct DateComponentsInterval: Comparable, Hashable, Codable {
    public var start: DateComponents
    public var end: DateComponents
    
    public var dateInterval: MetarDateInterval { MetarDateInterval(start: start.date!, end: end.date!) }
    
    public var duration: TimeInterval { dateInterval.duration }
    
    public init(start: DateComponents, end: DateComponents) {
        self.start = start
        self.end = end
    }
    
    public init(start: DateComponents, duration: TimeInterval) {
        self.start = start
        let end = start.date!.addingTimeInterval(duration)
        self.end = zuluCal.dateComponents(in: zulu, from: end)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        start = try container.decode(DateComponents.self, forKey: .start)
        end = try container.decode(DateComponents.self, forKey: .end)
    }
    
//    public func compare(_ other: DateComponentsInterval) -> ComparisonResult {
//        return dateInterval.compare(other.dateInterval)
//    }
//    
//    public func intersects(_ other: DateComponentsInterval) -> Bool {
//        return dateInterval.intersects(other.dateInterval)
//    }
//
//    public func intersection(with other: DateComponentsInterval) -> DateInterval? {
//        return dateInterval.intersection(with: other.dateInterval)
//    }
//
    public func contains(_ date: Date) -> Bool {
        return dateInterval.contains(date)
    }
    
    public static func == (lhs: DateComponentsInterval, rhs: DateComponentsInterval) -> Bool {
        return lhs.dateInterval == rhs.dateInterval
    }
    
    public static func < (lhs: DateComponentsInterval, rhs: DateComponentsInterval) -> Bool {
        return lhs.dateInterval < rhs.dateInterval
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(start, forKey: .start)
        try container.encode(end, forKey: .end)
    }
    
    private enum CodingKeys: String, CodingKey {
        case start, end
    }
}
