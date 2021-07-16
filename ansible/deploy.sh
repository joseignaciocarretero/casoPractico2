#!/bin/bash

ansible-playbook -i hosts playbooks/01_deploy_common.yml
ansible-playbook -i hosts playbooks/02_deploy_nfs.yml
ansible-playbook -i hosts playbooks/03_deploy_kubernetes.yml
ansible-playbook -i hosts playbooks/04_deploy_configureKubernetes.yml
ansible-playbook -i hosts playbooks/05_deploy_ingress.yml
ansible-playbook -i hosts playbooks/06_deploy_adduser.yml
ansible-playbook -i hosts playbooks/07_deploy_app.yml
