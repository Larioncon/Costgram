//
//  CalculationResults+CoreDataProperties.swift
//  Costgram
//
//  Created by Chmil Oleksandr on 06.12.2024.
//
//

import Foundation
import CoreData


extension CalculationResults {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalculationResults> {
        return NSFetchRequest<CalculationResults>(entityName: "CalculationResults")
    }

    @NSManaged public var resultGram: String?
    @NSManaged public var resultPercent: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var resultPartOf: String?

}

extension CalculationResults : Identifiable {

}
