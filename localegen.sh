#!/bin/sh
if test $2'x' = 'x'; then
 echo "Usage: $0 <module_name> <locale>"
 echo "  e.g. $0 wiki en_US"
 echo " Note: If a <module_name>.po file already exists it will be updated with the new messages from the sourcecode.  "
 exit;
fi
while true; do
  echo -n "Are you sure you want to update/generate the locale for $2 ? (Y/n) "
  read yn
  case $yn in
    '' | y* | Y* ) break ;;
    [nN]* )   exit ;;
    * ) echo "Unknown response.  Asking again" ;;
  esac
done

# remember the current dir
home=`pwd`

# Mod Locale Directory, now known as MLD
MLD=locale/$2/LC_MESSAGES
# create default locale directories for this language
mkdir --verbose -p $MLD

# if <module_name>.po already exists in the module dir, move it out of the way
if [ -f "$MLD/$1.po" ]
then
    mv $MLD/$1.po $MLD/old_$1_file.po
fi

# create the latest and greatest new messages po file
find . -name '*.php' -print0 | xargs -0 xgettext -s --no-location --language=PHP -o $MLD/new_$1.po
if [ -f "$MLD/new_$1.po" ]
then
    if [ -f $MLD/old_$1_file.po ]
    then
        # If there allready was an old messages.po file, merge de old changes into a brand new messages.po file
        msgmerge $MLD/old_$1_file.po $MLD/new_$1.po --output-file=$MLD/$1.po
        rm $MLD/old_$1_file.po
        rm $MLD/new_$1.po
    else
        # move new messages file to an initial module messages.po file
        mv $MLD/new_$1.po $MLD/$1.po
    fi
else
    echo "No dgettext strings found for this module\n"
fi

# go home again
cd $home

#done
