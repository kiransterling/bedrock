#!/usr/bin/env python3

"""
Support for provisioning individual blueprints via a provided identifier.

Usage: blueprint [-t <template_key>] <apply|destroy>

e.g.

* blueprint bastion apply
* blueprint bastion destroy # use template key of same name as blueprint
"""
import argparse
import os
from os.path import expanduser

import docker


def init_path(path):
    os.makedirs(expanduser(f'~/.bedrock/{path}'), exist_ok=True)


def append_env(environment, env_var):
    if env_var in os.environ:
        environment.append(f'{env_var}={os.environ[env_var]}')


def apply_blueprint(name, key, action, action_args, extra_volumes, extra_config):
    print(f'Apply blueprint: {name}/{key} [{action}]')

    init_path(f'{name}/{key}')

    client = docker.from_env()
    environment = [
        f'TF_BACKEND_KEY={name}/{key}',
        f'AWS_ACCESS_KEY_ID={os.environ["AWS_ACCESS_KEY_ID"]}',
        f'AWS_SECRET_ACCESS_KEY={os.environ["AWS_SECRET_ACCESS_KEY"]}',
        f'AWS_DEFAULT_REGION={os.environ["AWS_DEFAULT_REGION"]}',
    ]

    # Append optional environment variables..
    for env_var in ['AWS_SESSION_TOKEN', 'TF_STATE_BUCKET', 'TF_ARGS', 'http_proxy', 'https_proxy', 'no_proxy']:
        append_env(environment, env_var)

    # Append openstack environment variables..
    for env_var in ['OS_AUTH_URL', 'OS_TENANT_ID', 'OS_TENANT_NAME', 'OS_USERNAME', 'OS_PASSWORD', 'OS_REGION_NAME',
                    'OS_ENDPOINT_TYPE', 'OS_IDENTITY_API_VERSION']:
        append_env(environment, env_var)

    # Append digitalocean environment variables..
    for env_var in ['DIGITALOCEAN_TOKEN', 'SPACES_ACCESS_KEY_ID', 'SPACES_SECRET_ACCESS_KEY']:
        append_env(environment, env_var)

    # Append rancher environment variables..
    for env_var in ['RANCHER_URL', 'RANCHER_ACCESS_KEY', 'RANCHER_SECRET_KEY']:
        append_env(environment, env_var)

    # if config:
    #     for item in config:
    #         if isinstance(config[item], list):
    #             config_string = '["%s"]' % '","'.join(config[item])
    #             environment.append(f'TF_VAR_{item}={config_string}')
    #         else:
    #             environment.append(f'TF_VAR_{item}={config[item]}')

    if extra_config:
        for cnf in extra_config:
            cargs = cnf.split('=')
            environment.append(f'TF_VAR_{cargs[0]}={cargs[1]}')

    volumes = {
        expanduser(f'~/.bedrock/{name}/{key}'): {
            'bind': '/work',
            'mode': 'rw'
        }
    }

    if extra_volumes:
        for volume in extra_volumes:
            vargs = volume.split(':')
            volumes[vargs[0]] = {
                'bind': vargs[1],
                'mode': 'ro'
            }

    action_string = ' '.join([action] + action_args)

    try:
        container = client.containers.run(f"bedrock/{name}", action_string, privileged=True, network_mode='host',
                                          remove=True, environment=environment, volumes=volumes, tty=True, detach=True)
        logs = container.logs(stream=True)
        for log in logs:
            print(log.decode('utf-8'), end='')
    except KeyboardInterrupt:
        print(f"Aborting {name}..")
        container.stop()


def main():
    parser = argparse.ArgumentParser(description='Bedrock Blueprint Tool.')
    parser.add_argument('-t', '--tag', metavar='<blueprint_tag>',
                        help='optional tag for blueprint instance (defaults to same as blueprint name)')
    parser.add_argument('-v', '--volumes', metavar='<path:volume>', nargs='+',
                        help='additional volumes mounted to support blueprints')
    parser.add_argument('-c', '--config', metavar='<key=value>', nargs='+',
                        help='additional configuration to support blueprints')
    parser.add_argument('blueprint', metavar='<blueprint_id>',
                        help='name of the blueprint to apply')
    parser.add_argument('action', metavar='<command>',
                        choices=['version', 'init', 'workspace', 'plan', 'apply', 'destroy', 'import', 'remove', 'taint', 'output', 'force-unlock', 'export'],
                        help='blueprint action (possible values: %(choices)s)', nargs='?', default='init')
    parser.add_argument('action_args', metavar='<action_args>',
                        help='additional arguments for specific actions', nargs='*')

    args = parser.parse_args()
    blueprint_key = args.tag if args.tag is not None else args.blueprint

    apply_blueprint(args.blueprint, blueprint_key, args.action, args.action_args, args.volumes, args.config)


if __name__ == "__main__":
    main()
