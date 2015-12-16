=====
albertolumbreras.net
=====



To deploy the blog use:

     ./site build
     
     
If you change site.hs, then recompile and rebuild:

    ghc --make site.hs
    ./site rebuild


If you are using [Stack](https://www.stackage.org/) then it will use the .cabal and .yaml files. To build the site, do:
    
    stack build
    .stack-work/install/x86_64-linux/lts-3.18/7.10.2/bin/stack-project build
    
And then get the full site from `_site` as usual.
