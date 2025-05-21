wget https://storage.googleapis.com/dart-archive/channels/stable/release/latest/linux_packages/dart_3.8.0-1_amd64.deb
ar x dart_3.8.0-1_amd64.deb
mkdir dart-sdk
tar -xf data.tar.xz -C dart-sdk/
export PATH=$(pwd)/dart-sdk/usr/lib/dart/bin/:$PATH

dart pub global activate jaspr_cli
jaspr build
