This script performs an automatic installation of ffmpeg on Synology DiskStations with ARM processors. The script was tested with a Marvel Kirkwood cpu. Other cpus may not work.

Requirements: The script will only work if you have ipkg installed on your DS (see e.g.: http://forum.synology.com/wiki/index.php/Overview_on_modifying_the_Synology_Server,_bootstrap,_ipkg_etc) and bash is installed in /opt/bin/. The installation of bash in /opt/bin/ is easy with ipkg - just do: "ipkg install bash" in the command line.

To install the script on your DiskStation perform the following steps:

1) ssh with root account into your DS

2) clone repo with: "git clone https://github.com/CutePoisonX/ffmpegInstaller"

3) cd into the directory: "cd ffmpegInstaller"

4) make script executable: chmod +x ffmpegInstaller.sh

5) run script: ./ffmpegInstaller.sh

Note: if you want to reset all changes that the script made to your DiskStation, execute the script with:
"./ffmpegInstaller.sh reset"

The script will ask you some questions before it starts. It attempts to create a directory in /volume1, so make sure /volume1 is available. If you experience any bugs, please report them. I'm not responsible for any harm done by this script.
