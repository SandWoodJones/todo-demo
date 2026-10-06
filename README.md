# todo-demo

Um ToDo mínimo em Flask.

## Instalação

Só o Nix é necessário.

1. Instale o Nix seguindo <https://nixos.org/download/> (Linux, macOS ou
   Windows sob WSL2).
2. Habilite os *flakes*, que ainda são um recurso experimental. Em
   `~/.config/nix/nix.conf` (ou `/etc/nix/nix.conf`):

   ```
   experimental-features = nix-command flakes
   ```

   Alternativamente, passe `--extra-experimental-features 'nix-command
   flakes'` em cada comando abaixo.

## Uso e teste

```sh
nix run github:SandWoodJones/todo-demo
```

Dentro do repositório clonado:
```sh
nix run .                 # sobe o app em http://127.0.0.1:8000
nix develop               # shell com Python e Flask da versão fixada
nix build                 # constrói e cria o link ./result
./result/bin/todo-demo    # executa a partir da store
nix flake check           # avalia todas as saídas do flake
```

Teste rápido por linha de comando, com o app no ar:
```sh
curl -s http://127.0.0.1:8000/
curl -s -X POST -d 'texto=comprar pão' http://127.0.0.1:8000/add
curl -s http://127.0.0.1:8000/ | grep '<li>'
```

### Imagem de contêiner, sem Docker

```sh
nix build .#container     # gera um tarball OCI em ./result
podman load < result      # ou: docker load < result
podman run -p 8000:8000 todo-demo:latest
```

## Como está empacotado

O `flake.nix` declara uma entrada (`nixpkgs`) e três saídas:

| Saída | Comando | O que é |
| --- | --- | --- |
| `packages.default` | `nix build` | o app, via `buildPythonApplication` |
| `packages.container` | `nix build .#container` | imagem OCI em camadas |
| `devShells.default` | `nix develop` | Python + Flask para desenvolver |
