#!/opt/bin/bash

#  ffmpeg installation script for Synology DiskStations
#  
#
#  Created by CutePoisonX
#
RET_COND=-1
set -x
endScript ()
{
    if [ $RET_COND == 1 ]; then # reverting preparation...
    	echo "reverting preparation ..."
        mv "$TMP_CPX"/opt/lib/libx264.* /opt/lib/                   > /dev/null 2>&1
        mv "$TMP_CPX"/lib/libx264.* /lib/                           > /dev/null 2>&1
        mv "$TMP_CPX"/usr/lib/libx264.* /usr/lib/                   > /dev/null 2>&1
        mv "$TMP_CPX"/opt/include/x264* /opt/include/               > /dev/null 2>&1
        mv "$TMP_CPX"/usr/local/include/x264* /usr/local/include/   > /dev/null 2>&1

        unlinkDSM5libraries
    fi
    
    if [ $RET_COND == 2 ]; then # reverting x264 installation
    	if [ $X264_VAR == 1 ]; then
            echo "reverting x264 installation..."
    		cd "$SRC_CPX"/x264/			> /dev/null 2>&1
    		make uninstall				> /dev/null 2>&1
    		make clean	 				> /dev/null 2>&1
            echo "Refer to the logfile for further information: \"/volume1/tmp_ffmpeg_install/tmp/x264.log\"."
    	fi
    fi
    
    if [ $RET_COND == 3 ]; then # reverting libfaac installation
    	if [ $LIBF_VAR == 1 ]; then
            echo "reverting libfaac installation..."
  			cd "$SRC_CPX"/				> /dev/null 2>&1
  			rm faac-1.28.tar.gz			> /dev/null 2>&1
            cd faac-1.28/				> /dev/null 2>&1
            make uninstall				> /dev/null 2>&1
            make clean					> /dev/null 2>&1
            echo "Refer to the logfile for further information: \"/volume1/tmp_ffmpeg_install/tmp/libfaac.log\"."
    	fi
    fi
    if [ $RET_COND == 4 ]; then # reverting ffmpeg installation
        echo "reverting ffmpeg installation..."
    	cd "$SRC_CPX"/ffmpeg	> /dev/null 2>&1
    	make uninstall			> /dev/null 2>&1
    	make clean				> /dev/null 2>&1
        echo "Refer to the logfile for further information: \"/volume1/tmp_ffmpeg_install/tmp/ffmpeg.log\"."
    fi
    
    if [ $RET_COND -ge 1 -a $disp_error == 1 ]; then 
        echo "(Exiting with error)"
    	echo "If you think there was a bug in the script please report to http://forum.synology.com/enu/viewtopic.php?f=37&t=64609"
		echo "or to CutePoisonXI@gmail.com"
    elif [ $RET_COND == 0 ]; then
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

translateDSModelToProcessor ()
{
    #aks for the model and returns a number, depending on which processor is used in the DS
    #
    # ARM familiy:
    # 1: ARM (armv5b)
    # 2: Marvell Feroceon ARMv5TE compliant (armv5tejl)
    # 3: Marvell Kirkwood ARMv5TE compliant (Feroceon family)
    # 4: Marvell ARMADA ARMv7
    # 5: Mindspeed Comcerto 2000 ARMv7
    #
    # PowerPC family:
    # 6: Freescale PowerPC (ppc_6xx)
    # 7: Freescale PowerPC (e500v*)
    #
    # Intel family:
    # 8: Intel Atom
    # 9: Intel Core i3

    echo "Please enter the model of your Synology DiskStation (like e.g. DS213, DS211+, CS407e, etc...)"
    local input=""
    local cpu_var=""

    while true; do
        read input

        # 1:
        if [ "$input" == "DS101" ]; then
            cpu_var=1
        fi
        if [ "$input" == "DS101j" ]; then
            cpu_var=1
        fi

        # 2:
        if [ "$input" == "DS107+" ]; then
            cpu_var=2
        fi
        if [ "$input" == "DS207+" ]; then
            cpu_var=2
        fi
        if [ "$input" == "CS407" ]; then
            cpu_var=2
        fi
        if [ "$input" == "RS407" ]; then
            cpu_var=2
        fi

        # 3:
        if [ "$input" == "DS109" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS110j" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS112j" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS209" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS210j" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS211j" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS212j" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS409" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS409slim" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS410j" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS411j" ]; then
            cpu_var=3
        fi
        if [ "$input" == "RS409" ]; then
            cpu_var=3
        fi

        if [ "$input" == "DS111" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS112" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS211" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS211+" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS212" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS213air" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS411slim" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS413j" ]; then
            cpu_var=3
        fi
        if [ "$input" == "RS212" ]; then
            cpu_var=3
        fi

        if [ "$input" == "DS112+" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS212+" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS213" ]; then
            cpu_var=3
        fi
        if [ "$input" == "DS411" ]; then
            cpu_var=3
        fi

        # 4:
        if [ "$input" == "DS114" ]; then
            cpu_var=4
        fi
        if [ "$input" == "DS213j" ]; then
            cpu_var=4
        fi
        if [ "$input" == "DS214se" ]; then
            cpu_var=4
        fi
        if [ "$input" == "DS414slim" ]; then
            cpu_var=4
        fi
        if [ "$input" == "EDS14" ]; then
            cpu_var=4
        fi
        if [ "$input" == "RS214" ]; then
            cpu_var=4
        fi

        if [ "$input" == "DS214" ]; then
            cpu_var=4
        fi
        if [ "$input" == "DS214+" ]; then
            cpu_var=4
        fi
        if [ "$input" == "DS414" ]; then
            cpu_var=4
        fi
        if [ "$input" == "RS814" ]; then
            cpu_var=4
        fi

        # 5:
        if [ "$input" == "DS214air" ]; then
            cpu_var=5
        fi
        if [ "$input" == "DS414j" ]; then
            cpu_var=5
        fi

        # 6:
        if [ "$input" == "DS101g+" ]; then
            cpu_var=6
        fi
        if [ "$input" == "DS106e" ]; then
            cpu_var=6
        fi
        if [ "$input" == "DS106" ]; then
            cpu_var=6
        fi
        if [ "$input" == "DS106x" ]; then
            cpu_var=6
        fi
        if [ "$input" == "DS107" ]; then
            cpu_var=6
        fi
        if [ "$input" == "DS107e" ]; then
            cpu_var=6
        fi
        if [ "$input" == "DS109j" ]; then
            cpu_var=6
        fi
        if [ "$input" == "DS207" ]; then
            cpu_var=6
        fi
        if [ "$input" == "DS207.128" ]; then
            cpu_var=6
        fi
        if [ "$input" == "DS209j" ]; then
            cpu_var=6
        fi
        if [ "$input" == "DS406e" ]; then
            cpu_var=6
        fi
        if [ "$input" == "CS407e" ]; then
            cpu_var=6
        fi

        if [ "$input" == "DS106j" ]; then
            cpu_var=6
        fi
        if [ "$input" == "DS108j" ]; then
            cpu_var=6
        fi

        if [ "$input" == "CS406" ]; then
            cpu_var=6
        fi
        if [ "$input" == "RS406" ]; then
            cpu_var=6
        fi

        # 7:
        if [ "$input" == "DS109+" ]; then
            cpu_var=7
        fi
        if [ "$input" == "DS209+II" ]; then
            cpu_var=7
        fi
        if [ "$input" == "DS409+" ]; then
            cpu_var=7
        fi
        if [ "$input" == "DS509+" ]; then
            cpu_var=7
        fi
        if [ "$input" == "RS409(RP)+" ]; then
            cpu_var=7
        fi

        if [ "$input" == "DS209+" ]; then
            cpu_var=7
        fi
        if [ "$input" == "DS408" ]; then
            cpu_var=7
        fi
        if [ "$input" == "DS508" ]; then
            cpu_var=7
        fi
        if [ "$input" == "RS408(RP)" ]; then
            cpu_var=7
        fi

        if [ "$input" == "DS110+" ]; then
            cpu_var=7
        fi
        if [ "$input" == "DS210+" ]; then
            cpu_var=7
        fi
        if [ "$input" == "DS410" ]; then
            cpu_var=7
        fi

        if [ "$input" == "DS213+" ]; then
            cpu_var=7
        fi
        if [ "$input" == "DS413" ]; then
            cpu_var=7
        fi

        # 8:
        if [ "$input" == "DS710+" ]; then
            cpu_var=8
        fi

        if [ "$input" == "DS411+II" ]; then
            cpu_var=8
        fi
        if [ "$input" == "DS1010+" ]; then
            cpu_var=8
        fi
        if [ "$input" == "RS810(RP)+" ]; then
            cpu_var=8
        fi

        if [ "$input" == "DS411+II" ]; then
            cpu_var=8
        fi
        if [ "$input" == "DS1511+" ]; then
            cpu_var=8
        fi
        if [ "$input" == "RS2211+" ]; then
            cpu_var=8
        fi
        if [ "$input" == "DS2411+" ]; then
            cpu_var=8
        fi

        if [ "$input" == "DS712+" ]; then
            cpu_var=8
        fi

        if [ "$input" == "DS713+" ]; then
            cpu_var=8
        fi
        if [ "$input" == "DS412+" ]; then
            cpu_var=8
        fi
        if [ "$input" == "DS1512+" ]; then
            cpu_var=8
        fi
        if [ "$input" == "DS1812+" ]; then
            cpu_var=8
        fi
        if [ "$input" == "DS1513+" ]; then
            cpu_var=8
        fi
        if [ "$input" == "DS1813+" ]; then
            cpu_var=8
        fi
        if [ "$input" == "DS2413+" ]; then
            cpu_var=8
        fi
        if [ "$input" == "RS814(RP)+" ]; then
            cpu_var=8
        fi
        if [ "$input" == "RS2414(RP)+" ]; then
            cpu_var=8
        fi

        if [ "$input" == "DS214play" ]; then
            cpu_var=8
        fi
        if [ "$input" == "DS415play" ]; then
            cpu_var=8
        fi

        # 9:
        if [ "$input" == "DS3611xs" ]; then
            cpu_var=9
        fi
        if [ "$input" == "RS3411xs" ]; then
            cpu_var=9
        fi
        if [ "$input" == "RS3411(RP)xs" ]; then
            cpu_var=9
        fi


        if [ "$input" == "abort" ]; then
            exit 1
        fi
        if [ "$cpu_var" == "" ]; then
            echo "DS model not found. Please try again or abort by writing \"abort\"."
        else
            break
        fi
    done

    return "$cpu_var"
}

assignSpecificVars ()
{
    #first (and only) argument is the DS-processor

    LIBDL_DIR=""
    X264_CONF_VAR=""
    LIBF_CONF_VAR=""
    FFMPEG_CONF_VAR=""

    local found_config=0

    if [ "$1" == 1 ]; then
        echo "Detected cpu: ARM"
    fi
    if [ "$1" == 2 ]; then
        echo "Detected cpu: Marvell Feroceon ARMv5TE compliant"

        LIBDL_DIR="arm-none-linux-gnueabi"
        X264_CONF_VAR="--prefix=/opt --enable-shared --disable-asm"
        LIBF_CONF_VAR="--prefix=/opt --enable-shared --disable-asm"
        FFMPEG_CONF_VAR="--enable-shared --enable-gpl --enable-memalign-hack --enable-version3 --enable-nonfree --disable-armv6 --disable-armv6t2 --disable-ffplay --disable-ffserver --prefix=/opt --disable-neon --disable-asm --enable-avcodec --arch=arm --cpu=armv5te --enable-pthreads --disable-decoder=zmbv --target-os=linux --enable-armv5te"

        WGET_SSL_IPKG_PACKAGE_URL="http://ipkg.nslu2-linux.org/feeds/optware/syno-x07/cross/unstable/wget-ssl_1.12-2_arm.ipk"

        found_config=1
    fi
    if [ "$1" == 3 ]; then
        echo "Detected cpu: Marvell Kirkwood ARMv5TE compliant"

        LIBDL_DIR="arm-none-linux-gnueabi"
        X264_CONF_VAR="--prefix=/opt --enable-shared --disable-asm"
        LIBF_CONF_VAR="--prefix=/opt --enable-shared --disable-asm"
        FFMPEG_CONF_VAR="--enable-shared --enable-gpl --enable-memalign-hack --enable-version3 --enable-nonfree --disable-armv6 --disable-armv6t2 --disable-ffplay --disable-ffserver --prefix=/opt --disable-neon --disable-asm --enable-avcodec --arch=arm --cpu=armv5te --enable-pthreads --disable-decoder=zmbv --target-os=linux --enable-armv5te"

        WGET_SSL_IPKG_PACKAGE_URL="http://ipkg.nslu2-linux.org/feeds/optware/cs08q1armel/cross/unstable/wget-ssl_1.12-2_arm.ipk"

        found_config=1
    fi
    if [ "$1" == 4 ]; then
        echo "Detected cpu: Marvell ARMADA ARMv7"

        LIBDL_DIR="arm-none-linux-gnueabi"
        X264_CONF_VAR="--prefix=/opt --enable-shared --disable-asm"
        LIBF_CONF_VAR="--prefix=/opt --enable-shared --disable-asm"
        FFMPEG_CONF_VAR="--target-os=linux --enable-optimizations --enable-shared --disable-ffserver --disable-ffplay --enable-gpl --prefix=/opt"

        LINK_LIBC=true

        WGET_SSL_IPKG_PACKAGE_URL="http://ipkg.nslu2-linux.org/feeds/optware/cs08q1armel/cross/unstable/wget-ssl_1.12-2_arm.ipk"

        found_config=1
    fi
    if [ "$1" == 5 ]; then
        echo "Detected cpu: Mindspeed Comcerto 2000 ARMv7"
    fi
    if [ "$1" == 6 ]; then
        echo "Detected cpu: Freescale PowerPC"
    fi
    if [ "$1" == 7 ]; then
        echo "Detected cpu: Freescale PowerPC"

        LIBDL_DIR="powerpc-linux-gnuspe"
        X264_CONF_VAR="--prefix=/opt --enable-shared --disable-asm"
        LIBF_CONF_VAR="--prefix=/opt --enable-shared --disable-asm"
        FFMPEG_CONF_VAR="--arch=powerpc --target-os=linux --enable-optimizations --enable-shared --disable-ffserver --disable-ffplay --enable-gpl --prefix=/opt --disable-altivec"
        X264_ADD_CONF_MOD="sed -i 's/CFLAGS=\"\$CFLAGS -maltivec -mabi=altivec\"/CFLAGS=\"$CFLAGS\"/' configure"

        LINK_LIBM=true
        LINK_LIBAVCODEC=true
        LINK_LIBSWSCALE=true
        LINK_LIBAVUTIL=true
        LINK_AVFORMAT=true

        WGET_SSL_IPKG_PACKAGE_URL="http://ipkg.nslu2-linux.org/feeds/optware/syno-e500/cross/unstable/wget-ssl_1.12-2_powerpc.ipk"

        found_config=1
    fi
    if [ "$1" == 8 ]; then
        echo "Detected cpu: Intel Atom"

        LIBDL_DIR="i686-linux-gnu"
        X264_CONF_VAR="--prefix=/opt --enable-shared --host=i686-linux"
        LIBF_CONF_VAR="--prefix=/opt --enable-shared"
        FFMPEG_CONF_VAR="--arch=i686 --target-os=linux --enable-optimizations --disable-altivec --enable-pic --enable-shared --disable-swscale-alpha --disable-ffserver --disable-ffplay --enable-nonfree --enable-version3 --enable-gpl --disable-doc --prefix=/opt"

        YASM_COMPATIBLE=true

        WGET_SSL_IPKG_PACKAGE_URL="http://ipkg.nslu2-linux.org/feeds/optware/syno-i686/cross/unstable/wget-ssl_1.12-2_i686.ipk"

        found_config=1
    fi
    if [ "$1" == 9 ]; then
        echo "Detected cpu: Intel Core i3"
    fi

    if [ "$found_config" == "1" ]; then
        echo "Found a viable configuration for your DiskStation."
    else
        echo "Did not find a viable configuration for the specified DS model. Maybe your model is not supported yet."
        echo "Cannot continue ..."
        echo "Please contact me in this thread: http://forum.synology.com/enu/viewtopic.php?f=37&t=64609, on github: https://github.com/CutePoisonX/ffmpegInstaller or send a mail to CutePoisonXI@gmail.com if you want your DS to be supported by this script."
        exit 1
    fi
}

readFromConditionFile ()
{
    # assumes that file exists and that it is valid
    X264_CONF_VAR=$(sed '2q;d' "$TMP_CPX"/condition)
    LIBF_CONF_VAR=$(sed '3q;d' "$TMP_CPX"/condition)
    FFMPEG_CONF_VAR=$(sed '4q;d' "$TMP_CPX"/condition)
    X264_VAR=$(sed '5q;d' "$TMP_CPX"/condition)
    LIBF_VAR=$(sed '6q;d' "$TMP_CPX"/condition)
    LIBDL_DIR=$(sed '7q;d' "$TMP_CPX"/condition)

    LINK_LIBM=$(sed '8q;d' "$TMP_CPX"/condition)
    LINK_LIBAVCODEC=$(sed '9q;d' "$TMP_CPX"/condition)
    LINK_LIBSWSCALE=$(sed '10q;d' "$TMP_CPX"/condition)
    LINK_LIBAVUTIL=$(sed '11q;d' "$TMP_CPX"/condition)
    LINK_AVFORMAT=$(sed '12q;d' "$TMP_CPX"/condition)

    WGET_SSL_IPKG_PACKAGE_URL=$(sed '13q;d' "$TMP_CPX"/condition)
}

writeToConditionFile ()
{
    echo $RET_COND > "$TMP_CPX"/condition
    echo $X264_CONF_VAR >> "$TMP_CPX"/condition
    echo $LIBF_CONF_VAR >> "$TMP_CPX"/condition
    echo $FFMPEG_CONF_VAR >> "$TMP_CPX"/condition
    echo $X264_VAR >> "$TMP_CPX"/condition
    echo $LIBF_VAR >> "$TMP_CPX"/condition
    echo $LIBDL_DIR >> "$TMP_CPX"/condition

    echo $LINK_LIBM >> "$TMP_CPX"/condition
    echo $LINK_LIBAVCODEC >> "$TMP_CPX"/condition
    echo $LINK_LIBSWSCALE >> "$TMP_CPX"/condition
    echo $LINK_LIBAVUTIL >> "$TMP_CPX"/condition
    echo $LINK_AVFORMAT >> "$TMP_CPX"/condition

    echo $WGET_SSL_IPKG_PACKAGE_URL >> "$TMP_CPX"/condition
}

writeToConditionFileFinished ()
{
    echo 1 > "$TMP_CPX"/condition
    echo $X264_CONF_VAR >> "$TMP_CPX"/condition
    echo $LIBF_CONF_VAR >> "$TMP_CPX"/condition
    echo $FFMPEG_CONF_VAR >> "$TMP_CPX"/condition
    echo 1 >> "$TMP_CPX"/condition
    echo 1 >> "$TMP_CPX"/condition
    echo $LIBDL_DIR >> "$TMP_CPX"/condition

    echo $LINK_LIBM >> "$TMP_CPX"/condition
    echo $LINK_LIBAVCODEC >> "$TMP_CPX"/condition
    echo $LINK_LIBSWSCALE >> "$TMP_CPX"/condition
    echo $LINK_LIBAVUTIL >> "$TMP_CPX"/condition
    echo $LINK_AVFORMAT >> "$TMP_CPX"/condition

    echo $WGET_SSL_IPKG_PACKAGE_URL >> "$TMP_CPX"/condition
}

linkDSM5libraries ()
{
    echo "Fixing DSM 5 library issue"

    #first, the libdl.so library:
    cp /opt/"$LIBDL_DIR"/lib/libdl.so "$TMP_CPX"/               > /dev/null 2>&1
    rm /opt/"$LIBDL_DIR"/lib/libdl.so                           > /dev/null 2>&1
    cp /opt/"$LIBDL_DIR"/lib/libdl.so.2 "$TMP_CPX"/             > /dev/null 2>&1
    rm /opt/"$LIBDL_DIR"/lib/libdl.so.2                         > /dev/null 2>&1
    ln -s /lib/libdl.so.2 /opt/"$LIBDL_DIR"/lib/libdl.so        > /dev/null 2>&1
    ln -s /lib/libdl.so.2 /opt/"$LIBDL_DIR"/lib/libdl.so.2      > /dev/null 2>&1

    #specific libraries:
    if [ "$LINK_LIBC" == "true" ]; then
        cp /opt/"$LIBDL_DIR"/lib/libc.so "$TMP_CPX"
        rm /opt/"$LIBDL_DIR"/lib/libc.so
        cp /opt/"$LIBDL_DIR"/lib/libc.so.6 "$TMP_CPX"
        rm /opt/"$LIBDL_DIR"/lib/libc.so.6
        ln -s /lib/libc.so.6 /opt/"$LIBDL_DIR"/lib/libc.so
        ln -s /lib/libc.so.6 /opt/"$LIBDL_DIR"/lib/libc.so.6
    fi
    if [ "$LINK_LIBM" == "true" ]; then
        cp /opt/"$LIBDL_DIR"/lib/libm.so "$TMP_CPX"             > /dev/null 2>&1
        rm /opt/"$LIBDL_DIR"/lib/libm.so                        > /dev/null 2>&1
        cp /opt/"$LIBDL_DIR"/lib/libm.so.6 "$TMP_CPX"           > /dev/null 2>&1
        rm /opt/"$LIBDL_DIR"/lib/libm.so.6                      > /dev/null 2>&1
        ln -s /lib/libm.so.6 /opt/"$LIBDL_DIR"/lib/libm.so      > /dev/null 2>&1
        ln -s /lib/libm.so.6 /opt/"$LIBDL_DIR"/lib/libm.so.6    > /dev/null 2>&1
    fi
    if [ "$LINK_LIBAVCODEC" == "true" ]; then
        cp /opt/"$LIBDL_DIR"/lib/libavcodec.so "$TMP_CPX"                       > /dev/null 2>&1
        rm /opt/"$LIBDL_DIR"/lib/libavcodec.so                                  > /dev/null 2>&1
        cp /opt/"$LIBDL_DIR"/lib/libavcodec.so.55 "$TMP_CPX"                    > /dev/null 2>&1
        rm /opt/"$LIBDL_DIR"/lib/libavcodec.so.55                               > /dev/null 2>&1
        ln -s /lib/libavcodec.so.55 /opt/"$LIBDL_DIR"/lib/libavcodec.so         > /dev/null 2>&1
        ln -s /lib/libavcodec.so.55 /opt/"$LIBDL_DIR"/lib/libavcodec.so.55      > /dev/null 2>&1
    fi
    if [ "$LINK_LIBSWSCALE" == "true" ]; then
        cp /opt/"$LIBDL_DIR"/lib/libswscale.so "$TMP_CPX"                       > /dev/null 2>&1
        rm /opt/"$LIBDL_DIR"/lib/libswscale.so                                  > /dev/null 2>&1
        cp /opt/"$LIBDL_DIR"/lib/libswscale.so.2 "$TMP_CPX"                     > /dev/null 2>&1
        rm /opt/"$LIBDL_DIR"/lib/libswscale.so.2                                > /dev/null 2>&1
        ln -s /lib/libswscale.so.2 /opt/"$LIBDL_DIR"/lib/libswscale.so          > /dev/null 2>&1
        ln -s /lib/libswscale.so.2 /opt/"$LIBDL_DIR"/lib/libswscale.so.2        > /dev/null 2>&1
    fi
    if [ "$LINK_LIBAVUTIL" == "true" ]; then
        cp /opt/"$LIBDL_DIR"/lib/libavutil.so "$TMP_CPX"                        > /dev/null 2>&1
        rm /opt/"$LIBDL_DIR"/lib/libavutil.so                                   > /dev/null 2>&1
        cp /opt/"$LIBDL_DIR"/lib/libavutil.so.52 "$TMP_CPX"                     > /dev/null 2>&1
        rm /opt/"$LIBDL_DIR"/lib/libavutil.so.52                                > /dev/null 2>&1
        ln -s /lib/libavutil.so.52 /opt/"$LIBDL_DIR"/lib/libavutil.so           > /dev/null 2>&1
        ln -s /lib/libavutil.so.52 /opt/"$LIBDL_DIR"/lib/libavutil.so.52        > /dev/null 2>&1
    fi
    if [ "$LINK_AVFORMAT" == "true" ]; then
        cp /opt/"$LIBDL_DIR"/lib/libavformat.so "$TMP_CPX"                      > /dev/null 2>&1
        rm /opt/"$LIBDL_DIR"/lib/libavformat.so                                 > /dev/null 2>&1
        cp /opt/"$LIBDL_DIR"/lib/libavformat.so.55 "$TMP_CPX"                   > /dev/null 2>&1
        rm /opt/"$LIBDL_DIR"/lib/libavformat.so.55                              > /dev/null 2>&1
        ln -s /lib/libavformat.so.55 /opt/"$LIBDL_DIR"/lib/libavformat.so       > /dev/null 2>&1
        ln -s /lib/libavformat.so.55 /opt/"$LIBDL_DIR"/lib/libavformat.so.55    > /dev/null 2>&1
    fi

    echo "Done"
}

unlinkDSM5libraries ()
{
    unlink /opt/"$LIBDL_DIR"/lib/libdl.so             > /dev/null 2>&1
    unlink /opt/"$LIBDL_DIR"/lib/libdl.so.2           > /dev/null 2>&1
    mv "$TMP_CPX"/libdl.so /opt/"$LIBDL_DIR"/lib/     > /dev/null 2>&1
    mv "$TMP_CPX"/libdl.so.2 /opt/"$LIBDL_DIR"/lib/   > /dev/null 2>&1

    if [ "$LINK_LIBC" == "true" ]; then
        unlink /opt/"$LIBDL_DIR"/lib/libc.so             > /dev/null 2>&1
        unlink /opt/"$LIBDL_DIR"/lib/libc.so.6           > /dev/null 2>&1
        mv "$TMP_CPX"/libc.so /opt/"$LIBDL_DIR"/lib/     > /dev/null 2>&1
        mv "$TMP_CPX"/libc.so.6 /opt/"$LIBDL_DIR"/lib/   > /dev/null 2>&1
    fi
    if [ "$LINK_LIBM" == "true" ]; then
        unlink /opt/"$LIBDL_DIR"/lib/libm.so             > /dev/null 2>&1
        unlink /opt/"$LIBDL_DIR"/lib/libm.so.6           > /dev/null 2>&1
        mv "$TMP_CPX"/libm.so /opt/"$LIBDL_DIR"/lib/     > /dev/null 2>&1
        mv "$TMP_CPX"/libm.so.6 /opt/"$LIBDL_DIR"/lib/   > /dev/null 2>&1
    fi
    if [ "$LINK_LIBAVCODEC" == "true" ]; then
        unlink /opt/"$LIBDL_DIR"/lib/libavcodec.so             > /dev/null 2>&1
        unlink /opt/"$LIBDL_DIR"/lib/libavcodec.so.55          > /dev/null 2>&1
        mv "$TMP_CPX"/libavcodec.so /opt/"$LIBDL_DIR"/lib/     > /dev/null 2>&1
        mv "$TMP_CPX"/libavcodec.so.55 /opt/"$LIBDL_DIR"/lib/  > /dev/null 2>&1
    fi
    if [ "$LINK_LIBSWSCALE" == "true" ]; then
        unlink /opt/"$LIBDL_DIR"/lib/libswscale.so             > /dev/null 2>&1
        unlink /opt/"$LIBDL_DIR"/lib/libswscale.so.2           > /dev/null 2>&1
        mv "$TMP_CPX"/libswscale.so /opt/"$LIBDL_DIR"/lib/     > /dev/null 2>&1
        mv "$TMP_CPX"/libswscale.so.2 /opt/"$LIBDL_DIR"/lib/   > /dev/null 2>&1
    fi
    if [ "$LINK_LIBAVUTIL" == "true" ]; then
        unlink /opt/"$LIBDL_DIR"/lib/libavutil.so             > /dev/null 2>&1
        unlink /opt/"$LIBDL_DIR"/lib/libavutil.so.52          > /dev/null 2>&1
        mv "$TMP_CPX"/libavutil.so /opt/"$LIBDL_DIR"/lib/     > /dev/null 2>&1
        mv "$TMP_CPX"/libavutil.so.52 /opt/"$LIBDL_DIR"/lib/  > /dev/null 2>&1
    fi
    if [ "$LINK_AVFORMAT" == "true" ]; then
        unlink /opt/"$LIBDL_DIR"/lib/libavformat.so             > /dev/null 2>&1
        unlink /opt/"$LIBDL_DIR"/lib/libavformat.so.55          > /dev/null 2>&1
        mv "$TMP_CPX"/libavformat.so /opt/"$LIBDL_DIR"/lib/     > /dev/null 2>&1
        mv "$TMP_CPX"/libavformat.so.55 /opt/"$LIBDL_DIR"/lib/  > /dev/null 2>&1
    fi
}

installOptwareDevel ()
{
    ipkg list_installed | grep "optware-devel" > /dev/null 2>&1
    if [ $? != 0 ]; then

        echo "Installing optware-devel ..."
        ipkg install -force-overwrite optware-devel 2>&1 | grep "ERROR: The following packages conflict with wget-ssl:" > /dev/null 2>&1
        if [ $? == 0 ]; then
            echo "Fixing wget-ssl conflict ..."
            local wget_ssl_pkg=${WGET_SSL_IPKG_PACKAGE_URL##*/}

            ipkg install libidn                                                 > /dev/null 2>&1
            wget -O "$TMP_CPX"/"$wget_ssl_pkg" "$WGET_SSL_IPKG_PACKAGE_URL"     > /dev/null 2>&1
            if [ $? != 0 ]; then
                echo "Getting wget-ssl-package failed ..."
                echo "Can not continue"
                exit 1
            fi

            ipkg remove wget                            > /dev/null 2>&1
            ipkg install "$TMP_CPX"/"$wget_ssl_pkg"     > /dev/null 2>&1
            if [ $? != 0 ]; then
                echo "Installing wget-ssl-package failed ..."
                echo "Can not continue"
                exit 1
            fi

            ipkg update                                 > /dev/null 2>&1
            ipkg upgrade                                > /dev/null 2>&1
            ipkg install -force-overwrite optware-devel > /dev/null 2>&1
            if [ $? != 0 ]; then
                echo "An unknown error occured during the installation of optware-devel ..."
                echo "Can not continue"
                exit 1
            fi
        fi
    fi
}

installNewerYasmVersion ()
{
    echo "Installing newer yasm version ..."
    cd "$SRC_CPX"
    ipkg remove yasm > /dev/null 2>&1

    echo "downloading yasm ..."
    echo "DOWNLOADING yasm" > "$TMP_CPX"/yasm.log 2>&1
    wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz >> "$TMP_CPX"/yasm.log 2>&1
    if [ $? != 0 ]; then
        echo "Getting yasm failed ..."
        echo "Can not continue"
        exit 1
    fi

    echo "extracting yasm ..."
    echo "EXTRACTING yasm" >> "$TMP_CPX"/yasm.log 2>&1
    tar -xf yasm-1.3.0.tar.gz >> "$TMP_CPX"/yasm.log 2>&1
    if [ $? != 0 ]; then
        echo "Extracting yasm failed ..."
        echo "Can not continue"
        exit 1
    fi
    cd yasm-1.3.0

    echo "configuring yasm ..."
    echo "CONFIGURING yasm" >> "$TMP_CPX"/yasm.log 2>&1
    ./configure >> "$TMP_CPX"/yasm.log 2>&1
    if [ $? != 0 ]; then
        echo "Configuring yasm failed ..."
        echo "For further information why it failed refer to the file: \"/volume1/tmp_ffmpeg_install/source/yasm-1.2.0/config.log\"."
        echo "Can not continue"
        exit 1
    fi

    echo "\"make\" yasm ..."
    echo "\"MAKE\" yasm ..." >> "$TMP_CPX"/yasm.log 2>&1
    make >> "$TMP_CPX"/yasm.log 2>&1
    if [ $? != 0 ]; then
        echo "\"making\" yasm failed ..."
        echo "Can not continue"
        exit 1
    fi

    echo "\"make install\" yasm ..."
    echo "\"MAKE INSTALL\" yasm ..." >> "$TMP_CPX"/yasm.log 2>&1
    make install >> "$TMP_CPX"/yasm.log 2>&1
    if [ $? != 0 ]; then
        echo "Installing yasm failed ..."
        echo "Can not continue"
        exit 1
    fi
}

############################################################################################################### BODY ###############################################################################################################
####################################################################################################################################################################################################################################
####################################################################################################################################################################################################################################
####################################################################################################################################################################################################################################

#defining convinient variables
TMP_CPX=/volume1/tmp_ffmpeg_install/tmp
SRC_CPX=/volume1/tmp_ffmpeg_install/source

LIBDL_DIR=""
X264_CONF_VAR=""
LIBF_CONF_VAR=""
FFMPEG_CONF_VAR=""
X264_VAR=1
LIBF_VAR=1
    
disp_error=0

# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------

# Present script
clear
echo "This is a ffmpeg install script for Synolgy DiskStations by CutePoisonX"
echo "It will install x264, libfaac and ffmpeg."
echo "If you want to install other libraries (like lame e.g.), you will have to do it before you execute this script"
echo "Note: you can also install it manually by using this tutorial: http://forum.synology.com/enu/viewtopic.php?f=37&t=64609"
echo "Just to mention this: I'm not responsible for any harm done by this script..."

######################################################################################################################################
#checking the "reset-command:"
if [ "$1" == "reset" ]; then

    if [ -f "$TMP_CPX"/condition ]; then
        readFromConditionFile
        RET_COND=0
        while [ $RET_COND -le 4 ]; do
            RET_COND=$(($RET_COND+1))
            endScript
        done
        RET_COND=-1
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
    else
        echo "Could not find condition-file to reset session (cannot reset)..."
        exit 0
    fi
fi
######################################################################################################################################

input="n"
while [ "$input" != "y" ]; do

    echo "Do you wish to continue? [y/n]"
    read input

    if [ "$input" == "n" ]; then
        exit 0
    fi
done

######################################################################################################################################
#checking resume condition if condition file exists:
if [ -f "$TMP_CPX"/condition ]; then
	RET_COND=$(sed '1q;d' "$TMP_CPX"/condition)

	if [  "$RET_COND" != "" -a "$RET_COND" != "1" ]; then
		input="x"
		while true; do

    		echo "Do you wish to resume from the previous session? [y/n]"
    		read input

		 	if [ "$input" == "y" ]; then
		 		readFromConditionFile
                break
            elif [ "$input" == "n" ]; then
                while [ $RET_COND -le 4 ]; do
                    RET_COND=$(($RET_COND+1))
                    endScript
                done
                    translateDSModelToProcessor
                    assignSpecificVars "$?"
                    RET_COND=1
                break
		 	fi
		done
    else
        translateDSModelToProcessor
        assignSpecificVars "$?"
        RET_COND=1
	fi
else
    translateDSModelToProcessor
    assignSpecificVars "$?"
	RET_COND=1
fi
######################################################################################################################################

if [ "$FFMPEG_CONF_VAR" == "" -o "$LIBDL_DIR" == "" ]; then
    echo "Did not find a viable configuration for the specified DS model. Maybe your model is not supported yet."
    echo "Cannot continue ..."
    echo "Please contact me in this thread: http://forum.synology.com/enu/viewtopic.php?f=37&t=64609, on github: https://github.com/CutePoisonX/ffmpegInstaller or write me a mail: CutePoisonXI@gmail.com if you want that your DS is supported in this script."
    exit 1
fi

disp_error=1
if [ "$RET_COND" == "1" ]; then

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
    echo $RET_COND > "$TMP_CPX"/condition
    
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
    ipkg install gcc                > /dev/null 2>&1
    ipkg install git				> /dev/null 2>&1
    installOptwareDevel
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

        if [ "$input" == "y" ]; then
            #fixing DSM 5 lib issue
            linkDSM5libraries
            # assuming this runs without errors....
            # disabling yasm on DSM5 even if compatible:
            if [ "$YASM_COMPATIBLE" == "true" ]; then
                FFMPEG_CONF_VAR="$FFMPEG_CONF_VAR"" --disable-asm"
                X264_CONF_VAR="$X264_CONF_VAR"" --disable-asm"
                LIBF_CONF_VAR="$LIBF_CONF_VAR"" --disable-asm"
            fi
            break

        elif [ "$input" == "n" ]; then
            #installing newer yasm-version
            if [ "$YASM_COMPATIBLE" == "true" ]; then
                PROCESSING_YASM=1
                installNewerYasmVersion
                PROCESSING_YASM=0
            fi
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
            FFMPEG_CONF_VAR="$FFMPEG_CONF_VAR"" --enable-libx264"
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
            FFMPEG_CONF_VAR="$FFMPEG_CONF_VAR"" --enable-libfaac"
            break
        fi
    done

    echo ""
    echo "The ffmpeg configuration is now:"

    echo "$FFMPEG_CONF_VAR"
    echo ""

    input="x"
    while true; do

        echo "Do you wish to change the configuration and configure ffmpeg manually (this is usefull if you added additional libraries besides x264 and libfaac)? [y/n]"
        read input

        if [ "$input" == "n" ]; then
            break
        elif [ "$input" == "y" ]; then
            echo "Please enter your configuration:"
            read FFMPEG_CONF_VAR
            break
        fi
    done

    echo "THE SCRIPT RUNS AUTOMATED NOW. YOU CAN RELAX AND LEAN BACK. THIS WILL TAKE A LONG TIME (PROBABLY SEVERAL HOURS)..."
    read -sn 1 -p "Press any key to start ... "
    echo ""
	
    #preparation done!
    if [ $X264_VAR == 1 ]; then
        RET_COND=2
    else
        if [ $LIBF_VAR == 1 ]; then
            RET_COND=3
        else
            RET_COND=4
        fi
    fi

    writeToConditionFile
fi
# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------
if [ "$RET_COND" == "2" ]; then
	cd "$SRC_CPX"
	#installing x264

	echo "Installing x264 now:"
	echo "cloning x264 ..."
    echo "CLONING x264" > "$TMP_CPX"/x264.log 2>&1
	git clone git://git.videolan.org/x264 >> "$TMP_CPX"/x264.log 2>&1
	if [ $? != 0 ]; then
		echo "Git clone failed ..."
		echo "Can not continue"
		exit 1
	fi
	cd x264
	sed -i 's/^#!.*$/#!\/opt\/bin\/bash/g' configure version.sh > /dev/null 2>&1
	if [ $? != 0 ]; then
		echo "Changing shebang to /opt/bin/bash failed ..."
		echo "Can not continue"
		exit 1
	fi

    #processor specific action ...
    eval $X264_ADD_CONF_MOD > /dev/null 2>&1

	echo "Configuring x264 ..."
    echo "CONFIGURING x264" >> "$TMP_CPX"/x264.log 2>&1
	sh configure $X264_CONF_VAR >> "$TMP_CPX"/x264.log 2>&1
	if [ $? != 0 ]; then
		echo "Configuring x264 failed ..."
        echo "For further information why it failed refer to the file: \"/volume1/tmp_ffmpeg_install/source/x264/config.log\"."
		echo "Can not continue"
		exit 1
	fi

	echo "\"make\" x264 ..."
	echo "\"MAKE\" x264 ..." >> "$TMP_CPX"/x264.log 2>&1
	make >> "$TMP_CPX"/x264.log 2>&1
	if [ $? != 0 ]; then
		echo "\"make\" failed ..."
		echo "Can not continue"
		exit 1
	fi
	echo "\"make install\" x264 ..."
    echo "\"MAKE INSTALL\" x264 ..." >> "$TMP_CPX"/x264.log 2>&1
	make install >> "$TMP_CPX"/x264.log 2>&1
	if [ $? != 0 ]; then
		echo "\"make install\" failed ..."
		echo "Can not continue"
		exit 1
	fi
	echo "Done"

    if [ $LIBF_VAR == 1 ]; then
        RET_COND=3
    else
        RET_COND=4
    fi

    writeToConditionFile
fi

if [ "$RET_COND" == "3" ]; then
	cd "$SRC_CPX"
	#installing libfaac

	echo "Installing libfaac now:"
	echo "downloading libfaac ..."
    echo "DOWNLOADING libfaac" > "$TMP_CPX"/libfaac.log 2>&1
	wget http://downloads.sourceforge.net/faac/faac-1.28.tar.gz >> "$TMP_CPX"/libfaac.log 2>&1
	if [ $? != 0 ]; then
		echo "Could not download libfaac ..."
		echo "Can not continue"
		exit 1
	fi
	echo "extracting libfaac ..."
    echo "EXTRACTING libfaac" >> "$TMP_CPX"/libfaac.log 2>&1
	tar -xf faac-1.28.tar.gz >> "$TMP_CPX"/libfaac.log 2>&1
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
    echo "CONFIGURING libfaac" >> "$TMP_CPX"/libfaac.log 2>&1
	sh configure $LIBF_CONF_VAR >> "$TMP_CPX"/libfaac.log 2>&1
	if [ $? != 0 ]; then
		echo "Configuring libfaac failed ..."
        echo "For further information why it failed refer to the file: \"/volume1/tmp_ffmpeg_install/source/faac-1.28/config.log\"."
		echo "Can not continue"
		exit 1
	fi

	echo "\"make\" libfaac ..."
	echo "\"MAKE\" libfaac ..." >> "$TMP_CPX"/libfaac.log 2>&1
	make >> "$TMP_CPX"/libfaac.log 2>&1
	if [ $? != 0 ]; then
		echo "\"make\" failed ..."
		echo "Can not continue"
		exit 1
	fi
	
	echo "\"make install\" libfaac ..."
    echo "\"MAKE INSTALL\" libfaac ..." >> "$TMP_CPX"/libfaac.log 2>&1
	make install >> "$TMP_CPX"/libfaac.log 2>&1
	if [ $? != 0 ]; then
		echo "\"make install\" failed ..."
		echo "Can not continue"
		exit 1
	fi

	echo "Done"
    RET_COND=4
    writeToConditionFile
fi
# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------
#library installation done
#installing ffmpeg!
if [ "$RET_COND" == "4" ]; then
    cd "$SRC_CPX"

    echo "Installing ffmpeg ..."
    echo "cloning ffmpeg ..."
    echo "CLONING ffmpeg" > "$TMP_CPX"/ffmpeg.log 2>&1
    git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg >> "$TMP_CPX"/ffmpeg.log 2>&1
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
    echo "CONFIGURING ffmpeg" >> "$TMP_CPX"/ffmpeg.log 2>&1
    ./configure $FFMPEG_CONF_VAR >> "$TMP_CPX"/ffmpeg.log 2>&1
    if [ $? != 0 ]; then
        echo "Configuring ffmpeg failed ..."
        echo "For further information why it failed refer to the file: \"/volume1/tmp_ffmpeg_install/source/ffmpeg/config.log\"."
        echo "Can not continue"
        exit 1
    fi

    echo "\"make\" ffmpeg ..."
	echo "\"MAKE\" ffmpeg ..." >> "$TMP_CPX"/ffmpeg.log 2>&1
    make >> "$TMP_CPX"/ffmpeg.log 2>&1
    if [ $? != 0 ]; then
        echo "\"make\" failed ..."
        echo "Can not continue"
        exit 1
    fi

    echo "\"make install\" ffmpeg ..."
    echo "\"MAKE INSTALL\" ffmpeg ..." >> "$TMP_CPX"/ffmpeg.log 2>&1
    make install >> "$TMP_CPX"/ffmpeg.log 2>&1
    if [ $? != 0 ]; then
        echo "\"make install\" failed ..."
        echo "Can not continue"
        exit 1
    fi

    #copying necessary libraries:
    RET_COND=5
    while true; do

        /opt/bin/ffmpeg 2>&1 | grep "error while loading shared libraries" > /dev/null 2>&1
        if [ $? != 0 ]; then
            #no missing libraries
            break
        else
            lib=$(/opt/bin/ffmpeg 2>&1 | sed 's/.*libraries: //' | sed 's/:.*//')

            #trying to copy the missing shared libraries
            cp /opt/lib/"$lib" /lib/ > /dev/null 2>&1
            if [ $? != 0 ]; then
                echo "Could not copy ""$lib"" to /lib. Can not continue. Note: ffmpeg is installed successfully but can not start. Maybe you try to locate the shared library yourself and copy it to /lib."
                exit 1
            fi
        fi
    done
fi

writeToConditionFileFinished
RET_COND=0

exit 0
