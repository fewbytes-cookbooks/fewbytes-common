package "vim"
package "vim-scripts"
package "bash-completion"
package "less"
package "curl"
package "screen"
package "tmux"
package "ncdu"
package "pv"
package "htop"
package "util-linux"
package "moreutils"

remote_directory "/root" do
  mode "0700"
  files_mode "0644"
  files_backup 0
end
