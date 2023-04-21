# Edit secrets:
#   cd secrets && nix run github:ryantm/agenix -- -e mysecret.age
#
# Rekey with:
#   cd secrets && nix run github:ryantm/agenix -- agenix --rekey
#
let
  aorith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmfktrz3eMNZ6aVJcvFC4ABOwMvS3g0gVuCAQKMwDSl";
  users = [aorith];

  trantor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqNBNW7vxpZpujRZnG5z/rfspeqkLDqEvlcwgiFLygV";
  msi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqNBNW7vxpZpujRZnG5z/rfspeqkLDqEvlcwgiFLygV";
  systems = [trantor msi];
in {
  "hosts.age".publicKeys = users ++ systems;
}
