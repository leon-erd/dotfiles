{ ... }:

let
  validSystemClasses = [
    "nixos"
    "darwin"
  ];

  asClass =
    targetClass: module: args:
    (module args) // { _class = targetClass; };

  resolveSystemModules =
    targetClass: modules:
    if !(builtins.elem targetClass validSystemClasses) then
      throw "resolveSystemModules: targetClass must be one of ${builtins.toJSON validSystemClasses}, got '${targetClass}'"
    else
      map (
        m:
        let
          class = if builtins.isFunction m then ((m { })._class or null) else (m._class or null);
        in
        if class == "system" then asClass targetClass m else m
      ) modules;
in
{
  flake.lib = {
    inherit asClass resolveSystemModules;
  };
}
