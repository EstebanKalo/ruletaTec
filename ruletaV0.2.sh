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

# Función Ctrl_c
function ctrl_c(){
  echo -e "\n\n ${redColour}[!] Saliendo... ${endColour}\n"
  tput cnorm && exit 1
}

# Ctrl_C
trap ctrl_c INT

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}${purpleColour} $0${endColour}"
  echo -e "\t${blueColour} -m)${endColour}${grayColour} Elige la cantidad de dinero${endColour}" 
  echo -e "\t${blueColour} -t)${endColour}${grayColour} Elige la técnica a utilizar${endColour}${purpleColour} (${endColour}${yellowColour}martingala${endColour}${grayColour} / ${endColour}${turquoiseColour}otra_tecnica${endColour}${purpleColour})${endColour}" 
  exit 1
}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${yellowColour} $money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero quieres apostar inicialmente? ->${endColour} " && read initial_bet
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente?${endColour}${yellowColour} (par/impar/numero)${endColour}${grayColour}? ->${endColour} " && read bet_choice

  if [[ "$bet_choice" != "par" && "$bet_choice" != "impar" && "$bet_choice" != "numero" ]]; then
    echo -e "${redColour}[!]${endColour}${grayColour} Elección inválida. Por favor elige 'par', 'impar' o 'numero'.${endColour}"
    exit 1
  fi

  if [[ "$bet_choice" == "numero" ]]; then
    echo -ne "${yellowColour}[+]${endColour}${grayColour} Elige un número entre 0 y 36 ->${endColour} " && read bet_number
    if (( bet_number < 0 || bet_number > 36 )); then
      echo -e "${redColour}[!]${endColour}${grayColour} Número inválido. Por favor elige un número entre 0 y 36.${endColour}"
      exit 1
    fi
  fi

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a empezar a jugar con una apuesta inicial de${endColour}${yellowColour} $initial_bet€${endColour}${grayColour} y se jugará continuamente${endColour}"

  current_bet=$initial_bet
  while true; do
    random_number=$(($RANDOM % 37))
    echo -e "${blueColour}[+]${endColour}${grayColour} Número generado:${endColour}${purpleColour} $random_number${endColour}"

    if (( $random_number == 0 )); then
      echo -e "${redColour}[!]${endColour}${grayColour} Salió 0, perdiste :(.${endColour}"
      money=$(($money - $current_bet))
      current_bet=$(($current_bet * 2))
    else
      if [[ ( $bet_choice == "par" && $(( $random_number % 2 )) == 0 ) || ( $bet_choice == "impar" && $(( $random_number % 2 )) != 0 ) || ( $bet_choice == "numero" && $random_number == $bet_number ) ]]; then
        echo -e "${greenColour}[+]${endColour}${grayColour} ¡Ganaste! Facilitooo${endColour}"
        money=$(($money + $current_bet))
        echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero quieres apostar en la siguiente ronda? ->${endColour} " && read current_bet
      else
        echo -e "${redColour}[!]${endColour}${grayColour} ¡Perdiste! Nos vamos al pozo ${endColour}"
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
      echo -e "${redColour}[!]${endColour}${grayColour} No te alcanza para duplicar la apuesta. Juego terminado.${endColour}"
      exit 1
    fi

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
  echo -e "${redColour}[!]${endColour}${grayColour} Técnica no implementada.${endColour}"
  helpPanel
fi

