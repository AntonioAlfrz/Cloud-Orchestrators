#!/usr/bin/env python
import json
from sys import argv

def main():
    module = AnsibleModule(
        argument_spec = dict(
            path = dict(required=True),
            name = dict(required=True, choices=['node_name', 'name'])
        )
    )
    filename = modules.params['path']
    # Read
    with open(filename,'r') as data_file:
        data = json.load(data_file)

    # Change
    data["bind_addr"] = {{ ansible_default_ipv4.address }}
    data[module.params['name']] = {{ansible_nodename}}

    # Write
    with open(filename, 'w') as f:
         json.dump(data, f)

    module.exit_json(changed=True)
    module.fail_json(msg="Something fatal happened")

# Execute
from ansible.module_utils.basic import *
if __name__ == '__main__':
   main()
