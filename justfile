podman := env("podman", "podman")
specfile := "x265.spec"

help:
    @just -l

deps:
    dnf -y install gcc-c++ cmake
    dnf -y --enablerepo=crb install nasm
    cd source && cmake -D ENABLE_CLI=OFF -D ENABLE_SHARED=ON -D CMAKE_INSTALL_PREFIX=$(rpm --eval "%{_prefix}") -D LIB_INSTALL_DIR=$(rpm --eval "%{_lib}") .

build:
    cd source && make

clean:
    d=$PWD && rm -f $d/libx265-1.0.0-1.el9.x86_64.rpm
    d=$PWD && rm -f $d/libx265.tgz
    d=$PWD && rm -f $d/libx265.so
    make clean

package:
    d=$PWD && cd source && tar -czf $d/libx265.tgz *.so* x265.h x265_config.h x265.pc

rpm:
    dnf -y install rpmdevtools rpmlint
    dnf -y install 'dnf-command(builddep)'
    rpmdev-setuptree
    cp {{ specfile }} ~/rpmbuild/SPECS/
    cp -R . ~/rpmbuild/SOURCES/
    spectool --get-files --directory ~/rpmbuild/SOURCES --all ~/rpmbuild/SPECS/{{ specfile }}
    dnf -y builddep ~/rpmbuild/SPECS/{{ specfile }}
    rpmbuild -bb ~/rpmbuild/SPECS/{{ specfile }}
    cp -f ~/rpmbuild/RPMS/x86_64/* ./

dev:
    d=/workspaces/libx265 && {{ podman }} run --rm -it -w $d -v $PWD:$d quay.io/centos/centos:stream9
