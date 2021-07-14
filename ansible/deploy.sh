#!/bin/bash

# añadir tantas líneas como sean necesarias para el correcto despligue
#ansible-playbook -i hosts -l XXXX playbook
ansible-playbook -i hosts playbooks/01_deploy_common.yml
ansible-playbook -i hosts playbooks/02_deploy_nfs.yml
ansible-playbook -i hosts playbooks/03_deploy_kubernetes.yml
ansible-playbook -i hosts playbooks/04_deploy_configureKubernetes.yml
ansible-playbook -i hosts playbooks/06_deploy_ingress.yml
ansible-playbook -i hosts playbooks/07_deploy_adduser.yml
ansible-playbook -i hosts playbooks/deploy_webapplication.yml
