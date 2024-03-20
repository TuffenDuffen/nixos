{ lib, config, pkgs, inputs, ... }:

{
	imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  programs.nixvim= {
    enable = true;
		colorschemes.gruvbox.enable = true;
		globals = {
			mapleader = " ";
			maplocalleader = " ";
			have_nerd_font = true;
		};
		options = {
			number = true;
			relativenumber = true;
			mouse = "a";
			showmode = false;
			clipboard = "unnamedplus";
			breakindent = true;
			undofile = true;
			ignorecase = true;
			smartcase = true;
			signcolumn = "yes";
			updatetime = 250;
			timeoutlen = 300;
			splitright = true;
			splitbelow = true;
			inccommand = "split";
			cursorline = true;
			scrolloff = 10;
			
		};
  };
}
