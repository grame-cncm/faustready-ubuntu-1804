
########################################################################
########################################################################
#
#                   Faust-Ready Ubuntu 18.04 
#                (updated for Android, December 2018)
#                (updated for Ubuntu 18.04)
#                 
#
########################################################################
########################################################################

FROM ubuntu:18.04

########################################################################
# Install all the dependencies but Android
########################################################################

# We first install all the ubuntu packages

RUN apt-get update; DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends \
    build-essential pkg-config git cmake libmicrohttpd-dev llvm-6.0 llvm-6.0-dev libssl-dev \
    software-properties-common zip unzip wget ncurses-dev libsndfile-dev libedit-dev libcurl4-openssl-dev vim-common \
    libasound2-dev libjack-jackd2-dev libgtk2.0-dev libqt4-dev \
    ladspa-sdk dssi-dev lv2-dev libboost-dev libcsound64-dev supercollider-dev puredata-dev \
    inkscape graphviz qtbase5-dev qt5-qmake libqt5x11extras5-dev texlive-full \
    libarchive-dev libboost-all-dev php libapache2-mod-php qrencode highlight apache2 ruby ruby-dev nodejs \
    openjdk-8-jdk g++-mingw-w64 g++-multilib apt-utils bison ca-certificates ccache check curl \
    flex gperf lcov libncurses-dev libusb-1.0-0-dev make ninja-build python3 python3-pip xz-utils \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 10

RUN python -m pip install --upgrade pip virtualenv


# Then additional packages from ppa repositories
RUN add-apt-repository -y "ppa:dr-graef/pure-lang.bionic"; \
    add-apt-repository -y "ppa:certbot/certbot"; \
    apt-get update; \
    apt-get install -y faust2pd faust2pd-extra python-certbot-apache

# We install the MAX SDK
RUN wget https://cycling74.com/download/max-sdk-7.1.0.zip; \
    unzip max-sdk-7.1.0.zip; \
    cp -r max-sdk-7.1.0/source/c74support /usr/local/include/

# We install the Puredata dll for windows
RUN wget https://github.com/grame-cncm/faustinstaller/raw/master/rsrc/pd.dll; \
    install -d /usr/lib/i686-w64-mingw32/pd/; \
    cp pd.dll /usr/lib/i686-w64-mingw32/pd/

# We install the VST SDK
RUN wget http://www.steinberg.net/sdk_downloads/vstsdk365_12_11_2015_build_67.zip; \
    unzip vstsdk365_12_11_2015_build_67.zip -d /usr/local/include/; \
    mv /usr/local/include/VST3\ SDK /usr/local/include/vstsdk2.4

# Fix execution QT5 targets
RUN ln -s /usr/lib/x86_64-linux-gnu/qt5/bin/qmake /usr/bin/qmake-qt5


########################################################################
# Install Android in /android
########################################################################

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip; \
    mkdir -p /android/sdk/cmdline-tools; \
    unzip commandlinetools-linux-6858069_latest.zip; \
    mv cmdline-tools /android/sdk/cmdline-tools/tools


RUN	yes | /android/sdk/cmdline-tools/tools/bin/sdkmanager --licenses
RUN	/android/sdk/cmdline-tools/tools/bin/sdkmanager "build-tools;29.0.2"
RUN	/android/sdk/cmdline-tools/tools/bin/sdkmanager "cmake;3.10.2.4988404"
RUN	/android/sdk/cmdline-tools/tools/bin/sdkmanager "platforms;android-30" 
RUN	/android/sdk/cmdline-tools/tools/bin/sdkmanager "extras;android;m2repository" 
RUN	/android/sdk/cmdline-tools/tools/bin/sdkmanager "ndk;21.1.6352462"

RUN install -d /opt/android; \
    ln -s /android/sdk /opt/android/sdk; \
    ln -s /android/sdk/ndk/21.1.6352462/ /opt/android/ndk

ENV ANDROID_HOME=/opt/android/sdk 
ENV ANDROID_NDK_HOME=/opt/android/ndk


# ########################################################################
# # Install gradle-6.5. The version should be the same that the one 
# # tested by faust2android and faust2smartkeyb
# ########################################################################

RUN wget https\://services.gradle.org/distributions/gradle-6.5-bin.zip
RUN mkdir /opt/gradle; unzip -d /opt/gradle gradle-6.5-bin.zip

# set PATH
ENV PATH=$PATH:/opt/gradle/gradle-6.5/bin
