#
# ~/.bash_profile
#

if [ -e ~/.profile ]
then
    source ~/.profile
fi;

if [ -e ~/.bashrc ]
then
    source ~/.bashrc
fi;

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]
then
    source ~/.nix-profile/etc/profile.d/nix.sh;
fi
