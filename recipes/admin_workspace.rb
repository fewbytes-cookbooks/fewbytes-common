package "vim"
package "vim-scripts"
package "bash-completion"
package "less"
package "curl"
package "screen"
package "tmux"

remote_directory "/root" do
  mode "0700"
  files_mode "0644"
  files_backup 0
end
