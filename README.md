# nixconf

## Initial Setup

1. Enter the Nix shell environment:

   ```bash
   $ nix-shell
   ```

2. Switch to the system configuration:
   ```bash
   $ make switch
   ```

## Structure

- `hosts/<hostname>`: Configuration specific to each individual machine.
- `modules/<name>`: Reusable modules that can be shared across different machines.
