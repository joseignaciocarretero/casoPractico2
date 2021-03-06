# Pasos para trabajar con Azure Cli
1. Creación de cuenta education  en azure con cuenta unir
2. He optado por trabajar desde azure cli, directamente desde azure. Abrir shell(cli) de azure desde la misma web
3. Configuramos la subscripción y creamos el service principal
4. Autenticación en azure con terraform, se ponen los datos obtenidos en la creación del servicio principal y la configuración de la subscripción: como el subscriptionid, client_id, client_secret y el tenant_id

# Pasos creación infraestructura y despliegue de la aplicación
1. Al trabajar directamente desde azure, ya viene instalado ansible y terraform en su cli. Si no se trabajara desde el propio cli de azure, sino desde una máquina local, por ejemplo, habría que instalarse ansible, y terraform.
En mi caso, tanto la creación de la infraestructura en azure como el despliegue, lo ejecutaré desde la propia máquina de azure. 
   - Aunque ya venía instalada una versión de ansible, he tenido que instalarla desde el repo epel-release de esta forma:
       - dnf install epel-release -y
       - dnf install ansible git tree jq -y
2. Bajarse el repo: git clone https://github.com/joseignaciocarretero/casoPractico2
3. Creamos la key para poder acceder a los nodos por ssh: ssh-keygen -t rsa -b 4096
   (Confirmamos y no ponemos password)
4. Entrar en la carpeta casoPractico2/terraform: cd casoPractico2/terraform
5. Ejecutar el comando que inicializa y crea la infraestructura en azure: sh create-infraestructure.sh
   A parte de crear la infraestructura, permite el acceso del usuario por ssh a los nodos. En este caso adminUsername. 
6. Copiar la clave pública para el acceso por ssh que hemos generado en el apartado 4 a los nodos:
      - cd
      - ssh-copy-id -i .ssh/id_rsa.pub adminUsername@mastercp2.westeurope.cloudapp.azure.com (Confirmar con "yes")
      - ssh-copy-id -i .ssh/id_rsa.pub adminUsername@worker01cp2.westeurope.cloudapp.azure.com (Confirmar con "yes")
      - ssh-copy-id -i .ssh/id_rsa.pub adminUsername@worker02cp2.westeurope.cloudapp.azure.com (Confirmar con "yes")
    
    Ya podríamos acceder a los nodos por ssh ejemplo master:
      - ssh adminUsername@mastercp2.westeurope.cloudapp.azure.com
 7. cd casoPractico2/ansible
 8. Crearemos el despliegue de la aplicación con ansible, en este caso se trata de un servidor web nginx con volúmenes compartido:
      - sh deploy.sh (confirmar con "yes")
 9. Ya tendríamos creado el servidor web, con un volumen compartido /srv/nfs entre los nodos
 10. Comprobamos la creación:
        - curl -I http://mastercp2.westeurope.cloudapp.azure.com/miweb

  Para no tener problemas de host, al crear las máquinas les he asignado un nombre de dns. De esta forma si se reinican o se crean unas nuevas, no me cambia el     valor del host. Uso el nombre dns para identificar el nodo en ansible.
  
# Pasos para la eliminación de la infraestructura en azure
  Si tuvieramos que eliminar toda la infraestructura creada:
  - sh destroy-infraestructure.sh (confirmar con "yes)

# Problemas encontrados durante la práctica
- Limitación de la cuenta de student de azure, no permite más de 4 vCPUs. Opto por un master/NFS(2CPUs), worker01(1 CPU) y worker02(1 CPU). El master hace de    nfs.
- Al dar de alta recursos en azure, no pueden duplicarse el nombre.  
  Añadí la "coletilla" cp2 al nombre en todos los nodos.
- Empecé usando la opción de SDN de Cálico, pero no me recordé que daba problemas de compatibilidad desde Azure. Así cambié de a flannel.
- Tuve problemas con la apertura de puertos al usar flannel, lo solucioné revisando la documentación que proporcionó usted y vi solución en una página de stackoverflow
  https://stackoverflow.com/questions/60708270/how-can-i-use-flannel-without-disabing-firewalld-kubernetes
- El módulo de ansible k8s me da errores al llamar a él. He optado por usar módulos como shell o command, para llamar al kubectl

# Referencias 
- Página de ansible: https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html
- ....

# Leyenda de algunas de las instrucciones usadas en la práctica

terraform:

terraform init
terraform plan 
terraform apply
terraform destroy

sh create-infraestructure.sh
sh destroy-infraestructure.sh

ansible:

ansible -i hosts -m ping all
ansible-playbook -i hosts playbooks/xxxx.yml

sh deploy.sh

kubernetes:

kubectl get namespaces

kubectl get svc -n miweb-server

kubectl get pod -n miweb-server

kubectl get pod -n miweb-server -o wide

kubectl get service --all-namespaces

kubectl get nodes --all-namespaces

kubectl get pods --all-namespaces

kubectl describe ingress webapp-ingress --namespace=webapp-server

kubectl describe ep webapp-service --namespace=webapp-server

kubectl get svc --namespace=haproxy-controller -o wide

kubectl get svc --namespace=webapp-server -o wide

kubectl get pods --all-namespaces -o wide

kubectl get pods -A -o wide

kubectl exec -it -n webapp-routed webapp-routed-7448445cb6-mq66p sh

kubeadm reset -f && iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X

kubectl describe svc webapp-service --namespace=webapp-server

firewall:

firewall-cmd --list-all
firewall-cmd --list-all

curl:

curl -I http://mastercp2.westeurope.cloudapp.azure.com/miweb
curl http://mastercp2.westeurope.cloudapp.azure.com/miweb

# Corrección automática

Para la corección automática el repositorio deberá tener la siguiente estructura:

```console
[jadebustos@archimedes cp2]$ tree .
.
├── ansible
│   ├── deploy.sh
│   └── hosts
├── README.md
└── terraform
    ├── correccion-vars.tf
    └── credentials.tf

2 directories, 5 files
[jadebustos@archimedes cp2]$
```

## Terraform

+ Todo el código terraform se encontrará en el directorio **terraform**.

+ Será necesaria la inclusión de un fichero llamado **correccion-vars.tf** teniendo únicamente el siguiente contenido:

  ```yaml
  variable "location" {
    type = string
    description = "Región de Azure donde crearemos la infraestructura"
    default = "<YOUR REGION>" 
  }

  variable "storage_account" {
    type = string
    description = "Nombre para la storage account"
    default = "<STORAGE ACCOUNT NAME>"
  }

  variable "public_key_path" {
    type = string
    description = "Ruta para la clave pública de acceso a las instancias"
    default = "~/.ssh/id_rsa.pub" # o la ruta correspondiente
  }

  variable "ssh_user" {
    type = string
    description = "Usuario para hacer ssh"
    default = "<SSH USER>"
  }
  ```

+ Los nombres de las variables no se deben cambiar, unicamente sus valores. En la corección automática este fichero se sobreescribirá con el fichero de datos del profesor corrector.

+ Las credenciales deberán ir en un fichero llamado **credentials.tf**. Este fichero no se deberá subir al repositorio para evitar compartir las credenciales. Se puede bloquear subirlo al repositorio git incluyendolo en el fichero **.gitignore**.

  ```yaml
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
  # crea un service principal y rellena los siguientes datos para autenticar
  provider "azurerm" {
    features {}
    subscription_id = "<SUBSCRIPTION_ID>"
    client_id       = "<APP_ID>"         # se obtiene al crear el service principal
    client_secret   = "<CLIENT_SECRET>"  # se obtiene al crear el service principal
    tenant_id       = "<TENANT_ID>"      # se obtiene al crear el service principal
  }
  ```

+ Ejecutar **terraform apply** dentro del directorio **terraform** tiene que realizar el despliegue en Azure.

## Ansible

+ En el directorio **ansible** se encontrarán todos playbooks, roles e inventario necesarios para el despliegue.

+ El inventario a utilizar tiene que tener la siguiente estructura:

  ```ini
  [all:vars]
  ansible_user=<YOUR ANSIBLE USER>

  [master]
  master

  [workers]
  worker1
  worker2

  [nfs]
  nfs
  ```

    > NOTA: Se pueden añadir tantas variables como se desee, pero la variable **ansible_user** debe estar definida.

+ Se deberá incluir un script bash llamdo **deploy.sh** que se encargará de ejecutar los playbooks de ansible en el orden correcto.

+ Este script se ejecutará para realizar el despliegue de kubernetes y la aplicación.
