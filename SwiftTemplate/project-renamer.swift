#!/usr/bin/swift

//
//  project-renamer.swift
//  SwiftTemplate
//
//  Created by Sonny Fournier on 12/03/2020.
//

// Script forked from https://github.com/appculture/xcode-project-renamer

import Foundation

class XcodeProjectRenamer: NSObject {

    // MARK: - Constants

    struct Color {
        static let Red = "\u{001B}[0;31m"
        static let Green = "\u{001B}[0;32m"
        static let White = "\u{001B}[0;37m"
    }

    static let oldName = "SwiftTemplate"
    static let scriptName = "project-renamer.swift"

    // MARK: - Properties

    let fileManager = FileManager.default
    var processedPaths = [String]()

    let newName: String

    // MARK: - Init

    init(newName: String) {
        self.newName = newName
    }

    // MARK: - API

    func run() {
        print("\n\(Color.Green)------------------------------------------")
        print("\(Color.Green)Rename Xcode Project from [\(XcodeProjectRenamer.oldName)] to [\(newName)]")
        print("\(Color.Green)Current Path: \(fileManager.currentDirectoryPath)")
        print("\(Color.Green)------------------------------------------\n")

        let currentPath = fileManager.currentDirectoryPath

        if validatePath(currentPath) {
            removePods()
            enumeratePath(currentPath)
            reinstallPods()
            uninstallScript()
        } else {
            print("\(Color.Red)Xcode project or workspace with name: [\(XcodeProjectRenamer.oldName)] is not found at current path.")
        }

        print("\n\(Color.Green)------------------------------------------")
        print("\(Color.Green)Xcode Project Rename Finished!")
        print("\(Color.Green)------------------------------------------\n")
    }

    // MARK: - Helpers

    private func validatePath(_ path: String) -> Bool {
        let projectPath = path.appending("/\(XcodeProjectRenamer.oldName).xcodeproj")
        let workspacePath = path.appending("/\(XcodeProjectRenamer.oldName).xcworkspace")
        let isValid = fileManager.fileExists(atPath: projectPath) || fileManager.fileExists(atPath: workspacePath)
        return isValid
    }

    private func enumeratePath(_ path: String) {
        let enumerator = fileManager.enumerator(atPath: path)
        while let element = enumerator?.nextObject() as? String {
            let itemPath = path.appending("/\(element)")
            if !processedPaths.contains(itemPath) && !shouldSkip(element) {
                processPath(itemPath)
            }
        }
    }

    private func processPath(_ path: String) {
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory: &isDir) {
            if isDir.boolValue {
                enumeratePath(path)
            } else {
                updateContentsOfFile(atPath: path)
            }
            renameItem(atPath: path)
        }

        processedPaths.append(path)
    }

    private func shouldSkip(_ element: String) -> Bool {
        guard
            !element.hasPrefix("."),
            !element.contains(".DS_Store"),
            !element.contains("Carthage"),
            !element.contains("Pods"),
            !element.contains("fastlane")
        else { return true }

        let fileExtension = URL(fileURLWithPath: element).pathExtension
        switch fileExtension {
        case "appiconset", "json", "png", "xcuserstate":
            return true
        default:
            return false
        }
    }

    private func updateContentsOfFile(atPath path: String) {
        do {
            let oldContent = try String(contentsOfFile: path, encoding: .utf8)
            if oldContent.contains(XcodeProjectRenamer.oldName) {
                let newContent = oldContent.replacingOccurrences(of: XcodeProjectRenamer.oldName, with: newName)
                try newContent.write(toFile: path, atomically: true, encoding: .utf8)
                print("\(Color.White)-- Updated: \(path)")
            }
        } catch {
            print("\(Color.Red)Error while updating file: \(error.localizedDescription)\n")
        }
    }

    private func renameItem(atPath path: String) {
        do {
            let oldItemName = URL(fileURLWithPath: path).lastPathComponent
            if oldItemName.contains(XcodeProjectRenamer.oldName) {
                let newItemName = oldItemName.replacingOccurrences(of: XcodeProjectRenamer.oldName, with: newName)
                let directoryURL = URL(fileURLWithPath: path).deletingLastPathComponent()
                let newPath = directoryURL.appendingPathComponent(newItemName).path
                try fileManager.moveItem(atPath: path, toPath: newPath)
                print("\(Color.White)-- Renamed: \(oldItemName) -> \(newItemName)")
            }
        } catch {
            print("\(Color.Red)Error while renaming file: \(error.localizedDescription)")
        }
    }

    private func removePods() {
        do {
            let podsPath = "\(fileManager.currentDirectoryPath)/Pods/"
            try fileManager.removeItem(atPath: podsPath)
            print("\(Color.White)-- Removed: \(podsPath)")
        } catch let error {
            print("\(Color.Red)Error while removing Pods/: \(error.localizedDescription)")
        }
    }

    private func reinstallPods() {
        let whichBinPath = "/usr/bin/which"

        guard fileManager.fileExists(atPath: whichBinPath),
            let podBinPath = shell(launchPath: whichBinPath, arguments: ["pod"])?.replacingOccurrences(of: "\n", with: "") else {
            print("\(Color.Red)Error while installing pods")
            return
        }

        print("\(Color.White)-- Install: Pods")
        _ = shell(launchPath: podBinPath, arguments: ["install"])
    }

    private func uninstallScript() {
         do {

            let scriptPath = "\(fileManager.currentDirectoryPath)/\(XcodeProjectRenamer.scriptName)"
            try fileManager.removeItem(atPath: scriptPath)
            print("\(Color.White)-- Removed: \(scriptPath)")
        } catch let error {
            print("\(Color.Red)Error while removing script: \(error.localizedDescription)")
        }
    }

    private func shell(launchPath: String, arguments: [String]) -> String? {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)

        return output
    }
}

let arguments = CommandLine.arguments
if arguments.count == 2 {
    let newName = arguments[1].replacingOccurrences(of: " ", with: "")
    let xpr = XcodeProjectRenamer(newName: newName)
    xpr.run()
} else {
    print("\(XcodeProjectRenamer.Color.Red)Invalid number of arguments.")
    print("\(XcodeProjectRenamer.Color.Red)Usage:   ./\(XcodeProjectRenamer.scriptName) new_project_name")
}
