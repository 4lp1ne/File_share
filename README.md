
## 📁 File_share

A simple bash script to **zip and share local files or folders** using a **temporary HTTP server** and a **public LocalTunnel URL**. The script can also generate a **QR code** for easy mobile access.

---

### 🚀 Features

* Share multiple files and folders over the internet
* Automatically zips content for easy download
* Uses [`localtunnel`](https://www.npmjs.com/package/localtunnel) for public exposure (no port forwarding required)
* Generates a downloadable link and optional QR code
* Opens everything in separate terminals to avoid bugs or conflicts


[Screencast from 06.06.2025 00:07:28.webm](https://github.com/user-attachments/assets/50a2aa1d-e01f-4298-912f-90d705495186)

---

### 🛠️ Requirements

| Tool             | Purpose                     |
| ---------------- | --------------------------- |
| `bash`           | Run the script              |
| `zip`            | Archive files               |
| `curl`           | Download and shorten URLs   |
| `python3`        | Host local HTTP server      |
| `node`, `npm`    | Required for `localtunnel`  |
| `qrencode`       | (Optional) Generate QR code |
| `gnome-terminal` | Open steps in new windows   |

---

### 📦 Setup

Clone this repo and enter the folder:

```bash
git clone https://github.com/4lp1ne/File_share
cd File_share
```

Install required system packages:

```bash
sudo apt update
sudo apt install zip curl python3 npm gnome-terminal
```

Install LocalTunnel globally:

```bash
sudo npm install -g localtunnel
```

(Optional) Install QR code generator:

```bash
sudo apt install qrencode
```

---

### 📂 Usage

```bash
./file_share.sh "file1.txt,folder2,video.mp4" 8080
```

* `"file1.txt,folder2"` — comma-separated list of files or folders
* `8080` — the local port for HTTP server (any free port)

---

### ✅ What It Does

1. Zips all specified files/folders into `transfert_pack.zip`
2. Starts a local HTTP server in a new terminal
3. Launches a LocalTunnel session in a separate terminal
4. Waits for public URL and builds a full download link
5. Saves and displays:

   * 🔗 Final public URL (in `short_url.txt`)
   * 📱 Optional QR code (as `short_url_qr.png`)
6. Opens:

   * LocalTunnel link in your browser
   * QR code (if enabled) in an image viewer

---

### 🔧 Example Output

```
📦 Zipping folder: folder2
📦 Creating final zip package: transfert_pack.zip
🚀 Starting HTTP server on port 8080 in new terminal...
☁ Starting localtunnel in new terminal...
✅ Public URL: https://abcde.loca.lt/transfert_pack.zip
📱 Generating QR code...
✅ Transfer ready!
```

---

### 🧹 Cleanup

Remove temporary files:

```bash
rm transfert_pack.zip short_url.txt short_url_qr.png
```

---

### 🐞 Troubleshooting

* **Port already in use**: Try a different port (e.g. `8090`)
* **Missing terminal**: Replace `gnome-terminal` with `konsole`, `xterm`, etc., as needed.
* **Permission errors with npm**: Use `sudo` or [fix npm permissions](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally)

---

MIT License

Copyright (c) 2025 4lp1ne_$ock3t

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
