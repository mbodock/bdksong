#!/bin/bash

# Buscador de músicas
#   Busca e executa músicas dada uma palavra (ou parte de uma palavra)
#   utilizando o mplayer
#
#
# Requisitos: mplayer


#=================================
#   Meta
#=================================
version="0.4.1"



#=================================
#  Configurações
#=================================

list=""
music_path=""
music_path_arg=""
change_path=0
shuffle=0
file_cfg="$HOME/.config/.bdksong.cfg"
music_string=""
verbose=0
sleep_time=0


# Imprime na tela uma mensagem de ajuda
#

usage()
{
    cat <<EOF

O bdksong é um script modo texto para execução de uma playlist dada uma string de uma música.

    Uso:
        bdksong [opções]
        bdksong [opções] [string]


    Opções:
    --dir=<novo_diretório>
            muda o diretório do qual as músicas serão executadas
            para <novo_diretório>. É muito importante que o sinal de
            igualdade seja usado conforme está descrito.

    -h, --help
            imprime na tela esta mensagem

    -s, --shuffle
            playlist em modo aleatório

    -V
            imprime na tela a versão do programa.

    -v=<tempo>, --verbose=<tempo>
            imprime na tela por <tempo> segundos a lista que será executada. É muito
            importante que o sinal de igualdade seja usado conforme está descrito.

    String:
            substritua string por uma palavra, ou pedaço de palavra,
            contida na descrição da(s) música(s) desejada(s).


EOF

}


# Sai sorrateiramente
#

leave()
{
    exit $1
}

# Imprime na tela a versão do programa
#

show_version()
{
    echo "Versão: $version"
}


# Testa as dependências: mplayer
#

resolve_dependencies()
{
    if type mplayer >/dev/null; then
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
            leave 0
        fi
    fi
}


# Configura o Path
#

path_configure()
{
    if [ $change_path = 1 ]
    then
        music_path=$music_path_arg
        echo $music_path > $file_cfg
        echo "Configurações modificadas com sucesso!"

    elif [ -e "$file_cfg" ]
    then
        music_path=$(cat $file_cfg)

    else
        echo "Onde você armazena suas músicas? (por favor use o caminho completo)"
        read music_path
        echo $music_path > $file_cfg
        echo "Configurações salvas em $file_cfg"
        echo "Pronto!"
    fi
}


# Imprime na tela as músicas que serão executadas
#

verbose_mode()
{
    if [ $verbose = 1 ]
    then
        while read line
        do
            # imprime só o ultimo argumento, sem o path
            echo $line | awk -F"/" '{print $NF}'
        done < $list

        sleep $sleep_time
    fi
}


# Configura playlist aleatória
#

set_shuffle()
{
    if [ $shuffle = 1 ]
    then
        sort --random-sort $list -o $list
    fi
}

check_list()
{
    size=$(wc -c $list | awk -F ' ' '{print $1}')
    if [ "$size" -lt "2" ]
    then
        echo "Nenhuma música encontrada."
        leave 404
    fi
}

#================
#   Main
#================

resolve_dependencies
# Identificando os parâmetros e configurando os modos
#
if [ "$1" = "" ]
then
    usage
    leave 0
fi

while [ "$1" != "" ]
do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            leave 0
            ;;
        --dir)
            music_path_arg=$VALUE
            change_path=1
            ;;
        -s | --shuffle)
            shuffle=1
            ;;
        -V)
            show_version
            leave 0
            ;;
        -v | --verbose)
            verbose=1
            sleep_time=$VALUE
            ;;
        *)
            music_string=$PARAM
    esac
    shift
done
#--

path_configure


# Aqui é feita a magia
if [ -n $music_path -a -n $music_string 2> /dev/null ]
then
    list="/tmp/bdklist.list"
    echo "$(find $music_path | grep -i "$music_string" | while read x; do echo "$x"; done)" > $list
    set_shuffle
    verbose_mode
    check_list
    mplayer -playlist $list
    rm $list
else
    cat <<WARNING
    Algum problema ocorreu enquanto tentávamos processar sua lista.

    * Verifique se o arquivo $HOME/.config/.bdksong.cfg contém o seu diretório
    de músicas. Caso não contenha, utilize o comando --dir=<diretório>.

    * Verifique se sua string é válida

    utilize --help ou -h para mais informações
WARNING
fi

