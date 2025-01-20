//
//  ContentView.swift
//  dingusppc-ios
//
//  Created by Stossy11 on 07/01/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var binAndRomFiles: [String] = []
    @State private var otherFiles: [String] = []
    
    @State private var addedBinorRomFile: String = ""
    
    @State private var addedOtherFiles: [String] = []
    
    @State var pathExtentions: [String: [String]] = [
        "bin": ["bin", "rom"],
        "cdr": ["iso", "cdr"],
        "img": ["img", "hda"],
    ]

    init() {
        DispatchQueue.main.async {
            patchMakeKeyAndVisible()
        }
    }
    
    var body: some View {
        VStack {
            Button {
                var diskImagesPath: [String] = []
                var cdrImagesPath: [String] = []
                for image in addedOtherFiles {
                    let image = URL(string: image)!
                    if image.lastPathComponent.hasSuffix(".cdr") || image.lastPathComponent.hasSuffix(".iso") {
                        cdrImagesPath.append(image.path)
                    }
                    
                    if image.lastPathComponent.hasSuffix(".img") || image.lastPathComponent.hasSuffix(".hda") {
                        diskImagesPath.append(image.path)
                    }
                }
                
                
                startDingusPPC(addedBinorRomFile.isEmpty ? nil : addedBinorRomFile, diskImagesPath, cdrImagesPath)
            } label: {
                Text("launch dingusppc")
            }
            
            List {
                Section(header: Text("Bootrom files (.bin, .ROM)")) {
                    ForEach(binAndRomFiles, id: \.self) { file in
                        
                        
                        Button {
                            //                 .map { $0.lastPathComponent }
                            let url = URL(string: file)!.lastPathComponent
                            
                            
                            if url == "bootrom.bin" {
                                addedBinorRomFile = ""
                            } else {
                                addedBinorRomFile = file
                            }
                        } label: {
                            HStack {
                                Text(URL(string: file)!.lastPathComponent)
                                Spacer()
                                if addedBinorRomFile == (URL(string: file)!.lastPathComponent == "bootrom.bin" ? "" : "file") {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
                Section(header: Text("Disk or CD files (.img, .hda, .iso, .cdr)")) {
                    ForEach(otherFiles, id: \.self) { file in
                        Button {
                            // Extract the file extension
                            let fileExtension = URL(string: file)!.pathExtension.lowercased()
                            
                            // Check if the file matches any group in pathExtentions
                            if let matchingKey = pathExtentions.first(where: { $0.value.contains(fileExtension) })?.key {
                                // If already selected, remove it
                                if addedOtherFiles.contains(where: { $0 == file }) {
                                    addedOtherFiles.removeAll(where: { $0 == file })
                                } else {
                                    // Remove any previously selected files of the same group
                                    addedOtherFiles.removeAll(where: { existingFile in
                                        if let existingExtension = URL(string: existingFile)?.pathExtension.lowercased(),
                                           let existingKey = pathExtentions.first(where: { $0.value.contains(existingExtension) })?.key {
                                            return existingKey == matchingKey
                                        }
                                        return false
                                    })
                                    // Add the new file
                                    addedOtherFiles.append(file)
                                }
                            }
                        } label: {
                            HStack {
                                Text(URL(string: file)!.lastPathComponent)
                                Spacer()
                                if addedOtherFiles.contains(where: { $0 == file }) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            let filePath = URL.documentsDirectory.appendingPathComponent("bootrom_instructions.txt")
            let content = "put bootrom file as bootrom.bin"
            
            do {
                try content.write(to: filePath, atomically: true, encoding: .utf8)
                print("File created at: \(filePath)")
            } catch {
                print("Error creating file: \(error)")
            }
            
            loadFileLists()
        }
    }
    
    func loadFileLists() {
        let directoryURL = URL.documentsDirectory
        do {
            let files = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            binAndRomFiles = files.filter { file in
                guard let extensions = pathExtentions["bin"] else { return false }
                let lowercasedName = file.lastPathComponent.lowercased()
                return extensions.contains(file.pathExtension.lowercased()) &&
                       lowercasedName != "nvram.bin" &&
                       lowercasedName != "pram.bin"
            }.map(\.path)
            
            otherFiles = files.filter { file in
                guard let extensions = pathExtentions["cdr"], let extensions2 = pathExtentions["img"]  else { return false }
                return extensions.contains(file.pathExtension.lowercased()) || extensions2.contains(file.pathExtension.lowercased())
            }.map(\.path)
            
        } catch {
            print("Error loading files: \(error)")
        }
    }
}

func startDingusPPC(_ bootromPath: String? = nil, _ diskPath: [String]? = nil, _ cdrPath: [String]? = nil) {
    var arguments: [String] = [URL.documentsDirectory.path + "/dingusppc", "-w", URL.documentsDirectory.path]
    
    if let bootromPath = bootromPath {
        arguments.append("-b")
        arguments.append(bootromPath)
    } else {
        arguments.append("-b")
        arguments.append(        URL.documentsDirectory.appendingPathComponent("bootrom.bin").path)
    }
    
    if let cdrPaths = cdrPath {
        for cdrPath in cdrPaths {
            arguments.append("--cdr_img")
            arguments.append(cdrPath)
        }
    }
    
    if let diskPaths = diskPath {
        for diskPath in diskPaths {
            arguments.append("--hdd_img")
            arguments.append(diskPath)
        }
    }
    print(arguments)
    
    
    // [URL.documentsDirectory.path + "/dingusppc", "-w", URL.documentsDirectory.path, "-b", URL.documentsDirectory.appendingPathComponent("bootrom.bin").path, "--rambank1_size", "256"]
    
    
    DispatchQueue.main.async {
        dingusppcWrapper.run(withArguments: arguments)
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




struct DebuggerView: View {
    var body: some View {
        Button {
            dingusppcWrapper.startDebugger()
        } label: {
            Text("Launch Debugger")
        }
    }
}


