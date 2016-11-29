FROM ubuntu:trusty

MAINTAINER Caleb Land <caleb@land.fm>

ENV SRC_MIRROR=10.0.1.2/src
ENV LANG=en_US.UTF-8
ENV PREFIX=/usr/local
ENV LDFLAGS="-Wl,-rpath=/usr/local/lib"

RUN mkdir -p /src
WORKDIR /src

#
# Use our local apt mirror
#
RUN sed -i -e 's/deb.debian.org/10.0.1.2/g' /etc/apt/sources.list
RUN sed -i -e 's/archive.ubuntu.com/10.0.1.2/g' /etc/apt/sources.list

RUN apt-get update

#
# Configure our locale
#
RUN apt-get -y install language-pack-en-base \
&&  dpkg-reconfigure locales

#
# Install some requirements
#
RUN apt-get -y install vim less build-essential git wget gettext autoconf pkg-config
RUN apt-get -y --no-install-recommends install ruby

#
# Install libebml
#
RUN wget http://${SRC_MIRROR}/libebml-1.3.4.tar.bz2
RUN tar jxf libebml-1.3.4.tar.bz2
RUN cd libebml-1.3.4 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` && make install

#
# Install libmatroska
#
RUN wget http://${SRC_MIRROR}/libmatroska-1.4.5.tar.bz2
RUN tar xjf libmatroska-1.4.5.tar.bz2
RUN cd libmatroska-1.4.5 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` && make install

#
# Install libogg
#
RUN wget http://${SRC_MIRROR}/libogg-1.3.2.tar.xz
RUN tar xJf libogg-1.3.2.tar.xz
RUN cd libogg-1.3.2 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` && make install

#
# Install libvorbis
#
RUN wget http://${SRC_MIRROR}/libvorbis-1.3.5.tar.xz
RUN tar xJf libvorbis-1.3.5.tar.xz
RUN cd libvorbis-1.3.5 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` && make install

#
# Install libtheora
#
RUN wget http://${SRC_MIRROR}/libtheora-1.1.1.tar.bz2
RUN tar xjf libtheora-1.1.1.tar.bz2
RUN cd libtheora-1.1.1 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` \
&&  make install

#
# Install zlib
#
RUN wget http://${SRC_MIRROR}/zlib-1.2.8.tar.xz
RUN tar xJf zlib-1.2.8.tar.xz
RUN cd zlib-1.2.8 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` && make install

#
# Install boost
#
RUN wget http://${SRC_MIRROR}/boost_1_62_0.tar.bz2
RUN tar xjf boost_1_62_0.tar.bz2
RUN cd boost_1_62_0 \
&&  ./bootstrap.sh --prefix="${PREFIX}" --with-libraries=filesystem,regex,date_time,system \
&&  ./b2 -j`nproc` && ./b2 install

#
# Install file
#
RUN wget http://${SRC_MIRROR}/file-5.27.tar.gz
RUN tar xzf file-5.27.tar.gz
RUN cd file-5.27 \
&&  ./configure --prefix="${PREFIX}" --disable-elf \
&&  make -j`nproc` && make install

#
# Install flac
#
RUN wget http://${SRC_MIRROR}/flac-1.3.1.tar.xz
RUN tar xJf flac-1.3.1.tar.xz
RUN cd flac-1.3.1 \
&&  ./configure --disable-doxygen-docs --prefix="${PREFIX}" \
&&  make -j`nproc` && make install

#
# Install mkvtoolnix
#
RUN git clone git://github.com/mbunkus/mkvtoolnix.git
RUN cd mkvtoolnix \
&&  ./autogen.sh \
&&  ./configure --prefix="${PREFIX}" \
                --with-boost="${PREFIX}" \
                --with-extra-includes="${PREFIX}/include" \
                --with-extra-libs="${PREFIX}/lib" \
                --disable-qt \
                --without-curl
RUN cd mkvtoolnix \
&&  ./drake -j`nproc` \
&&  ./drake -j`nproc` install

################################################################################
# Install FFMPEG
################################################################################

#
# Install basic dependencies
#
RUN apt-get update
RUN apt-get -y install autoconf automake build-essential \
               libtool texinfo cmake mercurial nasm

#
# Install YASM
#
RUN wget http://${SRC_MIRROR}/yasm-1.3.0.tar.gz
RUN tar xzf yasm-1.3.0.tar.gz
RUN cd yasm-1.3.0 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` \
&&  make install

#
# Install expat
#
RUN wget http://${SRC_MIRROR}/expat-2.2.0.tar.bz2
RUN tar xjf expat-2.2.0.tar.bz2
RUN cd expat-2.2.0 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` \
&&  make install

#
# Install freetype
#
RUN wget http://${SRC_MIRROR}/freetype-2.7.tar.bz2
RUN tar xjf freetype-2.7.tar.bz2
RUN cd freetype-2.7 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` \
&&  make install

#
# Install fontconfig
#
RUN wget http://${SRC_MIRROR}/fontconfig-2.12.1.tar.bz2
RUN tar xjf fontconfig-2.12.1.tar.bz2
RUN cd fontconfig-2.12.1 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` \
&&  make install

#
# Install fribidi
#
RUN wget http://${SRC_MIRROR}/fribidi-0.19.7.tar.bz2
RUN tar xjf fribidi-0.19.7.tar.bz2
RUN cd fribidi-0.19.7 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` \
&&  make install


#
# Install libass
#
RUN wget http://${SRC_MIRROR}/libass-0.13.4.tar.xz
RUN tar xJf libass-0.13.4.tar.xz
RUN cd libass-0.13.4 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` \
&&  make install

#
# Install libx264
#
RUN wget http://${SRC_MIRROR}/last_x264.tar.bz2
RUN tar xjvf last_x264.tar.bz2
RUN cd x264-snapshot* \
&&  ./configure --prefix="${PREFIX}" --enable-shared --disable-opencl \
&&  make -j`nproc` \
&&  make install

#
# Install libx265
#
RUN hg clone https://bitbucket.org/multicoreware/x265
RUN cd x265/build/linux \
&&  cmake -G "Unix Makefiles" -DCMAKE_PREFIX="${PREFIX}" ../../source \
&&  make -j`nproc` \
&&  make install

#
# Install libfdk-aac
#
RUN wget http://${SRC_MIRROR}/fdk-aac.tar.gz
RUN tar xzvf fdk-aac.tar.gz
RUN cd mstorsjo-fdk-aac* \
&&  autoreconf -fiv \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` \
&&  make install

#
# Install libmp3lame
#
RUN wget http://${SRC_MIRROR}/lame-3.99.5.tar.gz
RUN tar xzvf lame-3.99.5.tar.gz
RUN cd lame-3.99.5 \
&&  ./configure --prefix="${PREFIX}" --enable-nasm \
&&  make -j`nproc` \
&&  make install

#
# Install libopus
#
RUN wget http://${SRC_MIRROR}/opus-1.1.2.tar.gz
RUN tar xzvf opus-1.1.2.tar.gz
RUN cd opus-1.1.2 \
&&  ./configure --prefix="${PREFIX}" \
&&  make -j`nproc` \
&&  make install

#
# Install libvpx
#
RUN wget http://${SRC_MIRROR}/libvpx-1.5.0.tar.bz2
RUN tar xjvf libvpx-1.5.0.tar.bz2
RUN cd libvpx-1.5.0 \
&&  ./configure --prefix="${PREFIX}" --disable-examples --disable-unit-tests \
&&  make -j`nproc` \
&&  make install

#
# Install ffmpeg
#
RUN wget http://${SRC_MIRROR}/ffmpeg-snapshot.tar.bz2
RUN tar xjvf ffmpeg-snapshot.tar.bz2
RUN cd ffmpeg \
&&  ./configure \
      --prefix="${PREFIX}" \
      --enable-gpl \
      --enable-pthreads \
      --enable-version3 \
      --enable-avresample \
      --enable-hardcoded-tables \
      --enable-libass \
      --enable-libfdk-aac \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libtheora \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-nonfree \
&&  make -j`nproc` \
&&  make install

#
# Create our tarball
#
RUN tar cf /build.tar /usr/local \
&&  xz /build.tar
