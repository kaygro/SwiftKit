//
//  FloatPreferenceTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 25.05.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Foundation

import UIKit
import XCTest
import SwiftKit

class FloatPreferenceTest: XCTestCase {
    
    private let parameters: [Float] = [-10.1234, 0, 10.1234]
    
    private let key = "data"
    
    private var preference: FloatPreference!
    
    override func setUp() {
        super.setUp()
        
        preference = FloatPreference(key: key)
        preference.delete()
    }
    
    func testSetValue_parametrizedValues_persistCorrectValue() {
        for parameter in parameters {
            preference.value = parameter
            
            let savedValue = NSUserDefaults.standardUserDefaults().floatForKey(key)
            XCTAssertEqual(parameter, savedValue)
        }
    }
    
    func testGetValue_parametrizedValues_returnsSavedValue() {
        for parameter in parameters {
            preference.value = parameter
            
            XCTAssertEqual(parameter, preference.value)
        }
    }
    
    func testDelete_customDefaultValue_valueReturnsDefaultValue() {
        let defaultValue: Float = 10.1
        preference = FloatPreference(key: key, defaultValue: defaultValue)
        preference.value = 0
        
        preference.delete()
        
        XCTAssertEqual(defaultValue, preference.value)
    }
    
    func testExists_existingValue_returnsTrue() {
        preference.value = 0
        
        XCTAssertTrue(preference.exists)
    }
    
    func testExists_nonexistingValue_returnsFalse() {
        preference.delete()
        
        XCTAssertFalse(preference.exists)
    }
    
    func testExists_existingValueOfDifferentType_returnsFalse() {
        StringPreference(key: key).value = "Value of wrong type"
        
        XCTAssertFalse(preference.exists)
    }
    
    func testValue_changeOfValue_firesEventWithCorrectInput() {
        let value: Float = 10.1
        var eventData: EventData<FloatPreference, Float>? = nil
        preference.onValueChange.registerClosure { data in
            eventData = data
        }
        
        preference.value = value
        
        XCTAssertNotNil(eventData)
        XCTAssertTrue(eventData!.input == value)
    }
    
}