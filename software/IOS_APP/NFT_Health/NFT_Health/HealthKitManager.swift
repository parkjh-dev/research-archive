
import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()
    
    func authorizeHealthKit(_ completion: @escaping (Bool, Error?) -> Void) {
        let healthKitTypes: Set = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in
            if let error = error {
                print("Error while authorizing HealthKit: \(error.localizedDescription)")
            }
            
            completion(success, error)
        }
    }
    
    func fetchRunningDistanceData(_ completion: @escaping (Double?, Error?) -> Void) {
        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            if let result = result, let sum = result.sumQuantity() {
                let total = sum.doubleValue(for: HKUnit.meterUnit(with: .kilo))
                completion(total, nil)
            } else {
                completion(nil, error)
            }
        }
        
        healthStore.execute(query)
    }
}
