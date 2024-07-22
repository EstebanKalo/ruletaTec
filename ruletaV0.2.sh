#!/bin/bash

# Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Funcion Ctrl_c
function ctrl_c(){
  echo -e "\n\n ${redColour}[!] Saliendo... ${endColour}\n"
  tput cnorm && exit 1
}

# Ctrl_C
trap ctrl_c INT

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}${purpleColour} $0${endColour}"
  echo -e "\t${blueColour} -m)${endColour}${grayColour} Elige la cantidad de dinero${endColour}" 
  echo -e "\t${blueColour} -t)${endColour}${grayColour} Elige la tecnica a utilizar${endColour}${purpleColour} (${endColour}${yellowColour}martingala${endColour}${grayColour} / ${endColour}${turquoiseColour}otra_tecnica${endColour}${purpleColour})${endColour}" 
  exit 1
}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${yellowColour} $money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} Cuanto dinero quieres apostar inicialmente? ->${endColour} " && read initial_bet
  echo -ne "${yellowColour}[+]${endColour}${grayColour} A que deseas apostar continuamente?${endColour}${yellowColour} (par/impar)${endColour}${grayColour}? ->${endColour} " && read par_impar

  if [[ "$par_impar" != "par" && "$par_impar" != "impar" ]]; then
    echo -e "${redColour}[!]${endColour}${grayColour} Eleccion invalida. Por favor elige 'par' o 'impar'.${endColour}"
    exit 1
  fi

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a empezar a jugar con una apuesta inicial de${endColour}${yellowColour} $initial_bet€${endColour}${grayColour} y se jugara continuamente${endColour}"

  current_bet=$initial_bet
  while true; do
    random_number=$(($RANDOM % 37))
    echo -e "${blueColour}[+]${endColour}${grayColour} Numero generado:${endColour}${purpleColour} $random_number${endColour}"

    if (( $random_number == 0 )); then
      echo -e "${redColour}[!]${endColour}${grayColour} Salio 0, perdiste :(.${endColour}"
      money=$(($money - $current_bet))
      current_bet=$(($current_bet * 2))
    else
      if [[ ( $par_impar == "par" && $(( $random_number % 2 )) == 0 ) || ( $par_impar == "impar" && $(( $random_number % 2 )) != 0 ) ]]; then
        echo -e "${greenColour}[+]${endColour}${grayColour} Ganaste! Facilitooo${endColour}"
        money=$(($money + $current_bet))
        current_bet=$initial_bet
      else
        echo -e "${redColour}[!]${endColour}${grayColour} Perdiste! Nos vamos al pozo ${endColour}"
        money=$(($money - $current_bet))
        current_bet=$(($current_bet * 2))
      fi
    fi

    echo -e "${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${yellowColour} $money€${endColour}"

    if (( $money <= 0 )); then
      echo -e "${redColour}[!]${endColour}${grayColour} Te quedaste sin plata.${endColour}"
      exit 1
    fi

    if (( $current_bet > $money )); then
      echo -e "${redColour}[!]${endColour}${grayColour} No llegas para duplicar la apuesta. Juego terminado.${endColour}"
      exit 1
    fi

 # Esto es falopeada mia nomas

#    echo -ne "${yellowColour}[+]${endColour}${grayColour} Cuanto le pones a la siguiente ronda? ->${endColour} " && read current_bet
#    if (( $current_bet > $money )); then
#      echo -e "${redColour}[!]${endColour}${grayColour} No te alcanza broder. Juego terminado.${endColour}"
#      exit 1
#    fi

    sleep 4
  done
}

while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [[ -z $money || -z $technique ]]; then
  helpPanel
fi

if [[ $technique == "martingala" ]]; then
  martingala
else
  echo -e "${redColour}[!]${endColour}${grayColour} Tecnica no implementada.${endColour}"
  helpPanel
fi

