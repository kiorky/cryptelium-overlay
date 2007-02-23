%define _unpackaged_files_terminate_build 0

# build with -with nopic
%define build_nopic 0
%{?_with_nopic: %{expand: %%define build_nopic 1}}

%define name 			libxdtv-theme-carbone-fr
%define version 		1.4.0
%define release 		1
%define summary			%{name} is a fr NLS library for XdTV

Name: 				%{name}
Summary: 			%{summary}
Version: 			%{version}
Release: 			%{release}
License: 			GPL
Distribution: 			All Linux Distributions
URL:				http://xawdecode.sourceforge.net/
Source0:			%{name}-%{version}.tar.gz
Group: 				Video

Requires: 			xdtv >= 2.4.0
BuildPreReq: 			xdtv-devel >= 2.4.0
BuildRoot: 			%{_tmppath}/%{name}-%{version}-buildroot

%description
%{summary}

%prep
rm -rf $RPM_BUILD_ROOT
%setup -a 0

%build
./configure --prefix=%{_prefix} \
%if %build_nopic
	--disable-pic \
%endif

make prefix=%{_prefix}

%install
make ROOT="$RPM_BUILD_ROOT" prefix="$RPM_BUILD_ROOT"%{_prefix} install

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc AUTHORS ChangeLog COPYING NEWS README
%{_prefix}/lib/xdtv/*.so

%changelog
* Wed Mar 02 2005 Sir Pingus <pingus_77@yahoo.fr> 1.0.1-1
- 1.0.1 initial version
