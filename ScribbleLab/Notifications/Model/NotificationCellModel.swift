//
//  NotificationCellModel.swift
//  ScribbleLab
//
//  Created by Nevio Hirani on 05.12.23.
//

import Foundation
import SwiftUI

class NotificationCellModel: ObservableObject {
    @Published var name: String = "Test0001"
    @Published var message: String = "You recieved an invitation for Homework-assignment-2023-05-16 from @test02."
}
