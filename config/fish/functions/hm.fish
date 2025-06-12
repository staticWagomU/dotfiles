function hm --description "Home Manager switch function"
    set hostname (hostname)
    
    if test (count $argv) -eq 0
        # 引数なしの場合
        home-manager switch --flake ".#$hostname"
    else if test "$argv[1]" = "--init"
        # --initオプションが渡された場合
        nix run home-manager/master -- switch --flake ".#$hostname"
    else
        echo "Usage: hm [--init]"
        echo "  hm         : Run home-manager switch --flake .#<hostname>"
        echo "  hm --init  : Run nix run home-manager/master -- switch --flake .#<hostname>"
        return 1
    end
end
