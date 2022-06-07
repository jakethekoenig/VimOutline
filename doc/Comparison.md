# Comparisons

It turns out the desire to do everything in your text editor is apparently a very common mental illness. After mostly writing this plugin I googled "Vim Workflowy" and found a number of similar products. How they compare to VimOutline is documented here:

## Vimflowy

I had planned to name this plugin vimflowy before discovering this (website)[https://www.wuthejeff.com/vimflowy]. The main difference is it runs in the browser and doesn't operator on plain text (though you can export/import in a plain text workflowy compatible format). Whether this is an upside or downside is a matter of taste. Some other Pro/Cons:

Pro
* A cleaner more fully featured product (hopefully just for now).

Con
* Can't use it with Vim Plugins or your vimrc
* A general problem with products which add vim behavior to the browser is they only add an opinionated subset 

## Workflowish

This is a very similar [plugin](https://github.com/lukaszkorecki/workflowish) to this one.

Pro
* Better integrated with vim folds
* Can import Workflowy exports
Con
* Doesn't hide indentation as you focus

## VimOutliner

This is distinct from Workflowy in that it's not designed for fractal outlines. You can't treat any node as it's own head. That said it has a lot of fun features not implemented here:
* Checkboxes
* Fun colors
* Date and time inclusion
Though it's the opinion of this plugin's author that date time help should be managed by a snippets plugin.

## Vimflowy (Chrome Extension)

There's even a [chrome extension](https://chrome.google.com/webstore/detail/vimflowy/jhoonlfajlaihdlcocigbpeacapaepng?hl=en) which gives workflowy many of the vim keybindings you might like.
