package "bash-completion"
package "curl"
package "dstat"
package "htop"
package "less"
package "locate"
package "lsof"
package "moreutils"
package "ncdu"
package "ntp"
package "ntpdate"
package "psmisc"
package "pv"
package "rsync"
package "screen"
package "sysstat"
package "tcpdump"
package "tmux"
package "unzip"
package "util-linux"
package "vim"
package "vim-scripts"


remote_directory "/root" do
  mode "0700"
  files_mode "0644"
  files_backup 0
end
