#!/usr/bin/env bash
# Template orgulhosamente criado por (Shell-Base)

#-----------HEADER-------------------------------------------------------------|
# AUTOR             : Vovolinux <suporte@vovolinux.com.br>
# HOMEPAGE          : https://vovolinux.com.br 
# DATA DE CRIAÇÃO   : 31/07/2021 às 23:09 
# PROGRAMA          : gen-netplan-config
# VERSÃO            : 1.0
# LICENÇA           : MIT - © 2021 - Vovolinux
# PEQUENA DESCRIÇÃO : Shell script to set IP to Ubuntu and derivatives
#
# CHANGELOG :
#
#------------------------------------------------------------------------------|

#--------------------------------- VARIÁVEIS ---------------------------------->
#
# Aqui vão todas as váriaveis do programa.

### VARIÁVEIS DO SCRIPT ###

# Autor
autor='Vovolinux'

# Programa
programa='gen-netplan-config'

# Versão
versao='1.0'

# Ano atual
ano='2021'

# Informação de Copyright
copyright="© 2021 - Vovolinux"

if [[ $# -eq 0 ]]; then
    _IP="172"
else
    _IP=${1}
fi

_IP=${1}
_HOSTNAME=`hostname -I | cut -d ' ' -f 1`
_FINAL=`echo ${_HOSTNAME} | cut -d '.' -f 4`
_GATEWAY=`echo ${_HOSTNAME} | sed "s/\.${_FINAL}/\.1/g"`
_ADDRESS=`echo ${_HOSTNAME} | sed "s/\.${_FINAL}/\.${_IP}/g"`
_ETHERNET=`ip route list default | cut -d ' ' -f 5`

#------------------------------- FIM-VARIÁVEIS --------------------------------<



#----------------------------------- FUNÇÕES ---------------------------------->
#
# Funções vão aqui!

# Verifica se o script está sendo executado como r00t.
is_root()
{
    # é root?
    [[ "$UID" -ne "0" ]] && {  
        printf '%b' "Execute como r00t.\n"
        exit 1
    }
}

backup() 
{
    cp -v /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bkp
}

create()
{
    cat << EOF > /etc/netplan/00-installer-config.yaml
# This is the network config written by 'vovolinux'
network:
  ethernets:
    $_ETHERNET:
      dhcp4: no
      addresses:
        - $_ADDRESS/24
      gateway4: $_GATEWAY
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]

  version: 2
EOF
}
#--------------------------------- FIM-FUNÇÕES --------------------------------<



#---------------------------------- TESTES ------------------------------------>
#
# Testes iniciais do seu programa vão neste bloco.

is_root

#--------------------------------- FIM-TESTES ---------------------------------<

# Programa começa aqui :)

backup
create
netplan apply
printf %b "\nO IP do servidor é: $_ADDRESS\n\n"
