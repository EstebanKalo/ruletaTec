#!/bin/bash

#Colours
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
  echo -e "\t${blueColour} -t)${endColour}${grayColour} Elige la tecnica a utilizar${endColour}${purpleColour} (${endColour}${yellowColour}martingala${endColour}${grayColour} / ${endColour}${turquoiseColour}inverseLabrouchere${endColour}${purpleColour})${endColour}\n"
  exit 1
}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${yellowColour} $money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} Cuanto dinero quieres apostar? ->${endColour} " && read initial_bet
  echo -ne "${yellowColour}[+]${endColour}${grayColour} A que deseas apostar continuamente?${endColour}${yellowColour} (par/impar)${endColour}${grayColour}? ->${endColour} " && read par_impar
  
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a empezar a jugar con una apuesta inicial de${endColour}${yellowColour} $initial_bet€${endColour}${grayColour} y se jugara continuamente numero${endColour}${yellowColour} $par_impar${endColour}"

while true; do
  random_number="$(($RANDOM % 37))"

done
}


while getopts "m:t:h" arg; do 
  case $arg in 
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ] ; then
  if [ $technique == "martingala" ] ; then
    martingala
  else
    echo -e "\n${yellowColour}[!]${endColour}${redColour} La tecnica utilizada no existe${endColour}"
    helpPanel
  fi
else
  helpPanel
fi
