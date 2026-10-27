# Define a receita padrão (roda ao digitar apenas 'just')
default:
    just --list

# Buidar a imagem de container com sua imagem personalizada do bootc
build CONTAINER_NAME="quay.io/fedora/fedora-bootc:latest":
    @[ "$(id -u)" -eq 0 ] || { echo "Erro: Precisa de root/sudo" 1>&2; exit 1; }
    @podman build -t localhost/bootc-generic-iso-f45:latest \
        --build-arg CONTAINER_NAME={{CONTAINER_NAME}} -f Containerfile

# Cria a ISO com sua imagem bootc personalizada
create-iso:
    @[ "$(id -u)" -eq 0 ] || { echo "Erro: Precisa de root/sudo" 1>&2; exit 1; }
    @image-builder build \
        --bootc-ref localhost/bootc-generic-iso-f45:latest \
        --bootc-default-fs ext4 \
        bootc-generic-iso