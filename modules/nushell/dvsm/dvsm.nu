# dvsm is a devspace manager written in nu

# You can set a default path for dvsm new with this variable
const default_path = 'projects'

const flakes = {
  rust: '{
  description = "dvsm Rust flake";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
 };

  outputs = { self, nixpkgs, rust-overlay }: 
    let
      system = "x86_64-linux";
      name = "dvsm";
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };
      rustToolchain = pkgs.rust-bin.stable.latest.default.override {
            extensions = [ "rust-src" "rust-analyzer" ];
      };
    in 
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          openssl
          pkg-config
          rustToolchain
          cargo-watch
          cargo-deny
        ];
        inherit system name;
      };
    };
}
'
}

# Enter a devspace
export def main [
  name: string  # The name of the devspace
] {
  let path = try {
    open $'($env.HOME)/.cache/dvsm/devspaces.nuon'
  } catch { return $'There are no devspaces! Create one using (ansi bo)dvsm new(ansi reset) or add an existing one using (ansi bo)dvsm add' }
  | where name == $name
  | get 0.path
  | path expand
  cd $path
  nix develop -c zellij a --create $name
}

# List devspaces
export def list [] {
  try {
    open $'($env.HOME)/.cache/dvsm/devspaces.nuon'
  } catch { $'There are no devspaces! Create one using (ansi bo)dvsm new(ansi reset) or add an existing one using (ansi bo)dvsm add' }
}

export def flakes [] {
 $flakes | transpose name content | get name
}

# Create a new devspace
export def new [
  name: string                        # Name of the devspace
  flake: string                       # The name of the flake (list available templates using dvsm flakes)
  --path: directory = $default_path   # The path to the directory in which to put the devspace
  ] {
  let full_path = $path | path expand
  if $full_path == '' {
    return 'No path specified, use the --path flag or set a default path by editing the script!'
  }
  if not ($full_path | path exists) {
    return $'The specified path does not exist, please create "($path)"'
  }
  if $name in ( try { open $'($env.HOME)/.cache/dvsm/devspaces.nuon' | get name } catch { [] } ) {
    return `Can't have two devspaces with the same name, select another name!`
  }
  if $flake not-in (flakes) {
    return $'Flake ($flake) not found! List available flakes using (ansi bo)dvsm flakes'
  }
  mkdir $'($full_path)/($name)'
  cd $'($full_path)/($name)'
  $flakes | get $flake | save flake.nix
  git init -b main
  git add flake.nix
  add $name $'($full_path)/($name)'
  nix develop -c zellij -s $name
}

# Add an existing devspace to devspaces.nuon
export def add [name: string path: path] {
  let full_path = $path | path expand
  if ($'($env.HOME)/.cache/dvsm/devspaces.nuon' | path exists) {
    let devspaces = open $'($env.HOME)/.cache/dvsm/devspaces.nuon'
    if $name in ($devspaces | get name) { return `Can't have two devspaces with the same name, select another name!` }
    $devspaces | append [[name path]; [$name $full_path]] 
  } else {
    mkdir $'($env.HOME)/.cache/dvsm'
    touch $'($env.HOME)/.cache/dvsm/devspaces.nuon'
    [[name path]; [$name $full_path]] 
  }
  | to nuon
  | save -f $'($env.HOME)/.cache/dvsm/devspaces.nuon'
}


# Remove devspaces from devspaces.nuon
export def forget [
  ...names: string # devspace names (allows multiple names)
] {
  try {
    open $'($env.HOME)/.cache/dvsm/devspaces.nuon'
  } catch { return $'There are no devspaces! Create one using (ansi bo)dvsm new(ansi reset) or add an existing one using (ansi bo)dvsm add' }
  | where name not-in $names
  | to nuon
  | save -f $'($env.HOME)/.cache/dvsm/devspaces.nuon'
}
