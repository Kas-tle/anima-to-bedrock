#!/bin/bash
for file in *.csv
   do
   # add quotes around all entries (jq demands they be strings...)
   awk '{gsub(/[^,]+/,"\"&\"")}1' ${file} | sponge ${file}

   # store animation name for later use (w/ & w/o quotes)
   animatronicnameqt=$(head -n2 ${file} | tail -n1 | cut -d',' -f1)
   animatronicname=$(echo $animatronicnameqt | tr -d '"')

   # take text from csv and map values to jq; animatronicname is passed from bash variable to jq variable
   jq --arg animatronicname "$animatronicname" -Rs '

   def readcsv:
       split("\n")
       | .[]
       | select(length > 0)
       | split(",")
       | map(fromjson)
       |   {
             name:  .[0]
           , frame: .[1]
           , world: .[2]
           , yaw:   .[3] | tonumber
           , x: .[4] | tonumber
           , y: .[5] | tonumber
           , z: .[6] | tonumber
           , hx: .[7] | tonumber
           , hy: .[8] | tonumber
           , hz: .[9] | tonumber
           , bx: .[10] | tonumber
           , by: .[11] | tonumber
           , bz: .[12] | tonumber
           , lax: .[13] | tonumber
           , lay: .[14] | tonumber
           , laz: .[15] | tonumber
           , rax: .[16] | tonumber
           , ray: .[17] | tonumber
           , raz: .[18] | tonumber
           , llx: .[19] | tonumber
           , lly: .[20] | tonumber
           , llz: .[21] | tonumber
           , rlx: .[22] | tonumber
           , rly: .[23] | tonumber
           , rlz: .[24] | tonumber
           , delay: "20"
           }
   ;

   def framelist:
   split("\n")
   | .[]
   | select(length > 0)
   | split(",")
   | map(fromjson)
   |
        .[1]
   ;

   def outputs:
      map( { (.frame): . } ) | add
   ;

   {
     "Animatronic":{
      ($animatronicname):
       (([readcsv] | outputs ) + {poslist: [(framelist)]})
     }
   }

   ' <${file} > ${animatronicname}.anima
done
