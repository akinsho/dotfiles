# Autoload Directory

Vim loads different files depending on their location in its directory, for example autoloading scripts load on
demand/lazily. Filetype plugins run when a file type is opened. `after/ftplugins` do open after plugins and regular filetype
files have run.

This lets me have the last word on the settings per filetype after the plugins
have run and the filetype files from Vim so my settings definitely show up.
