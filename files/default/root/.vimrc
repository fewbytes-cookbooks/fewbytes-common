" ==================================================================
" File:     $HOME/.vimrc
" Purpose:  *Personal* Setup file for the editor Vim (Vi IMproved)
"           It contains everything which I use *personally*.
" Author:   Sven Guckes guckes@vim.org (guckes@math.fu-berlin.de)
"           <URL:http://www.math.fu-berlin.de/~guckes/sven/>
" Latest change:  Tue May 28 21:45:42 MEST 2002
" ==================================================================

" ==================================================================
" Mind you, this file is only a setup file for *personal* use.
" The BIG setup file which I created for *all* users ("vimrc.forall")
" is available in my setup file directory:
" http://www.math.fu-berlin.de/~guckes/setup/vimrc.forall    (uncompressed)
" http://www.math.fu-berlin.de/~guckes/setup/vimrc.forall.gz (compressed)
" Enjoy!  Feedback is very welcome!  :-)
" ==================================================================

" ======================================
" Loading general setup files first
" ======================================

" The PCs at math.fu-berlin.de run WindowsNT-4 and
" the home directory is mounted on drive Z: -
" so when you start up Vim on one of those machines
"
" if has("dos16") || has("dos32") || has("gui_win32")
" naaah.  I don't use that DOS version. ;-)
"
" if has("gui_win32")
"   " Source the setup file for all users:
"   source Z:\\.vimrc.forall
"   " About 42 lines fit nicely on that screen:
"   set lines=42
" endif
"
  if has("unix")
    " Source the setup file for all users:
    let FILE=expand("~/.vimrc.forall")
    if filereadable(FILE)
      exe "source " . FILE
    endif
"    let FILE=expand("~/.vimrc.ira")
"    if filereadable(FILE)
"      exe "source " . FILE
"    endif
    let FILE=expand("~/.vimrc.pythonide")
    if filereadable(FILE)
      exe "source " . FILE
    endif
"   let FILE=expand("~sven/.vimrc.forall")
"   if filereadable(FILE)
"     exe "source " . FILE
"   endif
  endif
"
" ===================
" Settings of Options
" ===================

"     list & listchars
  set list   listchars=tab:»·,trail:·
" set list   listchars=tab:¯ú,trail:ú
" TN3270 does not show high-bit characters:
" set listchars=tab:>.,trail:o

"    Turn on HighLightSearching:
" se hls
" sometimes I need this, sometimes I dont...

"     wildmenu!  this makes use of the command line to show
"     possible matches on buffernames and filenames - yay!
  if version>=508
    set wildmenu
  endif

" ==============
" Autocommands
" ==============

" When editing HTML files (aka webpages)
" expand the "keywords" by characters "colon" and "slash"
" so you can expand URL prefixes as "words", eg
" http://www.math.fu-berlin.de/~guckes/vim/  ;-)
  if version>=508
    au FileType html set isk+=:,/,~
  endif

" Silly test message to check the filepattern for message files:
" au BufRead .followup,.article,.letter,mutt* echo "Editing Messages\!"

" au BufCreate * set term=vt220
" au BufCreate * set term=ansi
" map ''' :set term=vt220<cr>:set term=ansi<cr>

" setting initial position after reading a file into a buffer:
" au BufReadPost * normal 2G10|

" ==============
" Abbreviations
" ==============

" ABbreviations
" personal addresses:
"  ab MYUSERNAME guckes
"  ab MYDOMAIN   math.fu-berlin.de
"  ab MYMAIL     guckes@math.fu-berlin.de
" ab MYHOMEPAGE http://www.guckes.net/
"  ab MYHOMEPAGE http://www.math.fu-berlin.de/~guckes/

" Linux Events in Europe:
" LinuxTage Braunschweig, Chemnitz, StPoelten, Stuttgart.
" iab HPLTB http://braunschweiger.linuxtag.de
" iab HPLTC http://www.tu-chemnitz.de/linux/tag/
"  iab HPLTC http://www.tu-chemnitz.de/linux/tag/lt4/
"  iab HPLTM http://www.mdlug.de/index.php3/linuxtag2001/
"  iab HSTP  http://www.math.fu-berlin.de/~guckes/stpoelten/
"  iab HPLT  http://www.math.fu-berlin.de/~guckes/linuxtag2002/

" Names of cities in Germany and Austria
"  iab DE    Deutschland
"  iab OE    Oesterreich
  "
"  iab BE    Berlin
"  iab CH    Chemnitz
"  iab KA    Karlsruhe
"  iab MD    Magdeburg
"  iab STP   StPoelten

" ============================================================
" Project related abbreviations and mappings
" ============================================================

" "BootTalk" - taslk at the bootlab:
"  iab UBT   http://bootlab.org/talk/
"  map #B gg}OFcc: +BOOTLAB<esc>

" LinuxTage in Chemnitz http://go.to/linuxtag
" http://www.tu-chemnitz.de/linux/tag/lt4/
"  map #C gg}OFcc: +CHEMNITZ<esc>

" Ganesha's Projects
" http://www.ganeshas-projects.de
"  map #G gg}OFcc: +GANESHA<esc>

" LinuxTag Karlsruhe 2002
" 2002-06-06 -- 2002-06-09
"  map #K gg}OFcc: +KARLSRUHE<esc>

" Linux Camp 2002
" http://www.linux-camp-2002.de
" 2002-05-17 - 2002-05-20
" map #L gg}OFcc: +LUGCAMP<esc>

" Linux Tag Magdeburg
" 2002-05-25
" http://www.mdlug.de/index.php/linuxtag2002/main.inc?menu=0|
"  map #M gg}OFcc: +MAGDEBURG<esc>

" www.linuxinfotage.de
" September 15th+16th 2001
" September 25th+26th 2002 (maybe)
"  map #LIT gg}OFcc: +INFOTAGE<esc>
"  iab YLIT Linux Infotage
"  iab ULIT www.linuxinfotage.de

" ============================================================
" Projects
" ============================================================

" Ganesha's Project
" see http://www.ganeshas-project.org
" map #G gg}OFcc: +GANESHA<esc>
" iab UGP  http://www.ganeshas-project.org
" iab IGP        info@ganeshas-project.org
" iab SBSS  Shree Bachhauli Secondary School

" OpenWebSchool project
" http://www.openwebschool.de
"  iab YOWS  OpenWebSchool
"  map #O gg}OFcc: +OWS<esc>


" ==============
" Colorization
" ==============

" Colorize some default highlight groups
" see ":help highlight-default"

"    Comments: Colorizing the "comments" (see ":help comments").
"    cyan on white does not look good on a black background..
  hi comment                           ctermfg=cyan   ctermbg=black
" hi comment                           ctermfg=cyan   ctermbg=7

" hi Cursor
" hi Directory
" hi ErrorMsg
" hi FoldColumn
" hi Folded
" hi IncSearch

"    LineNr:  Colorize the line numbers (displayed with "set number").
"    Turn off default underlining of line numbers:
  hi LineNr       term=NONE cterm=NONE

" hi ModeMsg
" hi MoreMsg

" coloring "nontext", ie TABs, trailing spaces,  end-of-lines,
" and the "tilde lines" representing lines after end-of-buffer.
  hi NonText      term=NONE cterm=NONE ctermfg=blue   ctermbg=black

"    Normal text:    Use white on black.
" hi normal ctermfg=white ctermbg=black   guifg=white guibg=black
  hi normal ctermfg=grey  ctermbg=black   guifg=grey  guibg=black
" Oops - this overrides the colors for the status line - DANG!

" hi Question

"    Search: Coloring "search matches".  Use white on red.
  hi search  ctermfg=white ctermbg=red     guifg=white guibg=red

" hi SpecialKey

"    statusline:  coloring the status line
  hi StatusLine   term=NONE cterm=NONE ctermfg=yellow ctermbg=red
  hi StatusLineNC term=NONE cterm=NONE ctermfg=black  ctermbg=white

" hi Title
" hi VertSplit
" hi Visual
" hi VisualNOS
" hi WarningMsg
" hi WildMenu

" Other Groups:

"    Normal:  Coloring the text with a default color.
  hi normal       term=NONE

" ==============
" Mappings
" ==============

" Attribution Fixing: from "Last, First" to "First Last":
  map ,ATT gg}jWdWWPX

" ============================================================
" Options() - used to display some important option values
" within the status line (see below at "set statusline".
" ============================================================
"
" Statusline without colors and display of options -
" but with percentage at end:
  set statusline=Vim-%{Version()}\ [%02n]\ %(%M%R%H%)\ %F\ %=<%l,%c%V>\ %P
"
" Damien WYART <wyart@iie.cnam.fr> [000329]:
" set statusline=%<%f%=\ [%1*%M%*%n%R%H]\ \ %-25(%3l,%c%03V\ \ %P\ (%L)%)%12o'%03b'
" hi  User1 term=inverse,bold cterm=inverse,bold ctermfg=red

fu! Options()
"           let opt="Opt:"
            let opt=""
  " autoindent
" if &ai|   let opt=opt." ai"   |else|let opt=opt." noai"   |endif
  if &ai|   let opt=opt." ai"   |endif
  "  expandtab
" if &et|   let opt=opt." et"   |else|let opt=opt." noet"   |endif
  if &et|   let opt=opt." et"   |endif
  "  hlsearch
" if &hls|  let opt=opt." hls"  |else|let opt=opt." noet"   |endif
  if &hls|  let opt=opt." hls"  |endif
  "  paste
" if &paste|let opt=opt." paste"|else|let opt=opt." nopaste"|endif
  if &paste|let opt=opt." paste"|endif
  "  shiftwidth
  if &shiftwidth!=8|let opt=opt." sw=".&shiftwidth|endif
  "  textwidth - show always!
                    let opt=opt." tw=".&tw
"   let opt=opt."\[".&lines.",".&columns."\]"
  return opt
endf

" ============================================================
" Colorizing that status lines!  Whee!  :-)
" ============================================================
"
" Statusline without colors and display of options -
" but with percentage at end:
" set statusline=Vim-%{Version()} [%02n]\ %(%M%R%H%)\ %F\ %=<%l,%c%V>\ %P

" set   statusline=Vim-%{Version()}\ %{getcwd()}\ \ %1*[%02n]%*\ %(%M%R%H%)\ %2*%F%*\ %=%{Options()}\ %3*<%l,%c%V>%*
" Text between "%{" and "%}" is being evaluated and thus suited for functions.
" Here I will use the function "Options()" as defined below to show the
" values of some (local) options..
" The strings "%N*" unto "%*" correspond to the highlight group "UserN":
"       User1: color for buffer number
" hi    User1 cterm=NONE    ctermfg=red    ctermbg=white  guifg=red    guibg=white
"       User2: color for filename
" hi    User2 cterm=NONE    ctermfg=green  ctermbg=white  guifg=green  guibg=white
"       User3: color for position
" hi    User3 cterm=NONE    ctermfg=blue   ctermbg=white  guifg=blue   guibg=white

fu! Version()
	return version
endf

" ============================================================

" visual mode:  'p' to replace current text
" with previous copied/deleted text: [010126]
  vmap p d"0P

" weed search stats of atomz.com:
  map #ws vip:s/^ \+- //<cr>vip:s/ for "\(\w\+\)"/ \1/<cr>

" =====================================================
" KILL QUOTED SIGNATURE
" =====================================================

" when mutt starts up the editor then it will give it
" a temporary filename of "/tmp/mutt*".
" when the temporary file gets read into a buffer
" then we'll let vim issue a sequence of commands.
" au BufRead /tmp/mutt* normal    /^> -- $<cr>
au BufRead /tmp/mutt* normal :g/^> -- $/,/^$/-1d^M/^$^M^L


" kill quoted signature
" detect signature by sigdashes line ("-- ")
" and then delete unto the next non-empty line:
" au BufRead /tmp/mutt* normal :g/^> -- $/,/^$/-1d^M/^$^M^L
" au BufRead /tmp/mutt* normal :g/^> -- $/,/^$/-1d<cr>/^$<cr><c-l>
" au BufRead /tmp/mutt* normal :g/^> -- $/,/^$/-1d<cr>
" au BufRead /tmp/mutt* normal   /^> -- $<cr>dG
" au BufRead /tmp/mutt* normal  :/^> -- $<cr>d}
" au BufRead /tmp/mutt* normal   /^> -- $<cr>

" "from quoted sigdashes line unto last line - delete!"
" au BufRead /tmp/mutt*         :/^> -- $/,$d

" this avoid the prompt "N fewer lines"
" by expanding the command line height to two lines:
" au BufRead /tmp/mutt*  set ch=2|/^> -- $/,$d

" problem:  text after the signature gets deleted, too.
" normally there should be no text after the signature, but..
" you probably know that people do this, anyway. *sigh*
" au BufRead /tmp/mutt*           /^> -- $/,$d

" ============================================================
" Repairing Mailbox Folders
" ============================================================
" a pseudo "From_" line for files in "mailbox" format:
" iab Mfrom From guckes@math.fu-berlin.de Thu Apr 06 12:07:00 1967
" Sometimes I need this to fix broken headers in "mailbox" files.

" =================================================
" TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST
" =================================================

" cryptography fun
" qwertyuiop -> p qwertyuio
" asdfghjkl  -> l asdfghjk
" zxcvbnm    -> m zxcvbn
" in  qwertyuiopasdfghjklzxcvbnm
" out pqwertyuiolasdfghjkmzxcvbn
" map #c !!tr qwertyuiopasdfghjklzxcvbnm pqwertyuiolasdfghjkmzxcvbn<cr>

  map #c !!tr a-z b-za<cr>

  iab GOOGLE http://www.google.com/search?q=WORD1+WORD2

" ============================================================
" Final words...
" The last line is allowed to be a "modeline" with my setup.
" It gives vim commands for setting variable values that
" are specific for editing this file.  Used mostly for
" setting the textwidth (tw) and the "shiftwidth" (sw).
" Note that the colon within the value of "comments"
" needs to be escaped with a backslash!
"       vim:tw=70 et sw=4 comments=\:\"
