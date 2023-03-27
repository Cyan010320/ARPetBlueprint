//
//  HKModel.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/11.
//

import Foundation
import HealthKit

func getStepCount(completion: @escaping (Double) -> Void) {
    if HKHealthStore.isHealthDataAvailable() {
        let healthStore = HKHealthStore()
        let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let typesToShare: Set<HKSampleType> = []
        let typesToRead: Set<HKObjectType> = [stepCount]
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if success {
                let calendar = Calendar.current
                let now = Date()
                let startOfDay = calendar.startOfDay(for: .now)
                let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
                let query = HKStatisticsQuery(quantityType: stepCount, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
                    guard let result = result, let sum = result.sumQuantity() else {
                        completion(0) // return 0 if there's an error
                        return
                    }
                    let stepCount = sum.doubleValue(for: HKUnit.count())
                    print("步数：\(stepCount)")
                    completion(stepCount) // return the step count value using the completion handler
                }
                healthStore.execute(query)
            } else {
                //无权限
                print("没有权限")
                completion(0) // return 0 if there's no permission
            }
        }
    } else {
        print("HK不可用！")
        completion(0) // return 0 if HealthKit is not available
    }
}
