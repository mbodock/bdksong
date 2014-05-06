# Bdksong

Encontre músicas rapidamente no seu computador sem sair do terminal

## Requisitos

 * [mplayer](http://mplayerhq.hu/)

Como o Bdksong é uma interface para o `mplayer` nada mais obvio do que o **mplayer**.

## Instalação

Via download direto (versão 0.4):

    sudo wget https://raw.githubusercontent.com/mbodock/bdksong/v0.4/bdksong.sh -O /usr/bin/bdksong
    sudo chmod +x /usr/bin/bdksong
    sudo ln -sv /usr/bin/bdksong/bdksong.sh  /usr/local/bin/bdksong

## Uso
    
    bdksong [opções]
    bdksong [opções] [string]

    Opções:
    --dir <novo_diretório>
            muda o diretório do qual as músicas serão executadas
            para <novo_diretório>.

    -h, --help
            imprime na tela esta mensagem

    -s, --shuffle
            playlist em modo aleatório

    -r, --repeat
            Irá reproduzir a lista em loop até que a letra "q" seja precionada.



    -V
            imprime na tela a versão do programa.

    -v <tempo>, --verbose <tempo>
            imprime na tela por <tempo> segundos a lista que será executada.

    -t <extensão>, --type <extensão>
            Define a extensão o arquivo que o bdksong irá tocar.
            Por padrão o bdksong executará os seguintes formatos: (mp3|mp4|avi|AAC|wma)

    String:
            substitua string por uma palavra, ou pedaço de palavra,
            contida na descrição da(s) música(s) desejada(s).

##  Contribuições

Contribuições são bem-vindas! Fique à vontade para fazer fork, criar issues e/ou pull request.

## Licença

Bdksong é um software livre distribuído sobre os termos da [licença da MIT](http://opensource.org/licenses/MIT).

Bdksong is free software distributed under the terms of the [MIT license](http://opensource.org/licenses/MIT);

