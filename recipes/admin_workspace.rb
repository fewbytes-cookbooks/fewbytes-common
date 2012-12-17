package "vim"
package "vim-scripts"
package "bash_completion"
package "less"
package "curl"
package "screen"
package "tmux"

#cookbook_file "/root/.vimrc" do
#  mode "0644"
#end
#
#cookbook_file "/root/.bashrc" do
#  mode "0644"
#end
#
#cookbook_file "/root/.bash_aliases" do
#  mode "0644"
#end

remote_directory "/root" do
  mode "0700"
  files_mode "0644"
  files_backup 0
end

#directory "/root" do
#  mode "0700"
#end

