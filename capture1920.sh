 #!/bin/bash
 reg="\-\?[0-9]\+\.[0-9][0-9][0-9]"
 AsseractNumber ()
{
code=$1
c=`tesseract img_temp/"${code}-2.png" stdout -l eng_dfcf -psm 7 `
echo "$c" >img_temp/"${code}.txt"
}
yes | rm img_temp/*
#l:len(stocks)
#t2
COUNTER=`sed -n '$=' Table.txt`
echo $COUNTER
data_left_x=91
data_left_y=765
c_w=$( expr 480 - $data_left_x)
c_h=$( expr 780 - $data_left_y)
echo "" > img_temp/cIndex.txt
let "ALL_COUNTER = COUNTER"
#first RUN
python getStocks.py
sleep 1
until [  $COUNTER -lt 1 ]; do
    # sleep
    sleep 1
	let "CUR_COUNTER = ALL_COUNTER - COUNTER + 1"
    echo $CUR_COUNTER
    # get name    
    convert screenshot: -crop $( expr 1592 - 1525)x$( expr 77 - 60)+1525+60 img_temp/screen_${CUR_COUNTER}_name.png
	convert img_temp/"screen_${CUR_COUNTER}_name.png" -adaptive-resize 500% -type Grayscale -threshold 50%  -negate img_temp/"screen_${CUR_COUNTER}_name.png"
	code=`tesseract img_temp/"screen_${CUR_COUNTER}_name.png" stdout -psm 7 nobatch digits`
	echo "" > img_temp/"${code}.txt"
    # get data all                                                                                                                       
    convert screenshot: -crop ${c_w}x${c_h}+${data_left_x}+${data_left_y} +repage -channel RGB -separate  img_temp/"${code}.png"
	convert img_temp/"${code}-0.png" -crop 100x$c_h+0+0  +repage img_temp/"${code}-0.png" 
	convert img_temp/"${code}-1.png" -crop $( expr $c_w - 100)x${c_h}+100+0  +repage img_temp/"${code}-1.png" 
	convert img_temp/"${code}-0.png" img_temp/"${code}-1.png"   +append -resize 500% -negate -level 0,240,0.7 img_temp/"${code}-2.png"
	AsseractNumber $code
	#-adaptive-resize -threshold 12%
	#ctemp=`sed -n '$=' img_temp/"${code}.txt"`
	#echo "${code}.${ctemp}"
	#if [ $ctemp -lt 4 ]; then
	#echo 'ctemp_1'
	#convert img_temp/"${code}-0.png" img_temp/"${code}-1.png"  +append -scale 500% -negate img_temp/"${code}-2.png"
	#AsseractNumber $code
	#ctemp=`sed -n '$=' img_temp/"${code}.txt"`
	#if [ $ctemp -lt 4 ]; then
	#echo 'ctemp_2'
	#convert img_temp/"${code}-0.png" img_temp/"${code}-1.png"   +append -adaptive-resize  -negate img_temp/"${code}-2.png"
	#AsseractNumber $code
	#ctemp=`sed -n '$=' img_temp/"${code}.txt"`
	#if [ $ctemp -lt 4 ]; then
	#echo 'ctemp_3'
	#convert img_temp/"${code}-0.png" img_temp/"${code}-1.png"  +append -scale 500% -negate -threshold 12% img_temp/"${code}-2.png"
	#AsseractNumber $code
	#fi
	#fi
	#fi
	echo "d" >> img_temp/cIndex.txt

	sleep 1
    #next stock
    python getStocks.py
    sleep 3
    # increment counter
	let COUNTER-=1
done

python save_to_db.py


