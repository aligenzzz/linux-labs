#!/bin/bash

elements=( '·' $'\e[1;32m1\e[0m' $'\e[1;33m2\e[0m' $'\e[1;34m3\e[0m' $'\e[1;35m4\e[0m' $'\e[1;36m5\e[0m' $'\e[1;36m6\e[0m' $'\e[1;36m7\e[0m' $'\e[1;36m8\e[0m' '@' $'\e[1;31mf\e[0m' $'\e[1;37m?\e[0m' $'\e[1;31m*\e[0m' )

function drawboard() 
{
    clear

    echo "bombs: $bombs   flags: $flags"

    echo ' '
    for ((i=0;i<size;i++))
    do
        for ((j=0;j<size;j++))
        do
            echo -n " ${elements[board[i*size+j]]}"
        done

        echo ' '
    done

    echo -en '\n<a/w/d/s> Move\n<enter> Step\n<f> Flag  <n> New\n<q> Quit'
}

function newgame() 
{
    size=10; bombs=15; flags=0; start=0 

    for ((i=0;i<size*size;i++))
    do 
        bomb[i]=0; board[i]=9
    done

    drawboard

    x=0; y=0; status=1
}

function setbombs()
{
    count=$bombs
    while :
    do
        bx=$(( RANDOM%size ))
        by=$(( RANDOM%size ))

        if (( by<=y+1 && by>=y-1 && bx<=x+1 && bx>=x-1 )); then continue; fi

        if (( bomb[by*size+bx]!=12 ))
        then
            bomb[by*size+bx]=12
            (( count-- ))
        fi

        if (( count==0 )); then break; fi
    done

    for ((i=0;i<size;i++))
    do 
        for ((j=0;j<size;j++))
        do
            if (( bomb[i*size+j]==12 )); then continue; fi;

            bcount=0

            if (( i==0 && j==0 ))
            then
                bcount=$(( ((bomb[i*size+size+j]==12))+((bomb[i*size+size+j+1]==12))+((bomb[i*size+j+1]==12)) ))
            fi

            if (( i==size-1 && j==size-1 ))
            then
                bcount=$(( ((bomb[i*size-size+j]==12))+((bomb[i*size-size+j-1]==12))+((bomb[i*size+j-1]==12)) ))
            fi

            if (( i==0 && j>0 && j<size-1 ))
            then
                bcount=$(( ((bomb[i*size+size+j]==12))+((bomb[i*size+size+j+1]==12))+((bomb[i*size+j+1]==12))+((bomb[i*size+j-1]==12))+((bomb[i*size-size+j-1]==12)) ))
            fi

            if (( j==0 && i>0 && i<size-1 ))
            then
                bcount=$(( ((bomb[i*size+size+j]==12))+((bomb[i*size+size+j+1]==12))+((bomb[i*size+j+1]==12))+((bomb[i*size-size+j+1]==12))+((bomb[i*size-size+j]==12)) ))
            fi

            if (( i==size-1 && j>0 && j<size-1 ))
            then
                bcount=$(( ((bomb[i*size+j-1]==12))+((bomb[i*size-size+j-1]==12))+((bomb[i*size-size+j]==12))+((bomb[i*size-size+j+1]==12))+((bomb[i*size+j+1]==12)) ))
            fi

            if (( j==size-1 && i>0 && i<size-1 ))
            then
                bcount=$(( ((bomb[i*size+size+j]==12))+((bomb[i*size+size+j-1]==12))+((bomb[i*size+j-1]==12))+((bomb[i*size-size+j-1]==12))+((bomb[i*size-size+j]==12)) ))
            fi

            if (( i>0 && i<size-1 && j>0 && j<size-1 ))
            then
                bcount=$(( ((bomb[i*size+size+j]==12))+((bomb[i*size+size+j+1]==12))+((bomb[i*size+j+1]==12))+((bomb[i*size-size+j+1]==12))+((bomb[i*size-size+j]==12))+((bomb[i*size-size+j-1]==12))+((bomb[i*size+j-1]==12))+((bomb[i*size+size+j-1]==12)) ))
            fi

            if (( bcount==0 ))
            then
                bomb[i*size+j]=0
            else
                bomb[i*size+j]=$bcount
            fi
        done
    done

    start=1
}

function gameover() 
{
    for ((i=0;i<size*size;i++))
    do 
        for ((j=0;j<size;j++))
        do
            board[i*size+j]=bomb[i*size+j]
        done
    done

    board[y*size+x]=12

    drawboard

    status=0
}

function cleanfield() {
    local ly=$1
    local lx=$2

    if (( bomb[ly*size+lx]==12 )); then return; fi

    board[ly*size+lx]=${bomb[ly*size+lx]}

    if (( board[ly*size+lx]==0 ))
    then
        if (( ly>0 && board[ly*size-size+lx]==9 )); then cleanfield $((ly-1)) $((lx)); fi
        if (( lx<size-1 && board[ly*size+lx+1]==9 )); then cleanfield $((ly)) $((lx+1)); fi
        if (( lx>0 && board[ly*size+lx-1]==9 )); then cleanfield $((ly)) $((lx-1)); fi
        if (( ly<size-1 && board[ly*size+size+lx]==9 )); then cleanfield $((ly+1)) $((lx)); fi

        if (( ly>0 && lx>0 && board[ly*size-size+lx-1]==9 && bomb[ly*size-size+lx-1]>=1 && bomb[ly*size-size+lx-1]<=8 )); then cleanfield $((ly-1)) $((lx-1)); fi
        if (( ly>0 && lx<size-1 && board[ly*size-size+lx+1]==9 && bomb[ly*size-size+lx+1]>=1 && bomb[ly*size-size+lx+1]<=8 )); then cleanfield $((ly-1)) $((lx+1)); fi
        if (( ly<size-1 && lx>0 && board[ly*size+size+lx-1]==9 && bomb[ly*size+size+lx-1]>=1 && bomb[ly*size+size+lx-1]<=8 )); then cleanfield $((ly+1)) $((lx-1)); fi
        if (( ly<size-1 && lx<size-1 && board[ly*size+size+lx+1]==9 && bomb[ly*size+size+lx+1]>=1 && bomb[ly*size+size+lx+1]<=8 )); then cleanfield $((ly+1)) $((lx+1)); fi
    fi

    return
}

function opencell() 
{
    if (( board[y*size+x] != 9 )); then return; fi

    if (( start==0 ))
    then 
        setbombs
    fi

    if (( bomb[y*size+x]==12 ))
    then
        gameover
        return
    fi

    if (( bomb[y*size+x]>=1 && bomb[y*size+x]<=8 ))
    then
        board[y*size+x]=${bomb[y*size+x]}
    else
        cleanfield $y $x

        drawboard
    fi
}

function putflag() 
{
    if (( board[y*size+x]==9 )) 
    then
        (( board[y*size+x]++ ))
        (( flags++ ))
    else
        if (( board[y*size+x]==10 )) 
        then
            (( board[y*size+x]++ ))
            (( flags-- ))
        else
            if (( board[y*size+x]==11 )) 
            then
                (( board[y*size+x]=9 ))
            fi
        fi
    fi
    
    tput 'cup' 0 19
    echo -en "$flags"

    was=15
    for ((i=0;i<size*size;i++))
    do 
        if (( board[i]==10 && bomb[i]==12 )); then (( was-- )); fi
    done

    if (( was==0 )); then gameover; fi
}

newgame

while :
do
    tput 'cup' $((y+2)) $((x*2))
    echo -en "[${elements[board[y*size+x]]}]"
    tput 'cup' $((y+2)) $((x*2+1))

    read -s -n 1 a

    if [[ $a=[awsd] ]]
    then
        tput 'cup' $((y+2)) $((x*2))
        echo -en " ${elements[board[y*size+x]]} "
        tput 'cup' $((y+2)) $((x*2+1))
    fi

    if (( status!=1 )) && [[ $a != [nq] ]] 
    then 
        continue 
    fi

    case $a in 
        'a') (( x>0?x--:0 )) ;;
        's') (( y<size-1?y++:0 )) ;;
        'w') (( y>0?y--:0 )) ;;
        'd') (( x<size-1?x++:0 )) ;;
        '') opencell ;;
        'f') putflag ;;
        'n') newgame ;;
        'q') break ;;
    esac
done

clear