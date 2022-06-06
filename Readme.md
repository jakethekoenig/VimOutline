# Vim Outline

A Workflowy inspired vim plugin. It turns out this is not a very original idea, you can see how this one compares with other options in the [comparisons](doc/Comparison.md) section. To see a complete list of mappings and functions see the [documentation](doc/vimoutline.txt).

## Basic Usage

The plugin affords some basic movement and focusing mappings as well as stylings for an outline e.g. some text structured like this:
```
* Head Node
    * First Child
        It's Child
    * Second child
* Second Node
    * You get the idea
```
The asterixis are unnecessary, the plugin purely uses indentation level to determine if a node is a child of another's. The plugin recognizes .wofl or .wf as file type outline

The most useful mappings are:
``` vimscript
[context]zz     " Focus on the cursor's node. If a number is given then the context^th parent of that node.
[level]z[enter] " Fold all of the cursor node's children to [level].
[n]gp           " Go to the n^th (default=1) parent of the cursor node.
}               " Go to the next sibling of current node
{               " Go to the previous sibling of current node
```
Note these shadow built in vim defaults. I don't put blank lines in my outlines so I didn't think `{}` would be missed. I thought `zz` and `z[enter]` as defined here and as defaults perform similar operations.

## Installation

Can be installed however you install your vim plugins. For instance if you use Vundle add the following line to your vimrc:
```
Plugin jakethekoenig/VimOutline
```

