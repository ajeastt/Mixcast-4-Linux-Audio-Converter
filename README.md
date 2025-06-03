# Mixcast 4 Linux Audio Converter

**Fast audio conversion for the Tascam Mixcast 4 soundpad**

---

## What is this?

The Tascam Mixcast 4 is a powerful audio mixer and podcast workstation. But its official soundpad management software only runs on Windows and Mac—and it’s slow.  
**This project solves that:** It’s a simple, fast Linux shell script that converts any audio file into the exact WAV format needed for the Mixcast 4 soundpad.

---

## 🚀 Features

- **Universal Conversion:** Accepts any common audio format (MP3, WAV, FLAC, etc.)
- **Mixcast 4-Ready:** Outputs 16-bit, 48 kHz, mono WAV files with the correct filename pattern (A001.wav, A002.wav, etc.)
- **Plug & Play:** Designed to drop files directly onto your Mixcast 4 SD card
- **Faster than Official Software:** Instant results—no bloated apps or virtual machines
- **Linux First:** 100% native; no Wine, no Windows needed

---

## 🛠️ Requirements

- [FFmpeg](https://ffmpeg.org/) – For audio conversion  
  _Install via:_
  ```bash
  sudo apt install ffmpeg   # Debian/Ubuntu  
  sudo dnf install ffmpeg   # Fedora/RHEL  
  sudo pacman -S ffmpeg     # Arch
  ```

- Bash shell (any modern Linux distro)

---

## 📂 Usage

1. **Clone this repo:**
    ```bash
    git clone https://github.com/YOURUSERNAME/mixcast4-linux-converter.git
    cd mixcast4-linux-converter
    ```

2. **Make the script executable:**
    ```bash
    chmod +x convert.sh
    ```

3. **Convert your audio file:**
    ```bash
    ./convert.sh your-audio.mp3
    ```

4. **Follow the script prompts:**  
    - The script will output a Mixcast 4-ready WAV file (e.g., `A001.wav`)
    - If the mixer is not in `SD Device Mode` it will prompt to put it in that mode.
    - After the device is in the `SD Device Mode` everything is automated from there.

---

## ❓ Why did I build this?

As a linux user, I was always locked down to the windows software for the Tascam Mixcast software.
I started doing some digging and found that you do not even need to have the software in order to add sounds to the soundpad and the device.
I built this because of my audio setup and how often I use the soundpad.