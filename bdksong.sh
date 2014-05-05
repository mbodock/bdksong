#!/bin/bash

# Busca e executa uma serie de musicas no diretório atual.
# A partir do nome do arquivo.
#
# ex:
# bdksong Adele
#
# Author Mbodock (mbodock@gmail.com)
#
# Versão 0.4.1
#
# Requisitos: mplayer

# Testa as dependências: mplayer
if type mplayer &>/dev/null; then
    true
else
    echo "O bdksong exige o seguinte programa:"
    echo " -mplayer"
    echo "Gostaria de instalá-lo? <s/n>"
    read option

    if [ "$option" = "s" ]
    then
        sudo apt-get install mplayer
        clear
    else
        exit 0
    fi
fi

# Configurando o Path
file_cfg="$HOME/.bdksong.cfg"
if [ -e "$file_cfg" ]
then
    music_path=$(cat $file_cfg)

else
    echo "Onde você armazena suas músicas? (por favor use o caminho completo)"
    read music_path
    echo $music_path > $file_cfg
    echo "Configurações salvas em $file_cfg"
    echo "Pronto!"
fi

# Verificando se temos modo -s
if [ "$1" == "-s" ]; then
    shuffle=1
    shift
fi

cd $music_path
list="/tmp/bdklist.list"
echo "$(find $(pwd) | grep -i "$1" | while read x; do echo "$x"; done)" > $list

if [ $shuffle ]; then
    sort --random-sort $list -o $list
fi

mplayer -playlist $list 

rm $list
