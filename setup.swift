#!/usr/bin/swift

//
//  project-renamer.swift
//  SwiftTemplate
//
//  Created by Sonny Fournier on 12/03/2020.
//

// Script adapted from https://github.com/appculture/xcode-project-renamer

import Foundation

// MARK: - Global constants

struct Color {
    static let Red = "\u{001B}[0;31m"
    static let Green = "\u{001B}[0;32m"
    static let White = "\u{001B}[0;37m"
}

let scriptName = "setup.swift"

// MARK: -
class XcodeProjectSetuper: NSObject {

    // MARK: - Constants

    let templateName = "SwiftTemplate"
    let whichBinPath = "/usr/bin/which"

    // MARK: - Properties

    let fileManager = FileManager.default
    var processedPaths = [String]()

    let projectName: String

    // MARK: - Init

    init(projectName: String) {
        self.projectName = projectName
    }

    // MARK: - API

    func run() {
        print("\(Color.Green)\n------------------------------------------")
        print("\(Color.Green)Setup \(projectName) Xcode project")
        print("\(Color.Green)------------------------------------------\n")

        guard validatePath(fileManager.currentDirectoryPath) else {
            print("\(Color.Red)No Xcode project/workspace named [\(templateName)] was found at current path.")
            exit(0)
        }

        checkDependencies()
        removePods()
        print("\(Color.White)-- Rename files and directories")
        getPathToRename(in: fileManager.currentDirectoryPath)
        renameItem(at: fileManager.currentDirectoryPath.appending("/\(templateName)"))
        reinstallPods()
        setupGitHooks()
        openProject()
        autodestruction()

        print("\(Color.Green)\n------------------------------------------")
        print("\(Color.Green)Successfully setup \(projectName) project")
        print("\(Color.Green)------------------------------------------\n")
    }

    // MARK: - Helpers

    private func validatePath(_ path: String) -> Bool {
        let projectPath = path.appending("/\(templateName).xcodeproj")
        let workspacePath = path.appending("/\(templateName).xcworkspace")
        let isValid = fileManager.fileExists(atPath: projectPath) || fileManager.fileExists(atPath: workspacePath)
        return isValid
    }

    private func getPathToRename(in path: String) {
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
                getPathToRename(in: path)
            } else {
                updateContentsOfFile(atPath: path)
            }
            renameItem(at: path)
        }

        processedPaths.append(path)
    }

    private func shouldSkip(_ element: String) -> Bool {
        guard !element.hasPrefix("."),
            !element.contains(".DS_Store"),
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
            if oldContent.contains(templateName) {
                let newContent = oldContent.replacingOccurrences(of: templateName, with: projectName)
                try newContent.write(toFile: path, atomically: true, encoding: .utf8)
            }
        } catch {
            print("\(Color.Red)Error while updating file: \(error.localizedDescription)\n")
        }
    }

    private func renameItem(at path: String) {
        do {
            let oldItemName = URL(fileURLWithPath: path).lastPathComponent
            if oldItemName.contains(templateName) {
                let newItemName = oldItemName.replacingOccurrences(of: templateName, with: projectName)
                let directoryURL = URL(fileURLWithPath: path).deletingLastPathComponent()
                let newPath = directoryURL.appendingPathComponent(newItemName).path
                try fileManager.moveItem(atPath: path, toPath: newPath)
            }
        } catch {
            print("\(Color.Red)Error while renaming file: \(error.localizedDescription)")
        }
    }

    private func removePods() {
        print("\(Color.White)-- Removing pods")

        do {
            let podsPath = "\(fileManager.currentDirectoryPath)/Pods/"
            try fileManager.removeItem(atPath: podsPath)
        } catch let error {
            print("\(Color.Red)Error while removing pods: \(error.localizedDescription)")
        }
    }

    private func reinstallPods() {
        print("\(Color.White)-- Reinstall pods")

        guard let podBinPath = shell(launchPath: whichBinPath,
                                     arguments: ["pod"])?.replacingOccurrences(of: "\n", with: "") else {
            print("\(Color.Red)Error while installing pods")
            return
        }

        _ = shell(launchPath: podBinPath, arguments: ["install"])
    }

    private func setupGitHooks() {
        print("\(Color.White)-- Setup git hooks")

        guard let cpPath = shell(launchPath: whichBinPath,
                                  arguments: ["cp"])?.replacingOccurrences(of: "\n", with: "") else {
            print("\(Color.Red)Error: command 'cp' was not found.")
            exit(0)
        }

        _ = shell(launchPath: cpPath, arguments: [".githooks/*", ".git/hooks/"])
    }

    private func openProject() {
        print("\(Color.White)-- Open project")

        guard let openPath = getPath(for: "open") else {
            print("\(Color.Red)Error: command 'open' was not found.")
            exit(0)
        }

        _ = shell(launchPath: openPath, arguments: ["\(projectName).xcworkspace"])
    }

    private func checkDependencies() {
        print("\(Color.White)-- Check dependencies")

        // Check if which command exist
        guard fileManager.fileExists(atPath: whichBinPath) else {
            print("\(Color.Red)Error: command 'which' was not found.")
            exit(0)
        }

        // Check if SwiftLint is installed
        guard getPath(for: "swiftlint") != nil else {
            if getPath(for: "brew") != nil {
                // If Swiftlint is not installed but brew is
                print("\(Color.Red)Error: SwiftLint is not installed.")
                print("\(Color.Red)To install it, launch the following command in your terminal:")
                print("\(Color.Red)$> brew install swiftlint")
            } else {
                // If Swiftlint is not installed and neither brew
                print("\(Color.Red)Error: this script requires SwiftLint which requires Homebrew to be installed.")
                print("\(Color.Red)To install Homebrew see:")
                print("\(Color.Red)https://brew.sh/")
            }

            exit(0)
        }
    }

    private func getPath(for command: String) -> String? {
        guard let commandPath = shell(launchPath: whichBinPath,
                                      arguments: [command])?.replacingOccurrences(of: "\n", with: "") else {
            return nil
        }

        return commandPath
    }

    private func autodestruction() {
        print("\(Color.White)-- Removing myself")

         do {
            let scriptPath = "\(fileManager.currentDirectoryPath)/\(scriptName)"
            try fileManager.removeItem(atPath: scriptPath)
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

if CommandLine.arguments.count == 2 {
    let projectName = CommandLine.arguments[1].replacingOccurrences(of: " ", with: "")

    XcodeProjectSetuper(projectName: projectName).run()
} else {
    print("\(Color.Red)Invalid number of arguments.")
    print("\(Color.Red)Usage:   ./\(scriptName) MyProjectName")
}
