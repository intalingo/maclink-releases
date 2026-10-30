# MacLink

MacLink sends sound both ways between two Macs, for working on a Mac you control from far away (Chrome Remote Desktop, Splashtop…):

- **Remote Mac**: the Mac you control from far away. Calls and apps run here. Its sound goes to your local Mac, and your voice reaches its apps as **MacLink Microphone**. Its own speakers and microphone stay silent.
- **Local Mac**: the Mac in front of you. You listen and talk with any microphone or headset.

You sign in on each Mac with your **MacLink account** (made at **https://maclink-admin.vercel.app**, approved by an admin), and they pair by themselves. You can also listen to a remote Mac **in the browser** on that website, from any computer, Windows included.

**Needs:** macOS 14.4 or newer on both Macs, an internet connection, an approved MacLink account, and an administrator password on the remote Mac (once, for the audio driver). No Xcode, GitHub account or other software is needed.

## 0. Create your account

Open **https://maclink-admin.vercel.app**, enter your email and the code you receive. An admin approves new accounts; you get an email when yours is ready. The **Get MacLink** section there also has the download and the same install commands.

---

## 1. Install on the remote Mac

Open **Terminal** on the remote Mac (press ⌘ Space, type `Terminal`, press Return), paste this line and press Return:

```bash
curl -fsSL https://github.com/intalingo/maclink-releases/releases/latest/download/install.sh | bash -s -- remote
```

- macOS asks for the Mac's **administrator password** to install the MacLink audio driver. Type it and click OK.
- The sound on that Mac restarts for a moment. You should see `✓ MacLink Microphone installed` and `✓ MacLink installed and running`.

When MacLink opens:

1. Choose **Remote Mac**.
2. Click **Allow** when macOS asks for the **microphone**.
3. In the **Permissions** window, click **Turn On** next to anything still missing: Open at login, Accessibility, Control the browser, Control System Events. Each one opens the right place in System Settings.
4. If macOS shows **Background Items Added**, leave it switched on. That is MacLink's helper that reopens it if it ever quits.
5. Click **Sign in to MacLink**. A browser page opens: sign in, check that it shows the same code as the Mac, and click **Connect this Mac**. (Typing through a remote desktop is awkward? Click **Copy link** in MacLink and open the link on your phone or your own computer instead.)

The remote Mac now appears under **My Macs** on the website.

> **Using Splashtop on the remote Mac?** Splashtop installs its own sound drivers, which can take the sound before MacLink does. To remove them (asks for the password):
>
> ```bash
> cd /Library/Audio/Plug-Ins/HAL && for d in *.driver; do grep -qis splashtop "$d/Contents/Info.plist" && sudo rm -rf "$d" && echo "removed $d"; done
> ```
>
> Splashtop remote control keeps working; only its sound redirection stops. MacLink does that job instead.

## 2. Install on the local Mac

Open **Terminal** on the local Mac, paste this line and press Return:

```bash
curl -fsSL https://github.com/intalingo/maclink-releases/releases/latest/download/install.sh | bash
```

No password is needed. When MacLink opens:

1. Choose **Local Mac**.
2. Click **Allow** for the **microphone**, and turn on Speech Recognition (live captions) and Notifications (call alerts) in the Permissions window.
3. Click **Sign in to MacLink**, sign in on the page that opens, choose which of your remote Macs this one listens to, and click **Connect this Mac**.

Within a few seconds both Macs show **Connected**. Everything you need during a call is in the **menu-bar panel** (the sound-bars icon at the top of the screen): mic, sound, captions, dark screen, volumes, microphone and headset, call buttons.

**No local Mac?** On the website, open your remote Mac and click **Listen in browser** (Chrome or Edge, with a headset). Only one listener is active at a time: the browser or the local Mac.

## Updating

From MacLink 0.10.0 on: when a new version is out, the menu-bar panel shows **Update**. Click it; MacLink downloads, checks and installs it, then restarts by itself. (Settings → **Check for updates** checks right away.)

Older versions, or if you prefer Terminal: run the same line on each Mac, without `remote`. It always installs the newest version, keeps your pairing and settings, and needs no password:

```bash
curl -fsSL https://github.com/intalingo/maclink-releases/releases/latest/download/install.sh | bash
```

MacLink restarts during the update, so the sound between the Macs stops for about 5 seconds. Don't update during a call.

When a release says **"driver updated"**, update the remote Mac with `| bash -s -- remote` instead, which asks for the password again.

## Typing through a remote desktop

Some remote-desktop apps (Splashtop in particular) drop repeated letters and scramble symbols when you type. **Paste** the commands instead of typing them. If pasting doesn't reach the remote Mac, open this page in a browser on the remote Mac and copy the command from there.

## If something doesn't work

- **Check & repair** (on the Home page or in the menu bar) reconnects, restarts the sound on both Macs and shows a checklist of every link.
- **Diagnostics** shows, every second, whether sound is flowing in each direction.
- The local Mac can **relaunch MacLink on the remote Mac** if it isn't connected (the button appears after 20 seconds).
- Logs are in `~/Library/Logs/MacLink.log` on each Mac.

## Uninstall

On either Mac, quit MacLink from its menu-bar icon, then paste:

```bash
launchctl bootout gui/$(id -u)/app.maclink.guard 2>/dev/null; rm -f ~/Library/LaunchAgents/app.maclink.guard.plist; rm -rf /Applications/MacLink.app "$HOME/Library/Application Support/MacLink"
```

On the remote Mac, also remove the audio driver (asks for the password):

```bash
sudo rm -rf /Library/Audio/Plug-Ins/HAL/MacLinkAudio.driver && sudo killall coreaudiod
```

## Privacy

Sound is encrypted on its way between each Mac and MacLink's relay server, and is never recorded or stored. Live captions are made on the local Mac and never saved.
