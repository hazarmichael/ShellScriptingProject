

echo "Welcome to encryption/decryotion project .. "
echo "Choose between encryption and decryption:"
echo "e"
echo "d"
read var
str="abcdefghijklmnopqrstuvwxyz"
if  [ "$var" = "e" ]
then
    echo "encryption"
    echo "Please input the name of the plain text file"
    read nameFile
    value=`cat $nameFile`
    value=$(echo $value | tr '[:upper:]' '[:lower:]')
    echo "$value"
     if echo "$value" | grep '[^A-Za-z ]' $nameFile
     then
          echo "Error, the file contains non-alphabet characters."
     else
        echo "The file contains alphabet characters."
        #value=$(echo $value | tr -cd '[a-zA-Z]" "')
        sumCharIndexWord=0
        > word.txt
        > sumword.txt
        for i in $value
        do
        for j in $(echo $i | sed -e 's/\(.\)/\1\n/g')
        do
        prefix=${str%%$j*}
        index=${#prefix}
        index=$((index+1))
        echo $j
        echo $index
        sumCharIndexWord=$((index+sumCharIndexWord))
        num=0
        done
        echo $i
        echo $sumCharIndexWord
        echo $i >> word.txt
        echo $sumCharIndexWord >> sumword.txt
        sumCharIndexWord=0
        done
        paste word.txt sumword.txt
        > wordPrint.txt
        sort -nr sumword.txt | head -1 > wordPrint.txt
        maxValue=`cat wordPrint.txt`
        keyValue=$((maxValue % 256))
        echo "Key Value = "$keyValue
        echo "obase=2; $keyValue" | bc
        for i in $value
        do
            for j  in $(echo $i | sed -e 's/\(.\)/\1\n/g')
            do
                val=$(echo $j | tr -d "\n" | od -An -t dC)
                res=$((keyValue ^ val))
                echo "Ascii of char "$j" = "$val
                echo $val" XOR "$keyValue" = "$res
                echo "obase=2; $val" | bc | numfmt --format=%08f
                echo "obase=2; $keyValue" | bc | numfmt --format=%08f
                echo "obase=2; $res" | bc | numfmt --format=%08f >> result1.txt
                echo "obase=2; $res" | bc | numfmt --format=%08f
            done
        done
              
              cut -c1-4 result1.txt >> first4bits.txt
              cut -c5-8 result1.txt >> last4bits.txt
          
              echo "obase=2; $keyValue" | bc | numfmt --format=%08f >> key.txt
              cut -c1-4 key.txt >> first4bits.txt
              cut -c5-8 key.txt >> last4bits.txt
              
              echo "Enter  the name of the cipher text file:"
              read filePrint
              paste -d'\0' last4bits.txt first4bits.txt > $filePrint

    fi
    elif [ "$var" = "d" ]
then

    echo "decryption"
    echo "Please input the name of the cipher text file"
    read nameFile
    value=`cat $nameFile`
    echo $(tail -n 1 $nameFile ) > tag.txt
    cut -c1-4 tag.txt > keyFirst.txt
    cut -c5-8 tag.txt > keyLast.txt
    paste -d'\0' keyLast.txt keyFirst.txt > keyDec.txt
    keyValue=`cat keyDec.txt`
    echo "key in decimal="
    echo "ibase=2;obase=A; $keyValue" | bc
    echo "key in binary="
    echo $keyValue
    
    cut -c1-4 $nameFile > decFirst.txt
    cut -c5-8 $nameFile > decLast.txt
    paste -d'\0' decLast.txt decFirst.txt > dec.txt
    
    value=$(head -n -1 dec.txt)    
    echo "Enter  the name of the plain text file:"
    read filePrint
     for i in $value
        do
        a=$(echo "ibase=2;obase=A; $keyValue" | bc)
        b=$(echo "ibase=2;obase=A; $i" | bc)
        res=$((a ^ b))
        echo $a" XOR "$b" = "$res
        echo $a" XOR "$b" = "$res >> outp.txt
        printf \\$(printf '%03o' "$res") >> $filePrint
        done
fi
