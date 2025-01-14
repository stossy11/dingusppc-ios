//
//  ContentView.swift
//  dingusppc-ios
//
//  Created by Stossy11 on 07/01/2025.
//

import SwiftUI
import JPSVolumeButtonHandler

struct ContentView: View {
    @State private var volumeHandler: JPSVolumeButtonHandler?
    init() {
        DispatchQueue.main.async {
            patchMakeKeyAndVisible()
        }
    }
    
    var body: some View {
        VStack {
            Button {
                startDingusPPC()
            } label: {
                Text("launch dingusppc")
            }
        }
        .padding()
        .onAppear {
            let filePath = URL.documentsDirectory.appendingPathComponent("bootrom_instructions.txt")
            
            // Define the content of the file
            let content = "put bootrom file as bootrom.bin"
            
            // Write the content to the file
            do {
                try content.write(to: filePath, atomically: true, encoding: .utf8)
                print("File created at: \(filePath)")
            } catch {
                print("Error creating file: \(error)")
            }
            
            
            
        }
    }
}

#Preview {
    ContentView()
}

var theWindow: UIWindow? = nil
extension UIWindow {
    @objc func wdb_makeKeyAndVisible() {
        if #available(iOS 13.0, *) {
            self.windowScene = (UIApplication.shared.connectedScenes.first! as! UIWindowScene)
        }
        self.wdb_makeKeyAndVisible()
        theWindow = self
        
    }
}


func patchMakeKeyAndVisible() {
    let uiwindowClass = UIWindow.self
    if let m1 = class_getInstanceMethod(uiwindowClass, #selector(UIWindow.makeKeyAndVisible)),
       let m2 = class_getInstanceMethod(uiwindowClass, #selector(UIWindow.wdb_makeKeyAndVisible)) {
        method_exchangeImplementations(m1, m2)
    }
}


func startDingusPPC() {
    DispatchQueue.main.async {
        dingusppcWrapper.run(withArguments: [URL.documentsDirectory.path + "/dingusppc", "-w", URL.documentsDirectory.path, "-b", URL.documentsDirectory.appendingPathComponent("bootrom.bin").path, "--rambank1_size", "256", "--deterministic"])
    }
}


struct DebuggerView: View {
    var body: some View {
        Button {
            dingusppcWrapper.startDebugger()
        } label: {
            Text("Launch Debugger")
        }
    }
}


