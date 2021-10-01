#!/usr/bin/python

def __lldb_init_module(debugger, dict):
    help = "Available LLDB commands:\n\t- json JSON_STRING or JSON_DATA"

    print(help)

    json_swift_command = """
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
