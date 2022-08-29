//
//  File.swift
//  swift_knowledge
//
//  Created by benwang on 2022/8/19.
//

import Foundation

class Storage {

    var manager: FileManager { .default }

    func store(file: URL) {

        if let path = generate(file: file),
           let data = try? Data(contentsOf: file, options: .alwaysMapped) {
            do {
                try data.write(to: path)
            } catch {
                print("error: \(error)")
            }
        } else {
            print("failure")
        }
    }

    func read(file: URL) -> Data? {
        let path = generate(file: file)
        return try? Data(contentsOf: file, options: .alwaysMapped)
    }

    func generate(file: URL) -> URL? {
        let root = manager.urls(for: .cachesDirectory, in: .userDomainMask).first
        let dir = root?.appendingPathComponent("bbc", isDirectory: true)

        if !manager.fileExists(atPath: dir!.path) {
            try? manager.createDirectory(at: dir!, withIntermediateDirectories: true)
        }

        return dir?.appendingPathComponent(file.lastPathComponent)
    }
}
