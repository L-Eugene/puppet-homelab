# Puppet 7.11.0 - Quick Reference Summary

## ✓ MODULES YOU CAN KEEP AT CURRENT VERSION (No Changes)

| Module | Current | Puppet Req | Notes |
|--------|---------|-----------|-------|
| puppet-archive | 8.1.0 | >= 7.0.0 < 9.0.0 | ✓ Already compatible |
| puppetlabs-reboot | 5.1.0 | >= 7.0.0 < 9.0.0 | ✓ Has CVE-2024-49761 fix |
| puppetlabs-vcsrepo | 7.0.0 | >= 7.0.0 < 9.0.0 | ✓ Has CVE-2024-49761 fix |
| saz-timezone | 7.0.0 | >= 7.0.0 < 9.0.0 | ✓ Already compatible |

**Action**: No changes needed for these 4 modules.

---

## ⚠ MODULES THAT NEED DOWNGRADE FOR PUPPET 7.11.0

### PRIORITY 1: Core Libraries (Apply First)

| Module | Current | → Downgrade | Puppet Req | Risk |
|--------|---------|----------|-----------|------|
| puppetlabs-stdlib | 10.0.1 | 9.7.0 | >= 7.0.0 < 8.0.0 | 🟡 Medium |
| puppetlabs-apt | 11.3.2 | 11.2.0 | >= 7.0.0 < 9.0.0 | 🟢 Low |
| stm-debconf | 8.0.0 | 6.1.0 | >= 6.0.0 < 7.0.0 | 🟢 Low |

**Action**: Update Puppetfile and run `r10k puppetfile install`

---

### PRIORITY 2: Service Modules (Test in Devcontainer)

| Module | Current | → Downgrade | Puppet Req | Risk | Action |
|--------|---------|----------|-----------|------|--------|
| puppet-hiera | 7.0.0 | 6.0.0 | >= 7.0.0 < 8.0.0 | 🟢 Low | Test eyaml |
| puppet-systemd | 9.4.0 | 6.1.0 | >= 6.0.0 < 7.0.0 | 🟡 Medium | Verify systemd resources |
| puppetlabs-docker | 10.4.1 | 9.4.0 | >= 7.0.0 < 9.0.0 | 🟡 Medium | Test containers |
| puppetlabs-firewall | 8.5.0 | 7.3.0 | >= 7.0.0 < 8.0.0 | 🔴 High | **Test iptables!** |
| puppetlabs-inifile | 6.4.1 | 5.4.1 | >= 5.0.0 < 6.0.0 | 🟢 Low | Test ini files |

**Action**: Test each in devcontainer before production

---

### PRIORITY 3: Data Modules (Manifest Review Required)

| Module | Current | → Downgrade | Puppet Req | Risk | Critical Action |
|--------|---------|----------|-----------|------|-----------------|
| puppetlabs-mysql | 17.1.0 | 16.3.0 | >= 7.0.0 < 8.0.0 | 🔴 High | **Search manifests for `expire_logs_days`** |
| puppetlabs-powershell | 6.1.0 | 6.0.0 | >= 7.0.0 < 8.0.0 | 🟡 Medium | Only if Windows nodes exist |

**Action**: Review manifests before downgrading

---

## WHAT'S BREAKING IN v17.0.0+ (MySQL)

❌ These WILL BREAK if you upgrade puppetlabs-mysql beyond 16.3.0 without fixing:

1. Parameter removed: `expire_logs_days`
   - Search: `grep -r "expire_logs_days" site/`
   - Action: Delete this parameter from mysql::server config

2. Charset default changed: utf8 → utf8mb3
   - Not breaking but behavior change
   - Action: Explicitly set charset if needed

---

## UPDATED PUPPETFILE SNIPPET

```puppet
# TIER 1: Core libraries
mod 'puppetlabs-stdlib', '9.7.0'           # Down from 10.0.1
mod 'puppetlabs-apt', '11.2.0'             # Down from 11.3.2
mod 'stm-debconf', '6.1.0'                 # Down from 8.0.0

# TIER 2: Service modules
mod 'puppet-hiera', '6.0.0'                # Down from 7.0.0
mod 'puppet-systemd', '6.1.0'              # Down from 9.4.0
mod 'puppet-archive', '8.1.0'              # KEEP (no change)
mod 'puppetlabs-docker', '9.4.0'           # Down from 10.4.1
mod 'puppetlabs-firewall', '7.3.0'         # Down from 8.5.0
mod 'puppetlabs-inifile', '5.4.1'          # Down from 6.4.1

# TIER 3: Data modules (review manifests first!)
mod 'puppetlabs-mysql', '16.3.0'           # Down from 17.1.0
mod 'puppetlabs-powershell', '6.0.0'       # Down from 6.1.0

# Already compatible - KEEP CURRENT
mod 'puppetlabs-reboot', '5.1.0'           # KEEP
mod 'puppetlabs-vcsrepo', '7.0.0'          # KEEP
mod 'saz-timezone', '7.0.0'                # KEEP

# Unchanged
mod 'landcareresearch-amazon_s3', '6.0.0'  # KEEP
mod 'puppetlabs-puppetserver_gem', '1.1.1' # KEEP
mod 'geoffwilliams-sysctl', '1.0.1'        # KEEP
```

---

## MIGRATION STEPS

### Step 1: Pre-Flight Check (5 min)
```bash
# Check for MySQL `expire_logs_days` usage
grep -r "expire_logs_days" site/

# Current Puppet version
puppet --version  # Should be 7.x

# List current versions
puppet module list
```

### Step 2: Update Puppetfile (5 min)
- Edit [Puppetfile](Puppetfile) with versions above
- Validate: `puppet parser validate Puppetfile` (if validation available)

### Step 3: Install Modules (10 min)
```bash
r10k puppetfile install
puppet parser validate manifests/site.pp
```

### Step 4: Test in Devcontainer (30 min)
```bash
cd .devcontainer/local-test
./pa.sh test_sample.pp
# Verify no errors
# Check firewall rules: iptables-save
# Check services: systemctl status
```

### Step 5: Staged Rollout (2-3 days)
- Apply to dev node → monitor 24h
- Apply to staging nodes → monitor 48h
- Apply to production (one node at a time)

---

## SECURITY UPDATES INCLUDED

✓ **CVE-2024-49761** (rexml DoS): Already in 5.1.0 (reboot) and 7.0.0 (vcsrepo)
✓ **Stability fixes**: All downgraded versions are stable releases

---

## DETAILED ANALYSIS

For complete module-by-module analysis, see:
👉 [PUPPET_7_COMPATIBILITY_ANALYSIS.md](PUPPET_7_COMPATIBILITY_ANALYSIS.md)

Key sections:
- Breaking changes by module
- Feature comparison (7.x vs 8.x)
- Migration checklist
- Timeline estimates
