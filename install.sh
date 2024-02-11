#!/bin/bash

SYSTEM=$uname

setup_vim() {
	DEPS=(
		libcurl git cmake \
	)
	CMAKE_BUILD_TYPE=RelWithDebInfo

	for dependency in "$DEPS[@]"; do
		echo 'Installing $dependency'

		sudo apt install dependency -y 2&1>/dev/null
		
		echo 'Successfully installed: $dependency'
	done

	make $CMAKE_BUILD_TYPE && sudo make install

	echo 'Successfully Neovim'

}

install_packer() {

	PACK_PATH=$HOME/.local/share/nvim/site/pack/
	PACKER=packer.nvim
	
	echo 'Installing packer into $PACK_PATH'
	mkdir -p $PACK_PATH
	git clone --depth 1 https://github.com/wbthomason/$PACKER \
		$PACK_PATH 2>/dev/null
}


# TODO: Invoke the calls dependending on the system
setup_vim()
install_packer()
