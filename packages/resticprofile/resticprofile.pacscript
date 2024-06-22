pkgname=resticprofile
pkgver=0.26.0
pkgdesc="Configuration profiles manager and scheduler for restic backup"
arch=("amd64")
url="https://github.com/creativeprojects/resticprofile"
license=('GPL-3.0-only')
depends=("restic")
makedepends=('golang-go' 'git')
options=(!lto)
maintainer=("Eric Renfro <psi-jack@linux-help.org>")
source=("https://github.com/creativeprojects/resticprofile/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('2aba9eedc4150ba85792396479c94a092791a4c371bd86ccc979cdace29eb6a7')
external_connection='true'

build() {
    cd "${pkgname}-${pkgver}"

    export CGO_CPPFLAGS="${CPPFLAGS}"
    export CGO_CFLAGS="${CFLAGS}"
    export CGO_CXXFLAGS="${CXXFLAGS}"
    export CGO_LDFLAGS="${LDFLAGS}"
    export GOFLAGS="-buildmode=pie -trimpath -ldflags=-linkmode=external -mod=readonly -modcacherw"

    LC_ALL=C _build_date="$(date)"

    go build -o resticprofile -v -ldflags "-X 'main.date=${_build_date}' -X 'main.builtBy=pacstall'"
}

package() {
    cd "${pkgname}-${pkgver}"

    install -Dm755 resticprofile "${pkgdir}/usr/bin/resticprofile"
    install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/resticprofile/LICENSE"
    install -Dm644 README.md "${pkgdir}/usr/share/doc/resticprofile/README.md"

    install -dm755 "${pkgdir}/usr/share/resticprofile/examples/"
    install -Dm644 examples/* "${pkgdir}/usr/share/resticprofile/examples/"
    install -dm755 "${pkgdir}/usr/share/resticprofile/contrib/systemd/"
    install -Dm644 contrib/systemd/* "${pkgdir}/usr/share/resticprofile/contrib/systemd/"

    install -Dm644 contrib/completion/bash-completion.sh "${pkgdir}/usr/share/bash-completion/completions/resticprofile"
    install -Dm644 contrib/completion/zsh-completion.sh "${pkgdir}/usr/share/zsh/site-functions/_resticprofile"
}
