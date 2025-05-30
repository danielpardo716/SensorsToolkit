//
//  iOS_SensorsToolkitApp.swift
//  iOS_SensorsToolkit
//
//  Created by Daniel Pardo on 9/19/21.
//

import SwiftUI
import UIKit
import CoreMotion
import Combine
import Foundation


@main
struct iOS_SensorsToolkitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

public class SensorManager : NSObject, ObservableObject {

    private let motionManager: CMMotionManager
    private let altitudeManager: CMAltimeter
    
    //Acceleration variables
    @Published
    var ax: Double = 0.0
    @Published
    var ay: Double = 0.0
    @Published
    var az: Double = 0.0
    @Published
    var axUser: Double = 0.0
    @Published
    var ayUser: Double = 0.0
    @Published
    var azUser: Double = 0.0
    @Published
    var grav: Double = 0.0
    
    //Gyro variables
    @Published
    var gx: Double = 0.0
    @Published
    var gy: Double = 0.0
    @Published
    var gz: Double = 0.0
    @Published
    var pitch: Double = 0.0
    @Published
    var roll: Double = 0.0
    @Published
    var yaw: Double = 0.0
    
    //Magnetometer variables
    @Published
    var mx: Double = 0.0
    @Published
    var my: Double = 0.0
    @Published
    var mz: Double = 0.0
    @Published
    var mxCali: Double = 0.0
    @Published
    var myCali: Double = 0.0
    @Published
    var mzCali: Double = 0.0
    @Published
    var heading: Double = 0.0
    
    //Pressure variable
    @Published
    var pressure: Float = 0.0

    
    deinit {
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopMagnetometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopAccelerometerUpdates()
        altitudeManager.stopRelativeAltitudeUpdates()
    }
    
    public override init() {
        self.motionManager = CMMotionManager()
        self.altitudeManager = CMAltimeter()
        
        self.motionManager.accelerometerUpdateInterval = 1.0 / 8.0
        self.motionManager.gyroUpdateInterval = 1.0 / 8.0
        self.motionManager.magnetometerUpdateInterval = 1.0 / 8.0
        self.motionManager.deviceMotionUpdateInterval = 1.0 / 8.0
        
        UIDevice.current.isProximityMonitoringEnabled = false
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    public func startMotionUpdates() {
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.main) { this, that in
            if let motionData = self.motionManager.deviceMotion {
                self.axUser = motionData.userAcceleration.x
                self.ayUser = motionData.userAcceleration.y
                self.azUser = motionData.userAcceleration.z
                self.grav = motionData.gravity.z
                
                self.pitch = motionData.attitude.pitch
                self.roll = motionData.attitude.roll
                self.yaw = motionData.attitude.yaw

                self.mxCali = motionData.magneticField.field.x
                self.myCali = motionData.magneticField.field.y
                self.mzCali = motionData.magneticField.field.z
                self.heading = motionData.heading
            }
        }
    }
    
    public func startAccelUpdates() {
         // Get the accelerometer data in units of g.
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { this, that in
            if let accelData = self.motionManager.accelerometerData?.acceleration {
                self.ax = accelData.x
                self.ay = accelData.y
                self.az = accelData.z
            }
        }
    }
    
    public func startGyUpdates() {
        motionManager.startGyroUpdates(to: OperationQueue.main) { this, that in
            if let gyData = self.motionManager.gyroData?.rotationRate {
                self.gx = gyData.x
                self.gy = gyData.y
                self.gz = gyData.z
            }
        }
    }

    public func startMagUpdates() {
        motionManager.startMagnetometerUpdates(to: OperationQueue.main) { this, that in
            if let magData = self.motionManager.magnetometerData?.magneticField {
                self.mx = magData.x
                self.my = magData.y
                self.mz = magData.z
            }
        }
    }

    public func startPressUpdates() {
        altitudeManager.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (altitudeData:CMAltitudeData?, error:Error?) in
            self.pressure = altitudeData!.pressure.floatValue
        })
    }
    
    public func startProximity() {
        UIDevice.current.isProximityMonitoringEnabled = true
    }
    public func stopProximity() {
        UIDevice.current.isProximityMonitoringEnabled = false
    }
   
}
