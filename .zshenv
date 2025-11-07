#
# .zshenv is sourced on all invocations of the shell.
# It should contain commands to set the command search path,
# plus other important environment variables.
# .zshenv should not contain commands that produce output
# or assume the shell is attached to a tty.
#

umask 002

export RSYNC_RSH=ssh
export CVS_RSH=ssh
export PAGER='less'
export LESS='-FeRnSX'
export WORDCHARS='*?_-.,[]~&;:!#$%^(){}<>\'
export LANG=en_US.utf8
export TERM=xterm-256color
export NO_AT_BRIDGE=1

PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"

if [ -x "/usr/libexec/java_home" ]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
elif [ -x "/usr/bin/java" ]; then
    export JAVA_HOME=$(readlink -f /usr/bin/java | sed 's:/bin/java::')
fi

if [ -z "$JAVA_HOME" ] && [ -d "$JAVA_HOME/bin" ] ; then
    PATH="$JAVA_HOME/bin:$PATH"
fi

for zshenv in $HOME/.zshenv-*(N) ; do
    source $zshenv
done

if [ -d "$HOME/local/bin" ] ; then
    PATH="$HOME/local/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# link the scalar and array variables with auto exporting
if [ -n "$LD_LIBRARY_PATH" ] ; then
    typeset -xT LD_LIBRARY_PATH ld_library_path
    typeset -U ld_library_path
fi

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath
