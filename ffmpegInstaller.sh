#!/opt/bin/bash

#  ffmpeg installation script for Synology DiskStations with ARM Marvell Kirkwood processor
#  
#
#  Created by CutePoisonX
#
ret_cond=-1

endScript ()
{
    if [ $ret_cond == 1 ]; then # reverting preparation...
    	echo "reverting preparation ..."
        mv "$TMP_CPX"/opt/lib/libx264.* /opt/lib/                   > /dev/null 2>&1
        mv "$TMP_CPX"/lib/libx264.* /lib/                           > /dev/null 2>&1
        mv "$TMP_CPX"/usr/lib/libx264.* /usr/lib/                   > /dev/null 2>&1
        mv "$TMP_CPX"/opt/include/x264* /opt/include/               > /dev/null 2>&1
        mv "$TMP_CPX"/usr/local/include/x264* /usr/local/include/   > /dev/null 2>&1

        unlink /opt/arm-none-linux-gnueabi/lib/libdl.so             > /dev/null 2>&1
        unlink /opt/arm-none-linux-gnueabi/lib/libdl.so.2           > /dev/null 2>&1
        mv "$TMP_CPX"/libdl.so /opt/arm-none-linux-gnueabi/lib/     > /dev/null 2>&1
        mv "$TMP_CPX"/libdl.so.2 /opt/arm-none-linux-gnueabi/lib/   > /dev/null 2>&1
    fi
    
    if [ $ret_cond == 2 ]; then # reverting x264 installation
    	if [ $X264_VAR == 1 ]; then
            echo "reverting x264 installation..."
    		cd "$SRC_CPX"/x264/			> /dev/null 2>&1
    		make uninstall				> /dev/null 2>&1
    		make clean	 				> /dev/null 2>&1
    		cd ..
    		rm -r x264					> /dev/null 2>&1
    	fi
    fi
    
    if [ $ret_cond == 3 ]; then # reverting libfaac installation
    	if [ $LIBF_VAR == 1 ]; then
            echo "reverting libfaac installation..."
  			cd "$SRC_CPX"/				> /dev/null 2>&1
  			rm faac-1.28.tar.gz			> /dev/null 2>&1
            cd faac-1.28/				> /dev/null 2>&1
            make uninstall				> /dev/null 2>&1
            make clean					> /dev/null 2>&1
            cd ..
            rm -r faac-1.28				> /dev/null 2>&1
    	fi
    fi
    if [ $ret_cond == 4 ]; then # reverting ffmpeg installation
        echo "reverting ffmpeg installation..."
    	cd "$SRC_CPX"/ffmpeg	> /dev/null 2>&1
    	make uninstall			> /dev/null 2>&1
    	make clean				> /dev/null 2>&1		
    	cd ..
    	rm -r ffmpeg			> /dev/null 2>&1
    fi
    
    if [ $ret_cond -ge 1 -a $disp_error == 1 ]; then 
        echo "(Exiting with error)"
    	echo "If you think there was a bug in the script please report to http://forum.synology.com/enu/viewtopic.php?f=37&t=64609"
		echo "or to CutePoisonXI@gmail.com"
    elif [ $ret_cond == 0 ]; then
    	echo "Exit without errors ... the installation should have succeeded."
    	
    	input="x"
		while [ "$input" != "n" ]; do

    		echo "Do you wish to remove the source-directory (\"/volume1/tmp_ffmpeg_install/\")? [y/n]"
    		read input

    		if [ "$input" == "y" ]; then
    			rm -r /volume1/tmp_ffmpeg_install/ > /dev/null 2>&1
    			if [ $? != 0 ]; then
					echo "Could not remove directory."
				else
					echo "Directory removed."
				fi
        		break
    		fi
		done
    	echo "If you experience any errors with ffmpeg please report to http://forum.synology.com/enu/viewtopic.php?f=37&t=64609"
    	echo "or to CutePoisonXI@gmail.com"  
    fi

}
trap endScript EXIT

#defining convinient variables
TMP_CPX=/volume1/tmp_ffmpeg_install/tmp
SRC_CPX=/volume1/tmp_ffmpeg_install/source

CONF_VAR="--disable-shared --enable-gpl --enable-memalign-hack --enable-version3 --enable-nonfree --disable-armv6 --disable-armv6t2 --disable-ffplay --disable-ffserver --prefix=/opt --disable-neon --disable-asm --enable-avcodec --arch=arm --cpu=armv5te --enable-pthreads --disable-decoder=zmbv --target-os=linux --enable-armv5te"
X264_VAR=1
LIBF_VAR=1
    
disp_error=0

#checking the "reset-command:"
if [ "$1" == "reset" ]; then
	ret_cond=0
	while [ $ret_cond -le 4 ]; do
        ret_cond=$(($ret_cond+1))
        endScript
    done
    ret_cond=-1
    input="x"
	while [ "$input" != "n" ]; do

    	echo "Do you wish to remove the source-directory (\"/volume1/tmp_ffmpeg_install/\")? [y/n]"
    	read input

    	if [ "$input" == "y" ]; then
    		rm -r /volume1/tmp_ffmpeg_install/ > /dev/null 2>&1
    		if [ $? != 0 ]; then
				echo "Could not remove directory."
			else
				echo "Directory removed."
			fi
        	break
    	fi
	done
    exit 0
fi
# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------

# Present script
clear
echo "This is a ffmpeg install script for Synolgy DiskStations with a Marvell Kirkwood processor by CutePoisonX"
echo "It will install x264, libfaac and ffmpeg"
echo "If you want to install other libraries (like lame e.g.), you will have to do it before you execute this script"
echo "Note: you can also install it manually by using this tutorial: http://forum.synology.com/enu/viewtopic.php?f=37&t=64609"
echo "Caution: Only use this script if your DiskStation has the right processor (you check check your processor here: http://forum.synology.com/wiki/index.php/What_kind_of_CPU_does_my_NAS_have)!"
echo "Just to mention this: I'm not responsible for any harm done by this script..."

input="n"
while [ "$input" != "y" ]; do

    echo "Do you wish to continue? [y/n]"
    read input

    if [ "$input" == "n" ]; then
        exit 0
    fi
done

#checking resume condition if condition file exists:
if [ -f "$TMP_CPX"/condition ]; then
	ret_cond=$(sed '1q;d' "$TMP_CPX"/condition)

	if [  "$ret_cond" != "" -a "$ret_cond" != "1" ]; then
		input="x"
		while true; do

    		echo "Do you wish to resume from the previous session? [y/n]"
    		read input

		 	if [ "$input" == "y" ]; then
		 		CONF_VAR=$(sed '2q;d' "$TMP_CPX"/condition)
		 		X264_VAR=$(sed '3q;d' "$TMP_CPX"/condition)
		 		LIBF_VAR=$(sed '4q;d' "$TMP_CPX"/condition)
                break
            elif [ "$input" == "n" ]; then
                while [ $ret_cond -le 4 ]; do
                    ret_cond=$(($ret_cond+1))
                    endScript
                done
                ret_cond=1
                break
		 	fi
		done
	fi
else
	ret_cond=1
fi

disp_error=1
if [ "$ret_cond" == "1" ]; then

    # ------------------------------create directories for installation --------------------------------------------------------------
    echo "Creating necessary directories ..."
    if [ ! -d "/volume1/" ]; then
        echo "The directory /volume1/ does not exist. Can not continue ..."
        exit 1
    fi

    mkdir /volume1/tmp_ffmpeg_install/ > /dev/null 2>&1
    if [ ! -d "/volume1/tmp_ffmpeg_install/" ]; then
        echo "Could not create directory \"/volume1/tmp_ffmpeg_install/\". Can not continue ..."
        exit 1
    fi

    mkdir /volume1/tmp_ffmpeg_install/source/ > /dev/null 2>&1
    mkdir /volume1/tmp_ffmpeg_install/tmp/ > /dev/null 2>&1
    if [ ! -d "/volume1/tmp_ffmpeg_install/source/" ]; then
        echo "Could not create directory \"/volume1/tmp_ffmpeg_install/source/\". Can not continue ..."
        exit 1
    fi
    if [ ! -d "/volume1/tmp_ffmpeg_install/tmp/" ]; then
        echo "Could not create directory \"/volume1/tmp_ffmpeg_install/tmp/\". Can not continue ..."
        exit 1
    fi
    mkdir /volume1/tmp_ffmpeg_install/tmp/opt/ > /dev/null 2>&1
    mkdir /volume1/tmp_ffmpeg_install/tmp/usr/ > /dev/null 2>&1
    mkdir /volume1/tmp_ffmpeg_install/tmp/usr/local/ > /dev/null 2>&1

    mkdir /volume1/tmp_ffmpeg_install/tmp/opt/lib/ > /dev/null 2>&1
    mkdir /volume1/tmp_ffmpeg_install/tmp/usr/lib/ > /dev/null 2>&1
    mkdir /volume1/tmp_ffmpeg_install/tmp/lib/ > /dev/null 2>&1
    mkdir /volume1/tmp_ffmpeg_install/tmp/opt/include/ > /dev/null 2>&1
    mkdir /volume1/tmp_ffmpeg_install/tmp/usr/local/include/ > /dev/null 2>&1
    if [ ! -d "/volume1/tmp_ffmpeg_install/tmp/opt/lib/" ]; then
        echo "Could not create directory \"/volume1/tmp_ffmpeg_install/tmp/opt/lib/\". Can not continue ..."
        exit 1
    fi
    if [ ! -d "/volume1/tmp_ffmpeg_install/tmp/usr/lib/" ]; then
        echo "Could not create directory \"/volume1/tmp_ffmpeg_install/tmp/usr/lib/\". Can not continue ..."
        exit 1
    fi
    if [ ! -d "/volume1/tmp_ffmpeg_install/tmp/lib/" ]; then
        echo "Could not create directory \"/volume1/tmp_ffmpeg_install/tmp/lib/\". Can not continue ..."
        exit 1
    fi
    if [ ! -d "/volume1/tmp_ffmpeg_install/tmp/opt/include/" ]; then
        echo "Could not create directory \"/volume1/tmp_ffmpeg_install/tmp/opt/include/\". Can not continue ..."
        exit 1
    fi
    if [ ! -d "/volume1/tmp_ffmpeg_install/tmp/usr/local/include/" ]; then
        echo "Could not create directory \"/volume1/tmp_ffmpeg_install/tmp/usr/local/include/\". Can not continue ..."
        exit 1
    fi
    echo "Done"
    # ---------------------------------------------------------------------------------------------------------------------------------
    echo $ret_cond > "$TMP_CPX"/condition
    
    #removing previous logfiles
    rm "$TMP_CPX"/x264.log 		> /dev/null 2>&1
    rm "$TMP_CPX"/libfaac.log	> /dev/null 2>&1
    rm "$TMP_CPX"/ffmpeg.log 	> /dev/null 2>&1

    # check for ipkg
    ipkg_check="$(type -P ipkg)"
    if [ "$ipkg_check" == "" ]; then
        echo "Ipkg is not installed. Please install it first. Check the tutorial here: http://forum.synology.com/wiki/index.php/Overview_on_modifying_the_Synology_Server,_bootstrap,_ipkg_etc"
        exit 1
    fi

    # check if directory /opt exists:
    if [ ! -d "/opt/" ]; then
        echo "The directory /opt/ does not exist. Can not continue ..."
        exit 1
    fi

    # install required ipkg packages (still assuming bash is already in /opt/bin of course)
    echo "installing necessary ipkg packages ..."
    ipkg update 					> /dev/null 2>&1
    ipkg install optware-devel		> /dev/null 2>&1
    ipkg install gcc                > /dev/null 2>&1
    ipkg install git				> /dev/null 2>&1
    echo "Done"

    # removing ipkg packages wich interfere
    echo "Removing interfering ipkg packages ..."
    ipkg remove ffmpeg				> /dev/null 2>&1
    ipkg remove x264				> /dev/null 2>&1
    echo "Done"

    # removing previous installations of x264
    echo "Removing previous installations of x264 ..."
    mv /opt/lib/libx264.* "$TMP_CPX"/opt/lib/                   > /dev/null 2>&1
    mv /lib/libx264.* "$TMP_CPX"/lib/                           > /dev/null 2>&1
    mv /usr/lib/libx264.* "$TMP_CPX"/usr/lib/                   > /dev/null 2>&1
    mv /opt/include/x264* "$TMP_CPX"/opt/include/               > /dev/null 2>&1
    mv /usr/local/include/x264* "$TMP_CPX"/usr/local/include/   > /dev/null 2>&1
    echo "Done"
    # assuming this runs without errors....

    # checking version ...
    input="x"
    while true; do

        echo "Are you on DSM 5 or newer? [y/n]"
        read input

        if [ "$input" == "n" ]; then
            break
        elif [ "$input" == "y" ]; then
            #fixing DSM 5 lib issue
            echo "Fixing DSM 5 library issue"
            mv /opt/arm-none-linux-gnueabi/lib/libdl.so "$TMP_CPX"/             > /dev/null 2>&1
            mv /opt/arm-none-linux-gnueabi/lib/libdl.so.2 "$TMP_CPX"/           > /dev/null 2>&1
            ln -s /lib/libdl.so.2 /opt/arm-none-linux-gnueabi/lib/libdl.so      > /dev/null 2>&1
            ln -s /lib/libdl.so.2 /opt/arm-none-linux-gnueabi/lib/libdl.so.2    > /dev/null 2>&1
            echo "Done"
            # assuming this runs without errors....
            break
        fi
    done

    input="x"
    while true; do

        echo "Do you wish to install x264? [y/n]"
        read input

        if [ "$input" == "n" ]; then
            X264_VAR=0
            echo "x264 will NOT be installed"
            break
        elif [ "$input" == "y" ]; then
            X264_VAR=1
            echo "x264 WILL BE installed"
            CONF_VAR="$CONF_VAR"" --enable-libx264"
            break
        fi
    done
    input="x"
    while true; do

        echo "Do you wish to install libfaac? [y/n]"
        read input

        if [ "$input" == "n" ]; then
            LIBF_VAR=0
            echo "libfaac will NOT be installed"
            break
        elif [ "$input" == "y" ]; then
            LIBF_VAR=1
            echo "libfaac WILL BE installed"
            CONF_VAR="$CONF_VAR"" --enable-libfaac"
            break
        fi
    done

    echo ""
    echo "The ffmpeg configuration is now:"

    echo "$CONF_VAR"
    echo ""

    input="x"
    while true; do

        echo "Do you wish to change the configuration and configure ffmpeg manually (this is usefull if you added additional libraries besides x264 and libfaac)? [y/n]"
        read input

        if [ "$input" == "n" ]; then
            break
        elif [ "$input" == "y" ]; then
            echo "Please enter your configuration:"
            read CONF_VAR
            break
        fi
    done

    echo "THE SCRIPT RUNS AUTOMATED NOW. YOU CAN RELAX AND LEAN BACK. THIS WILL TAKE A LONG TIME (PROBABLY SEVERAL HOURS)..."
    read -sn 1 -p "Press any key to start ... "
    echo ""
	
    #preparation done!
    if [ $X264_VAR == 1 ]; then
        ret_cond=2
    else
        if [ $LIBF_VAR == 1 ]; then
            ret_cond=3
        else
            ret_cond=4
        fi
    fi

    echo $ret_cond > "$TMP_CPX"/condition
    echo $CONF_VAR >> "$TMP_CPX"/condition
    echo $X264_VAR >> "$TMP_CPX"/condition
    echo $LIBF_VAR >> "$TMP_CPX"/condition
fi
# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------
if [ "$ret_cond" == "2" ]; then
	cd "$SRC_CPX"
	#installing x264

	echo "Installing x264 now:"
	echo "cloning x264 ..."
	git clone git://git.videolan.org/x264 > /dev/null 2>&1
	if [ $? != 0 ]; then
		echo "Git clone failed ..."
		echo "Can not continue"
		exit 1
	fi
	cd x264
	sed -i 's/^#!.*$/#!\/opt\/bin\/bash/g' configure version.sh >> "$TMP_CPX"/x264.log 2>&1
	if [ $? != 0 ]; then
		echo "Changing shebang to /opt/bin/bash failed ..."
		echo "Can not continue"
		exit 1
	fi

	echo "Configuring x264 ..."
	sh configure --prefix=/opt --enable-shared --disable-asm >> "$TMP_CPX"/x264.log 2>&1
	if [ $? != 0 ]; then
		echo "Configuring x264 failed ..."
		echo "Can not continue"
		exit 1
	fi

	echo "\"make\" x264 ..."
	make >> "$TMP_CPX"/x264.log 2>&1
	if [ $? != 0 ]; then
		echo "\"make\" failed ..."
		echo "Can not continue"
		exit 1
	fi
	echo "\"make install\" x264 ..."
	make install >> "$TMP_CPX"/x264.log 2>&1
	if [ $? != 0 ]; then
		echo "\"make install\" failed ..."
		echo "Can not continue"
		exit 1
	fi
	
	#coping library to /lib
	cp /opt/lib/libx264.so.* /lib > /dev/null 2>&1
	
	echo "Done"

    if [ $LIBF_VAR == 1 ]; then
        ret_cond=3
    else
        ret_cond=4
    fi

    echo $ret_cond > "$TMP_CPX"/condition
    echo $CONF_VAR >> "$TMP_CPX"/condition
    echo $X264_VAR >> "$TMP_CPX"/condition
    echo $LIBF_VAR >> "$TMP_CPX"/condition
fi

if [ "$ret_cond" == "3" ]; then
	cd "$SRC_CPX"
	#installing libfaac

	echo "Installing libfaac now:"
	echo "downloading libfaac ..."
	wget http://downloads.sourceforge.net/faac/faac-1.28.tar.gz	> /dev/null 2>&1
	if [ $? != 0 ]; then
		echo "Could not download libfaac ..."
		echo "Can not continue"
		exit 1
	fi
	echo "extracting libfaac ..."
	tar xfv faac-1.28.tar.gz	> /dev/null 2>&1
	if [ $? != 0 ]; then
		echo "Could not extract libfaac ..."
		echo "Can not continue"
		exit 1
	fi

	cd faac-1.28
	sed -i 's/^#!.*$/#!\/opt\/bin\/bash/g' configure > /dev/null 2>&1
	if [ $? != 0 ]; then
		echo "Changing shebang to /opt/bin/bash failed ..."
		echo "Can not continue"
		exit 1
	fi

	echo "configuring libfaac ..."
	sh configure --prefix=/opt --enable-shared --disable-asm >> "$TMP_CPX"/libfaac.log 2>&1
	if [ $? != 0 ]; then
		echo "Configuring libfaac failed ..."
		echo "Can not continue"
		exit 1
	fi

	echo "\"make\" libfaac ..."
	make >> "$TMP_CPX"/libfaac.log 2>&1
	if [ $? != 0 ]; then
		echo "\"make\" failed ..."
		echo "Can not continue"
		exit 1
	fi
	
	echo "\"make install\" libfaac ..."
	make install >> "$TMP_CPX"/libfaac.log 2>&1
	if [ $? != 0 ]; then
		echo "\"make install\" failed ..."
		echo "Can not continue"
		exit 1
	fi

	echo "Done"
    ret_cond=4
    echo $ret_cond > "$TMP_CPX"/condition
    echo $CONF_VAR >> "$TMP_CPX"/condition
    echo $X264_VAR >> "$TMP_CPX"/condition
    echo $LIBF_VAR >> "$TMP_CPX"/condition
fi
# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------
#library installation done
#installing ffmpeg!
if [ "$ret_cond" == "4" ]; then
    cd "$SRC_CPX"

    echo "Installing ffmpeg ..."
    echo "cloning ffmpeg ..."
    git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg > /dev/null 2>&1
    if [ $? != 0 ]; then
        echo "Git clone failed ..."
        echo "Can not continue"
        exit 1
    fi

    cd ffmpeg

    sed -i 's/^#!.*$/#!\/opt\/bin\/bash/g' configure > /dev/null 2>&1
    if [ $? != 0 ]; then
        echo "Changing shebang to /opt/bin/bash failed ..."
        echo "Can not continue"
        exit 1
    fi

    echo "configuring ffmpeg ..."
    ./configure $CONF_VAR >> "$TMP_CPX"/ffmpeg.log 2>&1
    if [ $? != 0 ]; then
        echo "Configuring ffmpeg failed ..."
        echo "Can not continue"
        exit 1
    fi

    echo "\"make\" ffmpeg ..."
    make >> "$TMP_CPX"/ffmpeg.log 2>&1
    if [ $? != 0 ]; then
        echo "\"make\" failed ..."
        echo "Can not continue"
        exit 1
    fi

    echo "\"make install\" ffmpeg ..."
    make install >> "$TMP_CPX"/ffmpeg.log 2>&1
    if [ $? != 0 ]; then
        echo "\"make install\" failed ..."
        echo "Can not continue"
        exit 1
    fi
fi

rm "$TMP_CPX"/condition > /dev/null 2>&1
ret_cond=0

exit 0