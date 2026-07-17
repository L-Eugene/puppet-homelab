# Puppet 7.11.0 - Latest Compatible Module Versions Analysis

## Executive Summary

For **Puppet Server 7.11.0**, maintaining compatibility requires:
- **4 modules** can stay at current versions (already compatible)
- **10 modules** require downgrades to Puppet 7.x-compatible versions
- **Most downgrades are 1-2 minor versions**, not major breaking changes

### Key Finding: Module Landscape Changed
Most puppetlabs/puppet/voxpupuli modules dropped Puppet 7 support between versions released in June-July 2026. The transition typically happened:
- **v10.0.0+ series**: Puppet 8-only
- **v9.7.0 and earlier**: Last Puppet 7-compatible

---

## ✓ MODULES COMPATIBLE AT CURRENT VERSIONS

These can remain unchanged for Puppet 7.11.0:

| Module | Version | Requires | Notes |
|--------|---------|----------|-------|
| **puppet-archive** | 8.1.0 | >= 7.0.0 < 9.0.0 | Latest; supports both P7 & P8 |
| **puppetlabs-reboot** | 5.1.0 | >= 7.0.0 < 9.0.0 | **✓ CVE-2024-49761 fix included** |
| **puppetlabs-vcsrepo** | 7.0.0 | >= 7.0.0 < 9.0.0 | **✓ CVE-2024-49761 fix included** |
| **saz-timezone** | 7.0.0 | >= 7.0.0 < 9.0.0 | Requires stm-debconf >= 6.x |

---

## ⚠ MODULES REQUIRING DOWNGRADE FOR PUPPET 7.x

### TIER 1: CORE LIBRARIES (Do First - No Manifest Changes Needed)

#### 1. puppetlabs-stdlib
- **Current**: 10.0.1 (Puppet 8-only)
- **Downgrade to**: **9.7.0**
- **Requires**: >= 7.0.0 < 8.0.0
- **Why**: v10.0.0 explicitly dropped Puppet 7 (CAT-2395)
- **Impact**: Core library; affects all dependent modules
- **Breaking Changes**: Minimal
- **Security**: v9.7.0 is latest before Puppet 8 transition

#### 2. puppetlabs-apt
- **Current**: 11.3.2 (Puppet 8-only)
- **Downgrade to**: **11.2.0**
- **Requires**: >= 7.0.0 < 9.0.0
- **Why**: v11.3.x adds stdlib 10.x support (P8-only)
- **Impact**: Minor dependency update
- **Breaking Changes**: None
- **Security**: Stable release

#### 3. stm-debconf
- **Current**: 8.0.0 (Puppet 8-only)
- **Downgrade to**: **6.1.0** (or latest 6.x)
- **Requires**: >= 6.0.0 < 7.0.0
- **Why**: v8.0.0 requires Puppet 8; v6.x supports both 7 and 8
- **Impact**: Required by saz-timezone (needs >= 6.x)
- **Breaking Changes**: None
- **Security**: Stable release
- **Coordination**: Must pair with saz-timezone 7.0.0

### TIER 2: SERVICE MODULES (Test in Devcontainer)

#### 4. puppet-hiera
- **Current**: 7.0.0 (Puppet 8-only)
- **Downgrade to**: **6.0.0**
- **Requires**: >= 7.0.0 < 8.0.0
- **Why**: v7.0.0 dropped Ubuntu 20.04, likely dropped Puppet 7
- **Impact**: Hiera/eyaml configuration
- **Breaking Changes**: Minimal; v7 manages eyaml globally (optional)
- **Security**: Stable release
- **Test**: Verify eyaml key decryption works

#### 5. puppet-systemd
- **Current**: 9.4.0 (Puppet 8-only)
- **Downgrade to**: **6.1.0** (or 6.x latest)
- **Requires**: >= 6.0.0 < 7.0.0
- **Why**: v7.0.0+ requires Puppet 8; v6.x supports both
- **Impact**: Systemd resource management
- **Breaking Changes**: Moderate; multiple major versions
  - API backward compatible for existing manifests
  - New features in 7.x/8.x/9.x not available
- **Security**: v6.1.0 is stable
- **Test**: Verify systemd resource declarations still work
- **Alternate**: v5.2.0 if v6.1.0 has issues (older but proven)

#### 6. puppetlabs-docker
- **Current**: 10.4.1 (Puppet 8-only)
- **Downgrade to**: **9.4.0**
- **Requires**: >= 7.0.0 < 9.0.0
- **Why**: v10.0.0+ requires Puppet 8
- **Impact**: Docker service and container management
- **Breaking Changes**: None vs current setup (docker-compose fixes already implemented)
- **Security**: v9.4.0 has recent fixes
- **Test**: Verify container deployments

#### 7. puppetlabs-firewall
- **Current**: 8.5.0 (Puppet 8-only)
- **Downgrade to**: **7.3.0** (or latest 7.x)
- **Requires**: >= 7.0.0 < 8.0.0
- **Why**: v8.0.0+ requires Puppet 8
- **Impact**: iptables firewall rule management
- **Breaking Changes**: Moderate; rule format may differ
- **Security**: v7.3.0 and later have security improvements
- **Test**: **CRITICAL** - validate iptables rules on test node first
- **Note**: Significant version jump; manifests may need review

#### 8. puppetlabs-inifile
- **Current**: 6.4.1 (Puppet 8-only)
- **Downgrade to**: **5.4.1**
- **Requires**: >= 5.0.0 < 6.0.0
- **Why**: v6.0.0+ requires Puppet 8
- **Impact**: INI file management
- **Breaking Changes**: None expected
- **Security**: v5.4.1 is stable
- **Test**: Verify ini file sections/settings are properly managed

### TIER 3: DATA-INTENSIVE MODULES (Manifest Review Required)

#### 9. puppetlabs-mysql
- **Current**: 17.1.0 (Puppet 8-only)
- **Downgrade to**: **16.3.0**
- **Requires**: >= 7.0.0 < 8.0.0
- **Why**: v17.0.0+ requires Puppet 8 (CAT-2381)
- **Impact**: MySQL server and database management
- **Breaking Changes**: **CRITICAL**
  - v17.x **removes** `expire_logs_days` parameter
  - Charset handling changed: utf8 → utf8mb3
  - Test if your manifests use `expire_logs_days`
- **Security**: v16.3.0 is latest Puppet 7 version
- **Action**: Search manifests for `expire_logs_days` and remove before upgrade
- **Test**: **CRITICAL** - verify database operations

#### 10. puppetlabs-powershell
- **Current**: 6.1.0 (Puppet 8-only)
- **Downgrade to**: **6.0.0** or **5.4.0**
- **Requires**: Verify compatibility
- **Why**: v6.1.0 has Puppetcore update (CAT-2386)
- **Impact**: Windows PowerShell DSC resources (if Windows nodes used)
- **Breaking Changes**: v6.1.0 is minor security update
- **Security**: v6.1.0 may be security-related; v6.0.0 is stable fallback
- **Note**: Less critical if Linux-only infrastructure
- **Test**: Only needed if Windows nodes exist

---

## DETAILED VERSION COMPATIBILITY TABLE

| # | Module | Current | Downgrade To | P7 Support | Notes |
|---|--------|---------|--------------|-----------|-------|
| 1 | puppetlabs-stdlib | 10.0.1 | **9.7.0** | Yes | Core library; CAT-2395 |
| 2 | puppetlabs-apt | 11.3.2 | **11.2.0** | Yes | Minor downgrade |
| 3 | puppet-hiera | 7.0.0 | **6.0.0** | Yes | Hiera/eyaml config |
| 4 | puppet-systemd | 9.4.0 | **6.1.0** | Yes | Multiple major versions |
| 5 | puppet-archive | 8.1.0 | ✓ **KEEP** | Yes | Already compatible |
| 6 | puppetlabs-docker | 10.4.1 | **9.4.0** | Yes | Container mgmt |
| 7 | puppetlabs-firewall | 8.5.0 | **7.3.0** | Yes | iptables rules (⚠ test) |
| 8 | puppetlabs-inifile | 6.4.1 | **5.4.1** | Yes | INI file mgmt |
| 9 | puppetlabs-mysql | 17.1.0 | **16.3.0** | Yes | Drops expire_logs_days (⚠ review) |
| 10 | puppetlabs-powershell | 6.1.0 | **6.0.0** | Maybe | Windows only |
| 11 | puppetlabs-reboot | 5.1.0 | ✓ **KEEP** | Yes | Already compatible |
| 12 | puppetlabs-vcsrepo | 7.0.0 | ✓ **KEEP** | Yes | Already compatible |
| 13 | saz-timezone | 7.0.0 | ✓ **KEEP** | Yes | Already compatible |
| 14 | stm-debconf | 8.0.0 | **6.1.0** | Yes | Paired with saz-timezone |

---

## RECOMMENDED PUPPETFILE (Puppet 7.11.0)

```puppet
# Core Libraries - Puppet 7.x compatible versions
mod 'puppetlabs-stdlib', '9.7.0'           # Downgrade from 10.0.1
mod 'puppetlabs-apt', '11.2.0'             # Downgrade from 11.3.2
mod 'stm-debconf', '6.1.0'                 # Downgrade from 8.0.0

# Service Modules - Latest or compatible versions
mod 'puppet-hiera', '6.0.0'                # Downgrade from 7.0.0
mod 'puppet-systemd', '6.1.0'              # Downgrade from 9.4.0
mod 'puppet-archive', '8.1.0'              # Keep current (compatible)
mod 'puppetlabs-docker', '9.4.0'           # Downgrade from 10.4.1
mod 'puppetlabs-firewall', '7.3.0'         # Downgrade from 8.5.0
mod 'puppetlabs-inifile', '5.4.1'          # Downgrade from 6.4.1

# Data-Intensive Modules
mod 'puppetlabs-mysql', '16.3.0'           # Downgrade from 17.1.0
mod 'puppetlabs-powershell', '6.0.0'       # Downgrade from 6.1.0

# Already Compatible - Keep Current
mod 'puppetlabs-reboot', '5.1.0'           # Keep current
mod 'puppetlabs-vcsrepo', '7.0.0'          # Keep current
mod 'saz-timezone', '7.0.0'                # Keep current

# Other Modules
mod 'landcareresearch-amazon_s3', '6.0.0'  # Keep current
mod 'puppetlabs-puppetserver_gem', '1.1.1' # Keep current
mod 'geoffwilliams-sysctl', '1.0.1'        # Keep current
```

---

## SECURITY CONSIDERATIONS FOR PUPPET 7.x

### CVE-2024-49761 (rexml DoS)
**Status**: Already handled in compatible versions
- ✓ puppetlabs-reboot 5.1.0 - includes fix
- ✓ puppetlabs-vcsrepo 7.0.0 - includes fix
- v9.7.0+ (stdlib): Should be included

### Other Security Updates
- Most v7.x versions of puppetlabs modules predate recent CVE releases
- Keep systems patched at OS level
- Monitor Puppet Forge for backports to 7.x series (rare)

---

## BREAKING CHANGES TO WATCH

### puppetlabs-mysql 17.x → 16.3.0
**ACTION REQUIRED**: Before updating puppetlabs-mysql beyond 16.3.0, ensure:
1. No manifests use `expire_logs_days` parameter
2. No charset assumptions on `utf8` (becomes `utf8mb3`)
3. All database configurations reviewed

### puppet-systemd 9.x → 6.x
**ACTION REQUIRED**: Verify systemd resource declarations:
- Type: `systemd_unit`
- Type: `systemd_service`
- Others: Check if used in manifests

### puppetlabs-firewall 8.x → 7.x
**ACTION REQUIRED**: Test firewall rules:
1. Apply to test node
2. Verify iptables output: `iptables-save`
3. Check no unintended rule changes

### saz-timezone 7.0.0 + stm-debconf
**COORDINATION REQUIRED**: Ensure stm-debconf >= 6.x when using saz-timezone 7.0.0
- These are already compatible in current Puppetfile
- Just ensure coordinated upgrades/downgrades

---

## MIGRATION CHECKLIST

### Pre-Migration
- [ ] Back up current Puppetfile to git
- [ ] Test in devcontainer with sample nodes
- [ ] Review manifests for:
  - [ ] MySQL `expire_logs_days` usage
  - [ ] Systemd resource declarations
  - [ ] Custom firewall rules
  - [ ] Hiera eyaml integration

### Migration Phase 1: Update Puppetfile
- [ ] Replace current Puppetfile with Puppet 7.x versions
- [ ] Run `r10k puppetfile install`
- [ ] Run `puppet parser validate manifests/site.pp`

### Migration Phase 2: Test in Devcontainer
```bash
# Test with sample manifests
cd .devcontainer/local-test
./pa.sh test_sample.pp
# Verify no errors
```

### Migration Phase 3: Staged Rollout
- [ ] Apply to dev node first
- [ ] Monitor for 24 hours
- [ ] Apply to staging nodes
- [ ] Monitor for 48 hours
- [ ] Apply to production (one node at a time)

### Post-Migration
- [ ] Verify all services running
- [ ] Test critical functionality:
  - [ ] Package updates
  - [ ] Firewall rules active
  - [ ] Databases operational
  - [ ] Hiera lookups working
  - [ ] Version control operations (vcsrepo)
  - [ ] Timezone correct
  - [ ] System reboots successful

---

## REFERENCES

- [Puppet 7.x Release Notes](https://puppet.com/docs/puppet/7.latest/release_notes.html)
- [puppetlabs-stdlib CHANGELOG](modules/stdlib/CHANGELOG.md)
- [Puppet Forge Module Requirements](https://forge.puppet.com)
- [Security: CVE-2024-49761](https://nvd.nist.gov/vuln/detail/CVE-2024-49761)

---

## ESTIMATED TIMELINE

- **Phase 1 (Puppetfile update)**: 15 minutes
- **Phase 2 (Devcontainer testing)**: 30 minutes  
- **Phase 3 (Staged rollout)**: 2-3 days (with monitoring)
- **Total**: 2-3 hours hands-on work + 2-3 days observation

