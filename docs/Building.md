# How it works

## Developing

For making changes to forms, work with the file 'CheatEngineMonoHelper.CT'.
Edit the form from the Table menu, then save in `src/forms`

To make the table script after editing LUA files, open 'Dev.CT'.
The easiest way is use the 'Dev (MonoHelper)' menu option
'Build and create table entry' which will create a new 'MonoHelper'
table entry.   This can be copied and pasted into new tables for a game.

Optionally you can build just as a lua script.

Source files are combined together with saved form 'frm' files into
`autorun/monohelper.lua` in the right order so that they can all execute
together.