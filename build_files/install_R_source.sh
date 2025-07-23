#!/bin/bash
set -ouex pipefail
# get version and download url from r version API
OS="linux-rhel-9"
ARCH=$(arch)
R_VERSION=$(curl -s "https://api.r-hub.io/rversions/r-$1" | jq -r '.version')
DOWNLOAD_INFO=$(curl -s "https://api.r-hub.io/rversions/resolve/${R_VERSION}?os=${OS}&arch=${ARCH}")
DOWNLOAD_URL=$(echo $DOWNLOAD_INFO | jq -r '.url')
R_HOME=${R_HOME:-"/usr/lib/R"}

# install build dependencies
dnf -y builddep R

# download and install
# use /usr/bin (not /opt, /usr/local, etc) 
# so that R gets updated on the host 
# system when the image updates and Positron
# can discover multiple installs
wget "${DOWNLOAD_URL}" -O "/tmp/R.tar.gz"
tar -C /tmp -xvzf /tmp/R.tar.gz
cd /tmp/R-*/
./configure \
--prefix=/usr/share/R/${R_VERSION} \
--enable-R-shlib \
--enable-memory-profiling \
--with-readline \
--with-blas \
--with-lapack \
--with-tcltk \
--with-recommended-packages
make
make install
make clean

# create symlink to /usr/bin for latest version
if [ $1 == "release" ]; then
  ln -s /usr/share/R/${R_VERSION}/bin/R /usr/bin/R
  ln -s /usr/share/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript
fi

## use RSPM
#!/bin/bash
## use RSPM 
mkdir -p ${R_HOME}/etc/
CRAN=https://packagemanager.posit.co/cran/__linux__/manylinux_2_28/latest
echo "options(repos = c(CRAN = '${CRAN}'), download.file.method = 'libcurl')" >>"${R_HOME}/etc/Rprofile.site"

## Set HTTPUserAgent for RSPM (https://github.com/rocker-org/rocker/issues/400)
cat <<EOF >>"${R_HOME}/etc/Rprofile.site"
# https://docs.rstudio.com/rspm/admin/serving-binaries/#binaries-r-configuration-linux
options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))
EOF

## Clean up from R source install
cd ..
rm -rf /tmp/R-*/
rm -rf /tmp/"R.tar.gz"
dnf -y autoremove

echo -e "\nInstall R from source, done!"
