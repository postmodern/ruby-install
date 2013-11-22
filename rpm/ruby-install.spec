%define name ruby-install
%define version 0.3.2
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
* Fri Nov 22 2013 Postmodern <postmodern.mod3@gmail.com> - 0.3.2-1
- Rebuilt for version 0.3.2.
* Fri Oct 18 2013 Postmodern <postmodern.mod3@gmail.com> - 0.3.1-1
- Rebuilt for version 0.3.1.
* Sun Aug 06 2013 Postmodern <postmodern.mod3@gmail.com> - 0.3.0-1
- Rebuilt for version 0.3.0.
* Sun Jun 29 2013 Postmodern <postmodern.mod3@gmail.com> - 0.2.1-1
- Rebuilt for version 0.2.1.
* Sun Jun 24 2013 Postmodern <postmodern.mod3@gmail.com> - 0.2.0-1
- Rebuilt for version 0.2.0.
