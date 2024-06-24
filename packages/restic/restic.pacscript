pkgname=restic
pkgver=0.16.4
pkgdesc="Fast, secure, efficient backup program"
arch=('x86_64' 'aarch64')
url="https://github.com/restic/restic"
license=('BSD-2-Clause')
depends=('glibc')
makedepends=('golang-go' 'git' 'libfuse2 | libfuse2t64')
checkdepends=('libfuse2 | libfuse2t64')
optdepends=('libfuse2 | libfuse2t64: mount archive')
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/restic/restic/archive/v${pkgver}.tar.gz")
sha512sums=('9f28f90466a30a3c1f32cd1951dddaa22d30ece8b1c18da1a907cc1dd0f98065c25529e855b56fc3d62801b052371d9fe117cd26f17e15276f6a9a309416e914')
external_connection="true"

build(){
  cd "${pkgname}-${pkgver}"
  export CGO_CPPFLAGS="${CPPFLAGS}"
  export CGO_CFLAGS="${CFLAGS}"
  export CGO_CXXFLAGS="${CXXFLAGS}"
  export CGO_LDFLAGS="${LDFLAGS}"
  export GOPATH="${srcdir}"
  #export GOFLAGS="-buildmode=pie -trimpath -ldflags=-linkmode=external -mod=readonly -modcacherw -compressdwarf=false"
  export GOFLAGS="-buildmode=pie -trimpath -ldflags=-linkmode=external -mod=readonly -modcacherw"
  go build -ldflags "-X 'main.version=${pkgver}'" ./cmd/...
}

check(){
  cd "${pkgname}-${pkgver}"
  go test ./cmd/... ./internal/... || true
}

package() {
  cd "${pkgname}-${pkgver}"
  install -Dm755 restic "${pkgdir}/usr/bin/restic"
  install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
  install -Dm644 -t "$pkgdir/usr/share/man/man1/" doc/man/*.1
  install -Dm644 doc/zsh-completion.zsh "$pkgdir/usr/share/zsh/site-functions/_restic"
  install -Dm644 doc/bash-completion.sh "$pkgdir/usr/share/bash-completion/completions/restic"
  install -Dm644 doc/fish-completion.fish "$pkgdir/usr/share/fish/vendor_completions.d/restic.fish"
}
