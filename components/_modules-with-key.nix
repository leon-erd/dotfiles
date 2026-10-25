# Takes flake-parts' flakeModules.modules and returns a module that additionally sets a `key` on every
# module in flake.modules. The module system deduplicates modules by key, so a module can be imported
# from several places (e.g. by a host and by another module) without being evaluated twice.
upstreamModule:
{ lib, ... }@args:

let
  upstream = import upstreamModule args;
  upstreamOption = upstream.options.flake.modules;

  addKey =
    class: moduleName: module:
    let
      key = "${class}.${moduleName}";
    in
    # upstream wraps the modules of all classes except "generic" in a function
    if lib.isFunction module then
      moduleArgs: (module moduleArgs) // { inherit key; }
    else
      module // { inherit key; };
in
upstream
// {
  options.flake.modules = upstreamOption // {
    apply = modules: lib.mapAttrs (class: lib.mapAttrs (addKey class)) (upstreamOption.apply modules);
  };
}
