Name:           libx265
Version:        1.0.0
Release:        1%{?dist}
Summary:        libx265 library
BuildArch:      x86_64

License:        GPL

%description
libx265 RPM build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/%{_libdir}
cp -P $RPM_SOURCE_DIR/source/*.so* $RPM_BUILD_ROOT/%{_libdir}
mkdir -p $RPM_BUILD_ROOT/%{_includedir}
cp $RPM_SOURCE_DIR/source/x265.h $RPM_BUILD_ROOT/%{_includedir}
cp $RPM_SOURCE_DIR/source/x265_config.h $RPM_BUILD_ROOT/%{_includedir}
mkdir -p $RPM_BUILD_ROOT/%{_libdir}/pkgconfig
cp $RPM_SOURCE_DIR/source/x265.pc $RPM_BUILD_ROOT/%{_libdir}/pkgconfig

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_libdir}/*.so*
%{_includedir}/x265.h
%{_includedir}/x265_config.h
%{_libdir}/pkgconfig/x265.pc
