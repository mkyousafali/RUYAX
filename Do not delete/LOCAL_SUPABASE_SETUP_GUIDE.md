# ðŸ  Local Supabase Setup Guide â€” Ruyax LAN Replica

## ðŸ“‹ Overview

**Goal:** Run a complete local copy of Ruyax on the office LAN that:
1. Works exactly like the cloud version (same UI, same features)
2. Is accessible from any device on the local network
3. Has a **Sync button** in the main (cloud) Ruyax app that pushes all new data to the local copy
4. Runs as a **read-only replica** â€” users can view data but not modify it locally

**Architecture:**
```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”         â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚   CLOUD SERVER      â”‚  Sync   â”‚   LOCAL SERVER (192.168.0.3) â”‚
â”‚   8.213.42.21       â”‚ â”€â”€â”€â”€â”€â”€â–º â”‚   Windows Server 2022        â”‚
â”‚   Main Supabase     â”‚  via    â”‚   â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â” â”‚
â”‚   Main Ruyax App    â”‚ tunnel  â”‚   â”‚ Hyper-V VM (Ubuntu)    â”‚ â”‚
â”‚                     â”‚         â”‚   â”‚ - Docker               â”‚ â”‚
â”‚                     â”‚         â”‚   â”‚ - Supabase (local)     â”‚ â”‚
â”‚                     â”‚         â”‚   â”‚ - Ruyax (read-only)    â”‚ â”‚
â”‚                     â”‚         â”‚   â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜ â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜         â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

---

## ðŸ–¥ï¸ Server Infrastructure

### Cloud Server (Main â€” Already Working)
| Setting | Value |
|---|---|
| IP | `8.213.42.21` |
| OS | Ubuntu 22.04.5 LTS (Alibaba Cloud ECS) |
| Supabase URL | `https://supabase.urbanRuyax.com` |
| SSH | `ssh root@8.213.42.21` (passwordless key) |
| SSH Key | `C:\Users\DELL\.ssh\id_ed25519_nopass` |
| Docker path | `/opt/supabase/supabase/docker/` |
| DB container | `supabase-db` |
| DB user | `supabase_admin` |
| DB password | `<set via env var Ruyax_POSTGRES_PASSWORD>` |

### Local Server (Office LAN)
| Setting | Value |
|---|---|
| IP | `192.168.0.3` |
| Hostname | `WIN-D1D6EN8240A` |
| OS | Windows Server 2022 Standard (Build 10.0.20348.169) |
| Credentials | `Administrator` / `admin@123` |
| RAM | 64 GB |
| C: Drive | 342 GB total (~280 GB free) |
| D: Drive | 551 GB total (~157 GB free) |
| ERP DB | SQL Server, `sa` / `Polosys*123`, database `URBAN2_2025` |
| Tunnel | `https://erp-branch3.urbanRuyax.com` (Cloudflare) |
| NIC 1 | Broadcom NetXtreme Gigabit Ethernet (main network) |
| NIC 2 | Broadcom NetXtreme Gigabit Ethernet #2 (VM switch) |

### Ubuntu VM (Inside Local Server â€” Hyper-V)
| Setting | Value |
|---|---|
| VM Name | `Ubuntu-Supabase` |
| OS | Ubuntu 22.04.5 LTS Server |
| RAM | 8 GB (fixed) |
| CPU | 4 cores |
| Disk | 100 GB (VHDX on D:\VMs\) |
| Network | ExternalSwitch (NIC 2) |
| IP | `192.168.0.101` (DHCP â€” may change, consider static later) |
| Hostname | `supabase-local` |
| Username | `u` |
| Password | `u` |
| SSH | OpenSSH server installed |
| SSH Key Auth | `C:\Users\DELL\.ssh\id_ed25519_nopass` (passwordless, configured) |
| SSH Command | `ssh -i C:\Users\DELL\.ssh\id_ed25519_nopass u@192.168.0.101` |
| Auto-start | Enabled (starts with Windows Server) |

---

## ðŸ› ï¸ Setup Progress & Steps

### âœ… Phase 1: Server Preparation (COMPLETED)
1. âœ… Enabled RDP on local server (port 3389)
2. âœ… Configured PowerShell remoting from dev PC
   - Started WinRM service on dev PC
   - Set TrustedHosts to `192.168.0.3`
   - Command: `$cred = New-Object PSCredential("Administrator", (ConvertTo-SecureString "admin@123" -AsPlainText -Force)); Invoke-Command -ComputerName 192.168.0.3 -Credential $cred -ScriptBlock { ... }`
3. âœ… Attempted WSL2 installation (FAILED â€” build 20348.169 too old for WSL2)
4. âœ… Switched to Hyper-V approach

### âœ… Phase 2: Hyper-V Setup (COMPLETED)
1. âœ… Installed Hyper-V feature: `Install-WindowsFeature -Name Hyper-V -IncludeManagementTools`
2. âœ… Rebooted server
3. âœ… Created External Virtual Switch on NIC 2: `New-VMSwitch -Name "ExternalSwitch" -NetAdapterName "Embedded NIC 2" -AllowManagementOS $true`
4. âœ… Downloaded Ubuntu 22.04 Server ISO (~2 GB) to `C:\ubuntu-22.04.iso`

### âœ… Phase 3: Ubuntu VM Installation (COMPLETED)
1. âœ… Created VM: 8GB RAM, 4 CPU, 100GB disk on D:\VMs\
2. âœ… Attached ISO and booted
3. âœ… Installed Ubuntu 22.04 Server with:
   - Hostname: `supabase-local`
   - Username: `u`
   - Password: `u`
   - OpenSSH server: installed
   - Storage: entire 100GB disk with LVM
4. âœ… Removed ISO from DVD drive after install
5. âœ… VM boots into Ubuntu successfully
6. âœ… VM IP: `192.168.0.101`
7. âœ… Passwordless SSH configured (key: `id_ed25519_nopass`)

### âœ… Phase 4: Docker Installation (COMPLETED)
Docker 29.2.1 and Docker Compose v5.0.2 installed successfully.

```bash
# Commands used:
sudo apt update && sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker u
```

### âœ… Phase 5: Deploy Local Supabase (COMPLETED)
1. âœ… Cloned Supabase repo to `/opt/supabase/supabase/`
2. âœ… Configured `.env` with cloud-compatible JWT credentials
3. âœ… Disabled IPv6 to fix Docker pull issues (`sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1`)
4. âœ… Pulled all Docker images and started containers
5. âœ… Created `docker-compose.override.yml` to expose Studio port 3000
6. âœ… All 14 containers running and healthy
7. âœ… Verified LAN access from dev PC

**Key .env Settings:**
| Setting | Value |
|---|---|
| POSTGRES_PASSWORD | `<set via env var Ruyax_POSTGRES_PASSWORD>` (same as cloud) |
| JWT_SECRET | `<set via env var Ruyax_JWT_SECRET>` (same as cloud) |
| ANON_KEY | Same as cloud (for sync compatibility) |
| SERVICE_ROLE_KEY | Same as cloud (for sync compatibility) |
| SITE_URL | `http://192.168.0.101:3000` |
| API_EXTERNAL_URL | `http://192.168.0.101:8000` |
| SUPABASE_PUBLIC_URL | `http://192.168.0.101:8000` |
| DASHBOARD_USERNAME | `supabase` |
| DASHBOARD_PASSWORD | `LocalAdmin2025` |

**Override File:** `/opt/supabase/supabase/docker/docker-compose.override.yml`
```yaml
services:
  studio:
    ports:
      - '3000:3000'
```

**Local Supabase is accessible at:**
- Studio: `http://192.168.0.101:3000` (login: `supabase` / `LocalAdmin2025`)
- API: `http://192.168.0.101:8000`
- DB Pooler: `192.168.0.101:5432` / `192.168.0.101:6543`

**14 Running Containers:**
supabase-db, supabase-kong, supabase-auth, supabase-rest, supabase-storage, supabase-studio, supabase-meta, supabase-edge-functions, supabase-analytics, supabase-vector, supabase-imgproxy, supabase-pooler, realtime-dev.supabase-realtime, supabase-vector

### âŒ Phase 6: Sync Cloud Schema to Local (PENDING)
1. Export schema from cloud Supabase (tables, functions, RLS policies)
2. Import into local Supabase
3. Set up read-only RLS policies on local

```bash
# On cloud server â€” export schema
docker exec supabase-db pg_dump -U supabase_admin -d postgres --schema-only > /tmp/schema.sql

# Copy to local
scp root@8.213.42.21:/tmp/schema.sql ./schema.sql

# Import to local
docker cp schema.sql supabase-db:/tmp/schema.sql
docker exec supabase-db psql -U supabase_admin -d postgres -f /tmp/schema.sql
```

### âœ… Phase 7: Data Sync System (COMPLETED)
Sync system built into **StorageManager.svelte** â†’ Branch Sync tab:

1. âœ… **Branch Sync tab** in StorageManager with full UI (branch cards, sync progress, table-by-table status)
2. âœ… **RPC functions on cloud:** `get_branch_sync_configs`, `upsert_branch_sync_config`, `delete_branch_sync_config`, `update_branch_sync_status`
3. âœ… **Database table:** `branch_sync_config` with `tunnel_url` column for remote sync
4. âœ… **Full table sync:** Exports all rows from cloud â†’ pushes to local via REST API (XHR for LAN, server proxy for tunnel)
5. âœ… **Tunnel fallback:** Tries local URL first (5s timeout), falls back to tunnel URL via `/api/branch-proxy` server endpoint (avoids CORS)
6. âœ… **Server proxy endpoint:** `frontend/src/routes/api/branch-proxy/+server.ts` â€” proxies requests server-side to avoid browser CORS
7. âœ… **72 tables synced** in FK-safe order with phase 1 (clear) + phase 2 (import)
8. âœ… **Last successful sync:** 160,426 rows across 29 tables

**Architecture:**
```
Cloud Supabase â”€â”€â–º Export all rows (paginated, 5000/batch)
                        â”‚
        â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
        â”‚ On LAN?                       â”‚ Outside LAN?
        â–¼                               â–¼
  XHR direct to                   /api/branch-proxy
  http://192.168.0.101:8000       (server-side fetch)
        â”‚                               â”‚
        â–¼                               â–¼
  Local Supabase â—„â”€â”€â”€â”€ REST API â”€â”€â”€â”€â”€â”€ Tunnel URL
  (clear + upsert)     (POST)     https://supabase-branch3.urbanRuyax.com
```

**Config stored in `branch_sync_config` table:**
| Column | Example |
|---|---|
| `branch_id` | 3 |
| `local_supabase_url` | `http://192.168.0.101:8000` |
| `local_supabase_key` | Service role JWT |
| `tunnel_url` | `https://supabase-branch3.urbanRuyax.com` |
| `sync_tables` | Array of 29 table names |
| `last_sync_at` | Timestamp of last sync |
| `last_sync_status` | `success` / `failed` / `in_progress` |

### âŒ Phase 8: Read-Only Ruyax Frontend (PENDING)
1. Build Ruyax frontend with local Supabase URL
2. Deploy as static files served by nginx in Docker
3. Accessible on LAN at `http://<VM-IP>`
4. Read-only mode: disable all create/edit/delete buttons

### âš ï¸ Phase 9: Cloudflare Tunnel for Local (PARTIALLY DONE)
1. âœ… `cloudflared` already running on branch server (installed via ERP setup wizard)
2. âœ… Cloudflare tunnel route added: `supabase-branch3.urbanRuyax.com` â†’ `http://localhost:8000`
   - Added via Cloudflare Zero Trust dashboard â†’ Networks â†’ Tunnels â†’ erp-branch3 â†’ Published application routes
3. âŒ **502 Bad Gateway** â€” tunnel route exists but branch Supabase returns 502
   - **Likely cause:** Supabase containers may not be running on the VM, or VM may be powered off
   - **To fix:** RDP into `192.168.0.3`, check VM status, SSH to `192.168.0.101`, run `docker compose ps` in `/opt/supabase/supabase/docker/`
   - If containers are down: `cd /opt/supabase/supabase/docker && docker compose up -d`
4. âŒ Need to verify tunnel works end-to-end once branch Supabase is confirmed running

---

## ðŸ”‘ Key Commands Reference

### PowerShell Remoting to Local Server
```powershell
$cred = New-Object PSCredential("Administrator", (ConvertTo-SecureString "admin@123" -AsPlainText -Force))
Invoke-Command -ComputerName 192.168.0.3 -Credential $cred -ScriptBlock { ... }
```

### Hyper-V VM Management
```powershell
# From dev PC (remote)
$cred = New-Object PSCredential("Administrator", (ConvertTo-SecureString "admin@123" -AsPlainText -Force))

# Start VM
Invoke-Command -ComputerName 192.168.0.3 -Credential $cred -ScriptBlock { Start-VM "Ubuntu-Supabase" }

# Stop VM
Invoke-Command -ComputerName 192.168.0.3 -Credential $cred -ScriptBlock { Stop-VM "Ubuntu-Supabase" }

# Check VM status
Invoke-Command -ComputerName 192.168.0.3 -Credential $cred -ScriptBlock { Get-VM "Ubuntu-Supabase" | Select Name, State, CPUUsage, MemoryAssigned }

# Get VM IP
Invoke-Command -ComputerName 192.168.0.3 -Credential $cred -ScriptBlock { Get-VMNetworkAdapter -VMName "Ubuntu-Supabase" | Select IPAddresses }

# Open VM console (from server desktop)
vmconnect.exe localhost Ubuntu-Supabase
```

### SSH to Ubuntu VM
```bash
# Passwordless SSH (preferred)
ssh -i C:\Users\DELL\.ssh\id_ed25519_nopass u@192.168.0.101

# Or with password
ssh u@192.168.0.101
# Password: u
```

### Docker Commands (inside Ubuntu VM)
```bash
# Check Supabase containers
cd /opt/supabase/supabase/docker
docker-compose ps

# Restart Supabase
docker-compose restart

# View logs
docker-compose logs -f --tail 50

# Access PostgreSQL
docker exec -it supabase-db psql -U supabase_admin -d postgres
```

---

## ðŸ“ File Locations

### On Dev PC (D:\Ruyax)
| File | Purpose |
|---|---|
| `frontend/` | Main Ruyax SvelteKit app |
| `frontend/src/lib/components/desktop-interface/settings/StorageManager.svelte` | Storage manager with sync button (future) |

### On Local Server (192.168.0.3)
| File | Purpose |
|---|---|
| `C:\ubuntu-22.04.iso` | Ubuntu installer ISO (~2 GB) |
| `C:\ubuntu_x64\install.tar.gz` | Ubuntu rootfs (from WSL attempt) |
| `D:\VMs\Ubuntu-Supabase.vhdx` | VM disk image |

### On Ubuntu VM
| Path | Purpose |
|---|---|
| `/opt/supabase/` | Supabase installation (future) |
| `/opt/supabase/supabase/docker/` | Docker compose files |
| `/opt/supabase/supabase/docker/.env` | Supabase configuration |

### On Cloud Server (8.213.42.21)
| Path | Purpose |
|---|---|
| `/opt/supabase/supabase/docker/` | Main Supabase installation |
| `/opt/supabase/supabase-restart-watcher.sh` | Server restart watcher script |

---

## ðŸ”„ How Sync Will Work (Final Design)

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                    MAIN Ruyax APP (Cloud)                     â”‚
â”‚                                                              â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”     â”‚
â”‚  â”‚ Sync Button â”‚â”€â”€â”€â–ºâ”‚ 1. Query changed rows since     â”‚     â”‚
â”‚  â”‚ in sidebar  â”‚    â”‚    last_sync_timestamp           â”‚     â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â”‚ 2. Package as JSON               â”‚     â”‚
â”‚                     â”‚ 3. Send via tunnel to local API   â”‚     â”‚
â”‚                     â”‚ 4. Local upserts all data         â”‚     â”‚
â”‚                     â”‚ 5. Update last_sync_timestamp     â”‚     â”‚
â”‚                     â”‚ 6. Show success/failure           â”‚     â”‚
â”‚                     â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                           â”‚
                           â–¼ HTTPS via Cloudflare Tunnel
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                LOCAL SUPABASE (Ubuntu VM)                     â”‚
â”‚                                                              â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”     â”‚
â”‚  â”‚ Receive API â”‚â”€â”€â”€â–ºâ”‚ 1. Validate service_role key    â”‚     â”‚
â”‚  â”‚ call        â”‚    â”‚ 2. Upsert data into tables       â”‚     â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â”‚ 3. Return success/error count    â”‚     â”‚
â”‚                     â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â”‚
â”‚                                                              â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”‚
â”‚  â”‚ LOCAL Ruyax FRONTEND (read-only)                     â”‚    â”‚
â”‚  â”‚ Accessible at http://<VM-IP>                         â”‚    â”‚
â”‚  â”‚ Same UI, but all write operations disabled           â”‚    â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### Tables to Sync
All main application tables including:
- `employee_master` â€” Employee records
- `branches` â€” Branch information
- `departments` â€” Departments
- `designations` â€” Job designations
- `attendance_*` â€” Attendance data
- `payroll_*` â€” Payroll data
- `inventory_*` â€” Inventory data
- `sales_*` â€” Sales data
- `hr_*` â€” HR records
- `auth.users` â€” User accounts (for login)
- All other application tables

### What Gets Synced
- **Full sync (first time):** All data from all tables
- **Incremental sync (subsequent):** Only rows where `updated_at > last_sync_timestamp`
- **Direction:** Cloud â†’ Local only (one-way)
- **Frequency:** Manual (user clicks Sync button)

---

## âš ï¸ Important Notes

1. **WSL2 does NOT work** on this Windows Server build (10.0.20348.169) â€” that's why we use Hyper-V
2. The VM gets its IP via DHCP â€” it may change after reboot. Consider setting a static IP later
3. The VM is set to **auto-start** with the Windows Server
4. The local Supabase is a **separate instance** â€” not a PostgreSQL replica
5. Sync is **one-way** (cloud â†’ local) to keep it simple and safe
6. The local Ruyax frontend will be **read-only** â€” no data modification allowed
7. The External Virtual Switch uses NIC 2 â€” NIC 1 remains for the main server network

---

## ðŸš¨ Troubleshooting

### Can't connect to VM
```powershell
# Check VM is running
$cred = New-Object PSCredential("Administrator", (ConvertTo-SecureString "admin@123" -AsPlainText -Force))
Invoke-Command -ComputerName 192.168.0.3 -Credential $cred -ScriptBlock { Get-VM "Ubuntu-Supabase" }

# Start VM if stopped
Invoke-Command -ComputerName 192.168.0.3 -Credential $cred -ScriptBlock { Start-VM "Ubuntu-Supabase" }

# Get VM IP
Invoke-Command -ComputerName 192.168.0.3 -Credential $cred -ScriptBlock { Get-VMNetworkAdapter -VMName "Ubuntu-Supabase" | Select IPAddresses }
```

### VM has no network
- Check the ExternalSwitch is connected to NIC 2
- Verify NIC 2 has a cable connected
- Inside VM: `sudo dhclient eth0`

### Can't SSH to VM
- Verify SSH is running: `sudo systemctl status ssh`
- Check firewall: `sudo ufw status` (should be inactive or allow port 22)
- Try from the Hyper-V host: `ssh ubuntu@<VM-IP>`

### Docker containers not starting
```bash
cd /opt/supabase/supabase/docker
docker-compose logs --tail 50
docker-compose down
docker-compose up -d
```

### PowerShell remoting fails
```powershell
# On dev PC
Start-Service WinRM
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "192.168.0.3" -Force
```

