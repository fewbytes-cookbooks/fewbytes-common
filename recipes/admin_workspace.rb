package "vim"
package "bash_completion"
package "less"
package "tmux"

cookbook_file "/root/.vimrc" do
  mode "0644"
end

cookbook_file "/root/.bashrc" do
  mode "0644"
end

cookbook_file "/root/.bash_aliases" do
  mode "0644"
end

remote_directory "/root/.bash_completion.d" do
  mode "0755"
  files_mode "0644"
end

directory "/root" do
  mode "0700"
end

# TODO: tmuxrc

