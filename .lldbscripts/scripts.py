#!/usr/bin/python

def __lldb_init_module(debugger, dict):
    help = "Available LLDB commands:\n\t- json JSON/Data\n\t- validate UITableView/UICollectionView\n\t- ats"

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

        if let tableView = input as? UITableView {
            print("UITableViewDelegate: \((tableView.delegate != nil) ? "Set" : "Not set").")
            print("UITableViewDataSource: \((tableView.dataSource != nil) ? "Set" : "Not set").")
            
            print("Registered cell classes: \(tableView.value(forKey: "_cellClassDict") ?? "Not set").")
            print("Registered nibs: \(tableView.value(forKey: "_nibMap") ?? "Not set").")
        } else if let collectionView = input as? UICollectionView {
            print("UITableViewDelegate: \((collectionView.delegate != nil) ? "Set" : "Not set").")
            print("UITableViewDataSource: \((collectionView.dataSource != nil) ? "Set" : "Not set").")
            
            print("Registered cell classes: \(collectionView.value(forKey: "_cellClassDict") ?? "Not set").")
            print("Registered nibs: \(collectionView.value(forKey: "_nibMap") ?? "Not set").")
        } else {
            print("Unsupported operation.")
        }
    """

    validate_lldb_command = "command regex validate 's/(.+)/expr {} /'".format(validate_swift_command)
    debugger.HandleCommand(validate_lldb_command)

    ats_swift_command = """
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