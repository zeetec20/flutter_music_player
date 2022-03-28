# Music Player

<div align="center">

![This is an image](https://i.ibb.co/jLfT0qP/mockup-music-player.png)
See app on [Figma](https://www.figma.com/file/td0pomRUmXRWHeXCvgPOzO/Music-Player?node-id=0%3A1)

</div>

## Description
This repository is source code of music player, build with languade dart on framework flutter with api from itunes.

## Requirement Device
- Operation System : Windows
- Flutter : 2.10.2
- Dart : 2.16.1
- Mobile Device : Vivo V11 Pro
- Mobile Operation System : Android
- Android Version : 10

## Support Features
- Popular artist
- Search music
- Save music from popular artist
- Save music from search
- Play music by artist
- Play music by search
- Play music by library
- Pause music
- Resume music
- Previous music
- Next music
- Slide music player to stop music
- Slide saved music to remove it

## Run project
- Clone respository
```bash
git clone https://github.com/zeetec20/flutter_music_player.git
```
- Open repository
```bash
cd flutter_music_player
```
- Run command
```bash
flutter pub get
flutter run
```

## Build app
- Clone respository
```bash
git clone https://github.com/zeetec20/flutter_music_player.git
```
- Open repository
```bash
cd flutter_music_player
```
- Run command
```bash
flutter pub get
flutter build apk --release
```

## Deploy App
- Generate keystore
```bash
# Linux
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Windows
keytool -genkey -v -keystore c:\Users\USER_NAME\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
- Reference the keystore
```properties
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=<location of the key store file, such as /Users/<user name>/upload-keystore.jks>
```
- Configure signing in [grandle](https://docs.flutter.dev/deployment/android#configure-signing-in-gradle)
- Build appbundle
```bash
flutter run appbundle --release
```
- Upload appbundle to [Google Play Console](https://developer.android.com/studio/publish/upload-bundle)

