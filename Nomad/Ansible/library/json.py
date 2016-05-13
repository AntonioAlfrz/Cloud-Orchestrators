#!/usr/bin/env python
import json
from os import path

def main():
    module = AnsibleModule(
        argument_spec = dict(
            file = dict(required=True),
            path = dict(required=True),
            url = dict(required=True),
            key = dict(required=True, choices=['node_name', 'name']),
            name = dict(required=True),
            node_class = dict(choices=['Public', 'Private'])
        )
    )

    filename = os.path.join(module.params['path'],module.params['file'])
    # Read
    with open(filename,'r') as data_file:
        data = json.load(data_file)

    key = module.params['key']
    if key not in data:
        module.fail_json(msg="No key: "+key)

    # Change
    data["bind_addr"] = module.params['url']
    data[key] = module.params['name']

    if 'client' in data:
        data['client']['node_class'] = module.params['node_class']

    # Write
    with open(filename, 'w') as f:
         json.dump(data, f)

    module.exit_json(changed=True)


# Execute
from ansible.module_utils.basic import *
if __name__ == '__main__':
   main()
