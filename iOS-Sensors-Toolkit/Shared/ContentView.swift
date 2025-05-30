///
//  ContentView.swift
//  iOS_SensorsToolkit
//
//  Created by Daniel Pardo on 9/19/21.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var sensor = SensorManager()
    
    var body: some View {
        
        TabView {
            //Tab 1 - Show Sensors
            LazyVStack {
                Spacer()
                Text("iOS Sensors Toolkit").font(.title).fontWeight(.heavy).padding().frame(width: 500.0, height: 60.0).background(Color.blue).foregroundColor(Color.white)
                Spacer()
                
                VStack {
                    Text("Accelerometer").font(.headline).padding(.top)
                    HStack {
                        VStack {
                            Text("With Gravity").font(.subheadline).underline()
                            Text("x: \(9.81*sensor.ax) m/s^2")
                            Text("y: \(9.81*sensor.ay) m/s^2")
                            Text("z: \(9.81*sensor.az) m/s^2")
                        }
                        VStack {
                            Text("User").font(.subheadline).underline()
                            Text("x: \(100*sensor.axUser) cm/s^2")
                            Text("y: \(100*sensor.ayUser) cm/s^2")
                            Text("z: \(100*sensor.azUser) cm/s^2")
                        }
                    }.padding()
                }.border(Color.blue).onAppear(perform: {self.sensor.startAccelUpdates() })
                
                VStack {
                    Text("Magnetometer").font(.headline).padding(.top)
                    HStack {
                        VStack {
                            Text("Raw").font(.subheadline).underline()
                            Text("x: \(sensor.mx) µT")
                            Text("y: \(sensor.my) µT")
                            Text("z: \(sensor.mz) µT")
                        }
                        VStack {
                            Text("Calibrated").font(.subheadline).underline()
                            Text("x: \(sensor.mxCali) µT")
                            Text("y: \(sensor.myCali) µT")
                            Text("z: \(sensor.mzCali) µT")
                            //Text("heading: \(sensor.heading)")
                        }
                    }.padding()
                }.border(Color.blue).onAppear(perform: { self.sensor.startMagUpdates() })
                
                VStack{
                    Text("Gyroscope").font(.headline).padding(.top)
                    HStack {
                        VStack {
                            Text("Rotation Rate").font(.subheadline).underline()
                            Text("x: \(180/Double.pi*sensor.gx)°/s")
                            Text("y: \(180/Double.pi*sensor.gy)°/s")
                            Text("z: \(180/Double.pi*sensor.gz)°/s")
                        }
                        VStack {
                            Text("Attitude").font(.subheadline).underline()
                            Text("pitch: \(180/Double.pi*sensor.pitch)°")
                            Text("roll: \(180/Double.pi*sensor.roll)°")
                            Text("yaw: \(180/Double.pi*sensor.yaw)°")
                        }
                    }.padding()
                }.border(Color.blue).onAppear(perform: {self.sensor.startGyUpdates()} )
                
                VStack {
                    Text("Pressure").font(.headline).padding(.top)
                    //Text("Altitude: \(sensor.altitude)")
                    Text("\(sensor.pressure) kPa").padding()
                }.border(Color.blue).onAppear(perform: { self.sensor.startPressUpdates() })
                
                Spacer()
        }.onAppear(perform: {self.sensor.startMotionUpdates()}).tabItem {Text("Sensors")}.tag(1)
            
            //Tab 2 - Tools
            VStack {
            NavigationView {
                List {
                    NavigationLink(destination: VStack {
                        Text("Level").font(.title)
                        Image("level")
                        Text("\(180-acos(sensor.grav)*180/Double.pi)°").font(.headline)
                        Spacer()
                        Text("Lay phone on surface to check if flat.")
                        }
                    ) { Text("Level") }
                    
                    NavigationLink(destination: VStack {
                        Text("Compass").font(.title)
                            Image("compass")
                        Text("\(sensor.heading)°").font(.headline)
                        Spacer()
                        Text("Rotate phone to read degrees between\nuser and North Pole.").multilineTextAlignment(.center)
                        }
                    ) { Text("Compass") }
                    
                    NavigationLink(destination: VStack {
                        Text("Proximity Sensor Test").font(.title).onAppear(perform: {sensor.startProximity()}).onDisappear(perform: {sensor.stopProximity()})
                        Spacer()
                            Image("proximity").resizable().aspectRatio(contentMode: .fit)
                            Text("Hold hand over sensor shown above")
                            Text("Screen will turn dark when something is close.")
                        Spacer()
                        }
                    ) { Text("Proximity Sensor") }
                    
                    NavigationLink(destination: VStack {
                        Text("System Info").font(.title)
                        List {
                            Text("Device Name: \(UIDevice.current.name)")
                            Text("Model: \(UIDevice.current.model)")
                            Text("OS: \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)")
                            Text("Battery Level: \(100*UIDevice.current.batteryLevel)%")
                        }
                    }) {Text("System Info")}
                }.navigationTitle("Tools")
                
            }.environmentObject(sensor).navigationBarTitle("Tools")
                //Spacer()

            }.tabItem { Text("Tools") }.tag(2)
            
            //Tab 3 - Sources, Name, etc.
            ScrollView {
                    
                Image("UBlogo")
                Text("About").font(.title).padding()
                Text("iOS Sensors Toolkit")
                Text("Developed by Daniel Pardo, Fall 2021")
                Text("For use on iPhone X to read and\nvisualize sensor data from accelerometer, gyroscope, magnetometer, pressure sensor,\nand proximity sensor.")
                    .multilineTextAlignment(.center).padding()
                
                Text("Sources").font(.title2)//.padding()
                VStack {
                    Text("Documentation").font(.subheadline).underline()
                    Text("Swift: https://developer.apple.com/documentation/technologies")
                    Text("CoreMotion: https://developer.apple.com/documentation/coremotion")
                    Text("UIDevice: https://developer.apple.com/documentation/uikit/uidevice")
                }.padding()

                
                VStack {
                    Text("Tutorials").font(.subheadline).underline()
                    Text("SwiftUI: https://www.youtube.com/watch?v=F2ojC6TNwws")
                    Text("Magnetometer: https://stackoverflow.com/questions/58366799/how-do-i-use-core-motion-to-output-magnetometer-data-using-swiftui")
                    Text("Pressure: https://riptutorial.com/ios/example/25116/accessing-barometer-to-get-relative-altitude")
                    Text("Proximity: https://itnext.io/ios-proximity-sensor-as-simple-as-possible-a473df883dc9")
                }.padding()
                
                
            }.tabItem { Text("About") }.tag(4)
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
