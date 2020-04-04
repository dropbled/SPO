#!/bin/bash

echo 'Введите имя директории'
read dirname #
echo -e 'Путь \tИмя \tПрава \tРасширение \tДата изменения \tРазмер(Мб) \tПродолжительность \tФормат' > 1.xls
IFS=$'%n'
dir=$dirname
function filetre {
	for f in "$dir"/*
		do
			if [[ -d "$f" ]];
				then
					dir=$f
					filetre
				else
					
					local filename=$(basename "$f")
					local TYPE="${filename##*.}"
					local NAME="${filename%.*}"
					local SIZE=$(du -BM "$f" | awk '{print $1}')
					local CHANGEDATE=$(ls -Rl "$f" | awk '{print $6, $7}')
					local PERMISSIONS=$(stat -c %A "$f" | awk '{print$1}')
					if file "$f" | grep -qE 'image|bitmap'; 
						then
		    					local IMG=$(identify -format '%wx%h' "$f")
						else
							local IMG=$(echo No);
						fi
					if [[ "$f" = *.MOV || "$f" = *.mp3 || "$f" = *.mp4 || "$f" = *.avi ]]	
						then
							local DUR=$(ffprobe -i "$f" -show_entries format=duration -v quiet -of csv="p=0" -sexagesimal);
						else
							local DUR=$(echo No);
					fi
				echo -e "$f \t$NAME \t$PERMISSIONS \t$TYPE \t$CHANGEDATE \t$SIZE \t$DUR \t$IMG" >> 1.xls 
			fi
			dir=$dirname
		done
		}
filetre
 
