ffmpegInstaller
===============

This script performs an automatic installation of ffmpeg on Synology DiskStations.
Optionally, you can use it to automatically install x264 and libfaac on your DiskStation.


I released the script in hope that it will be useful to others. If you like the script and want to support the development, please consider making a donation. Your support is greatly appreciated!


<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=mediaware%2efactory%40gmail%2ecom&lc=US&item_name=ffmpegInstaller&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif" alt="[paypal]" /></a>

## The script was tested with the following cpus:

1) Marvell Kirkwood ARMv5TE compliant

2) Intel Atom

3) Freescale PowerPC (e500v)

In order to check whether your DS is supported, take a look at: https://github.com/CutePoisonX/ffmpegInstaller/wiki

Requirements: The script will only work if you have ipkg installed on your DS (see e.g.: http://forum.synology.com/wiki/index.php/Overview_on_modifying_the_Synology_Server,_bootstrap,_ipkg_etc) and bash is installed in /opt/bin/. The installation of bash in /opt/bin/ is easy with ipkg - just do: "ipkg install bash" in the command line.

## Installation on Synology DiskStations

1) ssh with root account into your DS

2) clone repo with: "git clone https://github.com/CutePoisonX/ffmpegInstaller"

3) cd into the directory: "cd ffmpegInstaller"

4) make script executable: chmod +x ffmpegInstaller.sh

5) run script: ./ffmpegInstaller.sh

Note: if you want to reset all changes that the script made to your DiskStation, execute the script with:
"./ffmpegInstaller.sh reset"

The script will ask you some questions before it starts. It attempts to create a directory in /volume1, so make sure /volume1 is available. If you experience any bugs, please report them. I'm not responsible for any harm done by this script.

## Credits

Sincere thanks to [tobiasvogel](https://github.com/tobiasvogel) for adding support for lame (mp3) and the RS411 model.
