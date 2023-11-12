OLD_WEST="/root/west.yml.old"

if [[ ! -f .west/config ]]; then
	west init -l app/
fi

if [[ -f $OLD_WEST ]]; then
	md5_old=$(md5sum $OLD_WEST | cut -d' ' -f1)
fi

if [[ $md5_old != $(md5sum app/west.yml | cut -d' ' -f1) ]]; then
	west update
	cp app/west.yml "$OLD_WEST"
fi