%define name ruby-install
%define version 0.2.1
%define release 1

%define buildroot %{_topdir}/BUILDROOT

BuildRoot: %{buildroot}
Source0: https://github.com/postmodern/%{name}/archive/v%{version}.tar.gz
Summary: Installs Ruby, JRuby, Rubinius or MagLev
Name: %{name}
Version: %{version}
Release: %{release}
License: MIT
URL: https://github.com/postmodern/ruby-install#readme
AutoReqProv: no
BuildArch: noarch
Requires: wget, bash

%description
Installs Ruby, JRuby, Rubinius or MagLev

%prep
%setup -q

%build

%install
make install PREFIX=%{buildroot}/usr

%files
%defattr(-,root,root)
%{_bindir}/ruby-install
%{_datadir}/%{name}/*
%{_mandir}/man1/*
%doc
%{_defaultdocdir}/%{name}-%{version}/*

%changelog
* Sun Jun 24 2013 Postmodern <postmodern.mod3@gmail.com> - 0.3.6-1
- Rebuilt for version 0.3.6.
* Sun May 28 2013 Postmodern <postmodern.mod3@gmail.com> - 0.3.5-1
- Rebuilt for version 0.3.5.
* Sun Mar 24 2013 Postmodern <postmodern.mod3@gmail.com> - 0.3.4-1
- Rebuilt for version 0.3.4.
