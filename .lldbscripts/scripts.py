#!/usr/bin/python

def __lldb_init_module(debugger, dict):
    help = """Available LLDB commands:
- (lldb) json String/Data - prints JSON representation of String or Data instances
- (lldb) validate UITableView/UICollectionView - performs validation of UITableView or UICollectionView instances
- (lldb) ats - check whether NSAppTransportSecurity is present in Info.plist
- (lldb) descr Class/Struct - print description of a struct or class
- (lldb) br set --name objc_exception_throw - set Objective-C exceptions breakpoint
- (lldb) br set --name swift_willThrow - set Swift errors breakpoint
- (lldb) br set --name UIViewAlertForUnsatisfiableConstraints - set unsatisfiable layout constraints breakpoint
"""
    print(help)

    json_swift_command = """
        let input = %1
        let output: Any
        do {
            if let input = input as? String,
               let jsonObject = input.data(using: .utf8) {
                output = try JSONSerialization.jsonObject(with: jsonObject,
                                                          options: [])
            } else if let input = input as? Data {
                output = try JSONSerialization.jsonObject(with: input,
                                                          options: [])
            } else {
                print("Unsupported format.")
                return
            }
            
            let json = try JSONSerialization.data(withJSONObject: output,
                                                  options: [.prettyPrinted])
            
            print(String(data: json, encoding: .utf8)!)
        } catch {
            print("Error occured: \(error.localizedDescription)")
        }
    """

    json_lldb_command = "command regex json 's/(.+)/expr {} /'".format(json_swift_command)
    debugger.HandleCommand(json_lldb_command)

    validate_swift_command = """
        extension UITableView {
            
            @objc open override func value(forUndefinedKey key: String) -> Any? {
                return nil
            }
        }

        extension UICollectionView {
            
            @objc open override func value(forUndefinedKey key: String) -> Any? {
                return nil
            }
        }

        let input = %1

        if let view = input as? UIView {
            let usesAutolayout = view.translatesAutoresizingMaskIntoConstraints == false
            print("Uses auto layout: \(usesAutolayout ? "Yes" : "No").")

            if let tableView = input as? UITableView {
                print("UITableViewDelegate: \((tableView.delegate != nil) ? "Set" : "Not set").")
                print("UITableViewDataSource: \((tableView.dataSource != nil) ? "Set" : "Not set").")
                
                print("Registered cell classes: \(tableView.value(forKey: "_cellClassDict") ?? "Not set").")
                print("Registered nibs: \(tableView.value(forKey: "_nibMap") ?? "Not set").")
            } else if let collectionView = input as? UICollectionView {
                print("UICollectionViewDelegate: \((collectionView.delegate != nil) ? "Set" : "Not set").")
                print("UICollectionViewDataSource: \((collectionView.dataSource != nil) ? "Set" : "Not set").")
                print("UICollectionViewDataSourcePrefetching: \((collectionView.prefetchDataSource != nil) ? "Set" : "Not set").")
                
                print("Registered cell classes: \(collectionView.value(forKey: "_cellClassDict") ?? "Not set").")
                print("Registered nibs: \(collectionView.value(forKey: "_nibMap") ?? "Not set").")
            } else {
                print("Unsupported operation.")
            }
        }
    """

    validate_lldb_command = "command regex validate 's/(.+)/expr {} /'".format(validate_swift_command)
    debugger.HandleCommand(validate_lldb_command)

    ats_swift_command = """
        import UIKit

        if let infoPlistFile = Bundle.main.url(forResource: "Info", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistFile)
                if let properties = try PropertyListSerialization.propertyList(from: infoPlistData,
                                                                               options: [],
                                                                               format: nil) as? [String: Any] {
                    print("Apple Transport Security: \(properties["NSAppTransportSecurity"] ?? "Not set.")")
                }
            } catch {
                print("Error occured: \(error.localizedDescription)")
            }
        } else {
            print("Info.plist file was not found.")
        }
    """

    ats_lldb_command = "command alias ats expr -l Swift -O -- {}".format(ats_swift_command)
    debugger.HandleCommand(ats_lldb_command)

    descr_swift_command = """
        let input = %1

        let mirroredObject = Mirror(reflecting: input)
        let description = NSMutableString()
        description.append("\(type(of: input)):\\n")
        
        if !mirroredObject.children.isEmpty {
            for (_, attribute) in mirroredObject.children.enumerated() {
                if let propertyName = attribute.label {
                    description.append("Property: \(propertyName), Value: \(attribute.value)\\n")
                }
            }

            print("\(description)")
        } else {
            print("No properties.")
        }
    """

    descr_lldb_command = "command regex descr 's/(.+)/expr {} /'".format(descr_swift_command)
    debugger.HandleCommand(descr_lldb_command)