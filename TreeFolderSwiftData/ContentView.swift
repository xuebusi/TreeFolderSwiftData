//
//  ContentView.swift
//  TreeFolderSwiftData
//
//  Created by shiyanjun on 2024/9/28.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query private var directories: [Directory]
    @State private var directoryToDelete: Directory?
    
    var body: some View {
        NavigationStack {
            VStack {
                if directories.isEmpty {
                    ContentUnavailableView("No Content", systemImage: "tray.fill")
                } else {
                    List {
                        OutlineGroup(directories.filter({$0.parent == nil}), id: \.id, children: \.directories) { directory in
                            Text(directory.name)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        directoryToDelete = directory
                                        deleteDirectory()
                                    } label: {
                                        Image(systemName: "trash.fill")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                }
                
                Text("使用SwiftData实现树形结构数据持久化并支持级联删除。")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .fontWeight(.regular)
                    .padding(.horizontal)
                
                HStack {
                    Button("添加数据") {
                        generateSampleData()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("删除数据") {
                        try? context.delete(model: Directory.self)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .navigationTitle("树形结构")
        }
    }
    
    private func deleteDirectory() {
        if let directoryToDelete {
            context.delete(directoryToDelete)
        }
    }
    
    private func moveDirectory() {
        
    }
    
    private func generateSampleData() {
        // 顶级目录
        let rootDirectory1 = Directory(name: "工作项目")
        let rootDirectory2 = Directory(name: "家庭文件")

        // 添加子目录
        let projectSub1 = Directory(name: "项目A", parent: rootDirectory1)
        let projectSub2 = Directory(name: "项目B", parent: rootDirectory1)

        let familySub1 = Directory(name: "旅行计划", parent: rootDirectory2)
        let familySub2 = Directory(name: "家庭照片", parent: rootDirectory2)

        // 添加更多子目录
        let subSub1 = Directory(name: "设计文档", parent: projectSub1)
        let subSub2 = Directory(name: "预算", parent: projectSub2)

        let subSub3 = Directory(name: "2023年旅行", parent: familySub1)
        let subSub4 = Directory(name: "2022年照片", parent: familySub2)

        // 将所有目录添加到上下文中
        context.insert(rootDirectory1)
        context.insert(rootDirectory2)
        context.insert(projectSub1)
        context.insert(projectSub2)
        context.insert(familySub1)
        context.insert(familySub2)
        context.insert(subSub1)
        context.insert(subSub2)
        context.insert(subSub3)
        context.insert(subSub4)
    }
}

@Model
class Directory {
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \Directory.parent)
    var directories: [Directory]?
    
    var parent: Directory?
    
    init(name: String, parent: Directory? = nil) {
        self.name = name
        self.parent = parent
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Directory.self, inMemory: true)
}
