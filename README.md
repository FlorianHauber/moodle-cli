# moodle-cli — Moodle in your terminal

Use Moodle from the terminal on Linux: courses, files, deadlines, assignments,
grades, messages and forums.

- **No admin/root needed.** Everything installs into your home folder.
- **No browser needed.** It logs in the same way as the official Moodle mobile app.
- **Nothing extra to install.** One Python file that uses only Python's standard library.
- **Works without a desktop.** Runs fine on a plain TTY, over SSH, or in tmux.

---

## 1. Requirements

Only **Python 3.8 or newer**, which is almost always already installed on Arch Linux.
Check it:

```sh
python3 --version
```

If you see `command not found`, Python is missing. Installing it needs admin
rights (`sudo pacman -S python`), so ask whoever manages the computer.

Optional: `less` (for reading files) and `pdftotext` from the `poppler` package
(for reading PDFs inside the terminal). Both are usually installed already.

---

## 2. Install

**With git:**

```sh
git clone https://github.com/FlorianHauber/moodle-cli.git
cd moodle-cli
sh install.sh
```

**Without git** (downloads the repo as a zip):

```sh
curl -L -o moodle-cli.zip https://github.com/FlorianHauber/moodle-cli/archive/refs/heads/main.zip
unzip moodle-cli.zip
cd moodle-cli-main
sh install.sh
```

The installer copies the program to `~/.local/bin/moodle` and prints the version, e.g.

```
installed: /home/you/.local/bin/moodle  (moodle-cli 1.4)
```

### If `moodle` is "command not found"

`~/.local/bin` isn't on your PATH yet. Fix it once:

**bash** (Arch default):
```sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**zsh:**
```sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**fish:**
```sh
fish_add_path ~/.local/bin
```

### Check the installation

```sh
moodle --version
```

This should print `moodle-cli 1.4` (or newer).

---

## 3. First login

```sh
moodle login
```

You'll be asked for:

1. **Site URL**, e.g. `moodle.yourschool.at`. Paste the address you normally
   open in the browser; `https://` and paths like `/my/` are handled automatically.
2. **Username**
3. **Password** (not shown while typing)

```
Moodle site URL: moodle.yourschool.at
Site: HTL Example
Username: max.mustermann
Password:
✓ logged in as Max Mustermann on HTL Example
```

Your **password is never saved**. Only the app login token is stored, in
`~/.config/moodle-cli/config.json`, readable only by you. You stay logged in
until you run `moodle logout`.

### School uses Microsoft / Google / single sign-on?

If you normally log in with a "Log in with Microsoft" button, a username and
password won't work. The program detects this and offers two alternatives:

- **SSO link:** `moodle login --sso`
  It shows a link. Open it **once on any device, your phone is fine**, and log in.
  The page then tries to open the Moodle app using an address that starts with
  `moodlemobile://token=…`. Copy that address and paste it into the terminal.
- **Token:** `moodle login --token`
  In Moodle on the web, go to *Preferences → Security keys*, copy the key for
  "Moodle mobile web service", and paste it. Not every school shows this page.

---

## 4. Start it

| Command | What you get |
|---|---|
| `moodle` | Full-screen interface (recommended) |
| `moodle shell` | Command prompt with `moodle>` |
| `moodle todo` | Run a single command and exit, e.g. `moodle sync all` |

### Full-screen interface: keys

| Key | Action |
|---|---|
| `↑` `↓` or `j` `k` | Move |
| `Enter` or `→` | Open |
| `Esc`, `←` or `Backspace` | Back |
| `1` … `7` or `Tab` | Switch tab (Courses, To-do, Assignments, Grades, Messages, Notifications, Calendar) |
| `/` | Filter the list |
| `r` | Reload |
| `?` | Help with all keys |
| `q` | Quit |

The bottom line always shows what you can do on the current screen, for example
`d` download, `s` sync a course, `u` upload to an assignment, `m` write or reply,
and `m` on a course to move it between Current / Hidden / Past.
The mouse works too: click to select, click again to open, wheel to scroll.

### Command prompt: most useful commands

```
courses                    list all courses
move 1-5 current           put courses 1-5 into "Current" (only on your computer)
course 2                   open course 2
get 3 5-7                  download items 3, 5, 6, 7
sync all                   download all new files of all current courses
todo                       upcoming deadlines
assignment 1               details, your submission and feedback
submit 1 ~/report.pdf      hand in a file
quizzes                    quizzes sorted by closing date
quiz 1 start               take quiz 1 in the terminal
grades                     grade overview
messages / chat 1          read and answer messages
help                       everything else
```

Downloaded files go to `~/Moodle/<course>/<section>/`.
Change the folder with `dir ~/School` (in `moodle shell`).

---

## 5. Update to a new version

1. **Quit the running program first** (`q` or `quit`). An open copy keeps
   running the old version.
2. Pull the new version and install it again:
   ```sh
   cd moodle-cli
   git pull
   sh install.sh
   ```
   Without git, download the zip again (section 2) and run `sh install.sh`.
3. Check: `moodle --version`

Your login and settings are kept.

---

## 6. Uninstall

```sh
moodle logout                      # removes your token
rm ~/.local/bin/moodle             # removes the program
rm -r ~/.config/moodle-cli ~/.local/state/moodle-cli   # removes settings and history
```

Downloaded files in `~/Moodle` are left alone; delete them yourself if you want.

---

## 7. Troubleshooting

| Problem | Fix |
|---|---|
| `moodle: command not found` | Do the PATH step in section 2. |
| `unknown command: move` (or another new command) | You're running an old copy. Quit it, reinstall (section 5), and check `moodle --version`. Start with `moodle`, not `python3 moodle` from an old folder. |
| `Invalid login` | Wrong username or password, or your school uses Microsoft/Google login. Use `moodle login --sso`. |
| `web services are disabled` / `service not available` | Your school has turned off the Moodle app. Only the Moodle admins can change that. |
| `you must accept the site policy` | Log in once on the website (e.g. on your phone), accept the policy, and try again. |
| `your login expired` / `invalidtoken` | Run `moodle login` again. |
| Some courses appear under "Past" | Their end date has passed (it's shown next to the course). Move them with `move <n> current`, or `m` in the full-screen view. |
| Colors look wrong | Run `NO_COLOR=1 moodle`. |

---

## Files it uses

| Path | Contents |
|---|---|
| `~/.local/bin/moodle` | The program |
| `~/.config/moodle-cli/config.json` | Site URL, login token, your settings (permissions 600) |
| `~/.local/state/moodle-cli/history` | Command history of `moodle shell` |
| `~/Moodle/` | Downloaded course files |
