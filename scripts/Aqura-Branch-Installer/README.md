# 🏢 Ruyax Branch Installer v2.0

Fully automated installer for deploying a complete Ruyax system at any branch location — **zero manual work**.

## What It Does

Sets up VM + Supabase + Schema + Frontend in one run:

| Phase | Description |
|-------|-------------|
| 1 | **Pre-flight checks** — validates template, SSH key, frontend build |
| 2 | **Hyper-V setup** — installs if needed |
| 3 | **VM creation** — creates VM from pre-built Ubuntu template |
| 4 | **Network configuration** — static IP, hostname |
| 5 | **Supabase configuration** — .env, dashboard password, starts containers |
| 6 | **Schema sync** — exports schema from cloud, imports to local DB |
| 7 | **Import functions** — deploys sync functions for Branch Sync |
| 8 | **Frontend deploy** — uploads build, creates .env, starts with PM2 |
| 9 | **Cloud registration** — registers branch in cloud Branch Sync |
| 10 | **Final verification** — tests Studio, API, DB, and Frontend |
| 11 | **Save config** — saves branch configuration file |

**Total time: ~15-20 minutes** (mostly copying the 19 GB template)

After installation, the script displays the **Ruyax login URL** (`http://<IP>:3001`).

## Requirements

| Requirement | Minimum |
|---|---|
| OS | Windows Server 2019 or 2022 |
| RAM | 16 GB (8 GB for VM + 8 GB for host) |
| Disk | 50 GB free space |
| NICs | 2 (one for VM network) |
| Access | Administrator |

## Files

| File | Description |
|---|---|
| `Install-RuyaxBranch.ps1` | Main installer — run this |
| `Update-RuyaxBranch.ps1` | Push updates to branch VMs |
| `Build-Frontend.ps1` | Builds frontend ZIP from source |
| `Sync-Schema.ps1` | Standalone schema sync (optional) |
| `README.md` | This file |
| `template\supabase-template.vhdx` | Pre-built Ubuntu VM image (~19 GB) |
| `template\ruyax-frontend-build.zip` | Pre-built frontend (create with Build-Frontend.ps1) |

## Quick Start

### 1. Prepare Files

Copy the `Ruyax-Branch-Installer` folder to the branch server:
```
D:\Ruyax-Branch-Installer\
├── Install-RuyaxBranch.ps1
├── Build-Frontend.ps1
├── Sync-Schema.ps1
├── README.md
└── template\
    ├── supabase-template.vhdx         ← 19 GB
    └── ruyax-frontend-build.zip       ← ~50 MB
```

Also ensure the **cloud SSH key** (`id_ed25519_nopass`) is available on the branch server.

### 2. Build Frontend ZIP (if not already built)

On a machine with the Ruyax source code:
```powershell
cd D:\Ruyax\scripts\Ruyax-Branch-Installer
.\Build-Frontend.ps1
```
This builds the SvelteKit frontend with adapter-node and creates `ruyax-frontend-build.zip`.

### 3. Run Installer

Open PowerShell **as Administrator** on the branch server:
```powershell
cd D:\Ruyax-Branch-Installer
.\Install-RuyaxBranch.ps1
```

The wizard asks for:
- Branch name and ID
- VM name, IP, RAM/CPU
- Network adapter
- Supabase dashboard password
- Path to frontend build ZIP
- Path to cloud SSH key

### 4. Done!

After installation completes, the script shows:
```
  ╔════════════════════════════════════════════════════════╗
  ║                                                        ║
  ║   Ruyax LOGIN URL:  http://192.168.0.101:3001          ║
  ║                                                        ║
  ╚════════════════════════════════════════════════════════╝
```

Open that URL in any browser on the network to access Ruyax.

**Next:** Sync data from Cloud Ruyax → Storage Manager → Branch Sync tab.

## URLs After Installation

| Service | URL |
|---------|-----|
| **Ruyax App** | `http://<VM-IP>:3001` |
| Supabase Studio | `http://<VM-IP>:3000` |
| Supabase API | `http://<VM-IP>:8000` |
| SSH | `ssh u@<VM-IP>` (password: `u`) |

## Advanced Options

### Reinstalling
```powershell
.\Install-RuyaxBranch.ps1 -ForceReinstall
```

### Skip Hyper-V (already installed)
```powershell
.\Install-RuyaxBranch.ps1 -SkipHyperV
```

### Skip VM Creation (reconfigure only)
```powershell
.\Install-RuyaxBranch.ps1 -SkipVMCreation
```

## Updating Branches

When you release a new Ruyax version, push updates to branches using `Update-RuyaxBranch.ps1`.

### Update Workflow

```
1. Build new frontend  →  Build-Frontend.ps1
2. Push to branches    →  Update-RuyaxBranch.ps1
```

### Update a Single Branch
```powershell
# Step 1: Build new frontend (creates template\ruyax-frontend-build.zip)
.\Build-Frontend.ps1

# Step 2: Push update to branch
.\Update-RuyaxBranch.ps1 -BranchIP 192.168.0.101
```

### Update Frontend + Schema Changes
```powershell
.\Update-RuyaxBranch.ps1 -BranchIP 192.168.0.101 -SyncSchema
```

### Update Frontend + Schema + Import Functions
```powershell
.\Update-RuyaxBranch.ps1 -BranchIP 192.168.0.101 -SyncSchema -UpdateFunctions
```

### Update ALL Branches at Once
```powershell
.\Update-RuyaxBranch.ps1 -All
```
This discovers all `branch-config.json` files and updates every branch sequentially.

### What Gets Updated

| Flag | What it updates |
|------|----------------|
| *(default)* | Frontend build only (most common) |
| `-SyncSchema` | + Database schema from cloud |
| `-UpdateFunctions` | + Sync import functions |
| `-SkipBackup` | Skip backing up old build |

### Version Tracking

Each build includes a `version.txt` file with the version from `package.json` and build timestamp. The update script shows the version change:
```
  Updated: AQ49.22.14.15 → AQ49.23.0.1
```

## Template VHDX

Pre-built Ubuntu 22.04 VM including:
- Ubuntu 22.04.5 LTS Server
- Docker 29.2.1 + Compose v5.0.2
- All Supabase Docker images (~11 GB)
- Supabase repo at `/opt/supabase/supabase/`
- Node.js 20.x
- User: `u` / Password: `u`
- SSH server enabled

### Rebuilding the Template

1. Create Ubuntu 22.04 VM in Hyper-V
2. Install Docker and Docker Compose
3. Install Node.js 20.x
4. Clone Supabase: `git clone --depth 1 https://github.com/supabase/supabase.git /opt/supabase/supabase`
5. Pull images: `cd /opt/supabase/supabase/docker && docker compose pull`
6. Shut down VM
7. Copy VHDX to `template\supabase-template.vhdx`

## Branch Config

After installation, `branch-config.json` is saved locally and on the VM:
```json
{
    "branchName": "Branch 3 - Warehouse",
    "branchID": 3,
    "vmName": "Ruyax-Supabase-Branch3",
    "vmIP": "192.168.0.131",
    "RuyaxURL": "http://192.168.0.131:3001",
    "studioURL": "http://192.168.0.131:3000",
    "apiURL": "http://192.168.0.131:8000",
    "installerVersion": "2.0.0"
}
```

## Troubleshooting

### "Template VHDX not found"
Copy `supabase-template.vhdx` to the `template\` subfolder.

### "Frontend build ZIP not found"
Run `Build-Frontend.ps1` first, or point the wizard to the ZIP file location.

### "Hyper-V needs reboot"
Reboot the server, then re-run with `-SkipHyperV`.

### VM doesn't get an IP
- Check VM is connected to the correct virtual switch
- Check network cable is in the correct NIC
- Open VM console: `vmconnect.exe localhost <VMName>`

### Frontend not loading
SSH into the VM and check PM2:
```bash
ssh u@<VM-IP>
pm2 status
pm2 logs Ruyax --lines 20
```

### Supabase containers not starting
```bash
ssh u@<VM-IP>
cd /opt/supabase/supabase/docker
docker compose logs --tail 50
docker compose down && docker compose up -d
```

### Can't reach services from network
- Check Windows Firewall on the host server
- Verify VM IP: `ssh u@<VM-IP> "ip addr show eth0"`
- Check ports: `ssh u@<VM-IP> "ss -tlnp | grep -E '3000|3001|8000'"`

