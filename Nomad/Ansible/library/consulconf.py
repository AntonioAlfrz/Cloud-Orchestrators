#!/usr/bin/env python
import json
from os import path
from ansible.module_utils.basic import *

def main():
    module = AnsibleModule(
        argument_spec = dict(
            file = dict(required=True),
            path = dict(required=True),
            address = dict(required=True),
            service_name = dict(required=True),
            check_id = dict(required=True),
            check_name = dict(required=True),
            check_http = dict(required=True),
        )
    )

    filename = os.path.join(module.params['path'],module.params['file'])
    # Read
    with open(filename,'r') as data_file:
        data = json.load(data_file)

    # Change
    data['service']['address'] = module.params['address']
    data['service']['name'] = module.params['service_name']
    data['service']['check']['id'] = module.params['check_id']
    data['service']['check']['name'] = module.params['check_name']
    data['service']['check']['http'] = module.params['check_http']

    # Write
    with open(filename, 'w') as f:
         json.dump(data, f)

    module.exit_json(changed=True)

# Execute
if __name__ == '__main__':
   main()
