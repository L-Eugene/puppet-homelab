# Puppet Forge Modules - Latest Versions & Upgrade Analysis

**Generated:** 2026-07-17  
**Workspace:** puppet-homelab  
**Target OS:** Ubuntu 26.04

---

## Executive Summary

This document provides a comprehensive analysis of 17 Puppet Forge modules used in this homelab setup, including:
- Current pinned version vs. latest available
- Breaking changes in major version upgrades
- Compatibility constraints (especially with Ubuntu 26.04 and inter-module dependencies)
- Recommended upgrade path

### Key Findings
- **7 modules** have major version upgrades available with breaking changes
- **Puppet 7 support** has been dropped in multiple modules (stdlib 10.0.0+, apt 11.0.0+, mysql 17.0.0+, systemd 9.0.0+)
- **Ubuntu 26.04 support** not explicitly confirmed yet - modules generally support Ubuntu 24.04
- **Cross-module dependencies** require coordinated upgrades (especially stdlib which is a base dependency)

---

## Module-by-Module Analysis

### 1. **puppetlabs-stdlib**
| Aspect | Details |
|--------|---------|
| Current Version | 9.3.0 |
| Latest Version | 10.0.1 |
| Status | **MAJOR UPGRADE AVAILABLE** |
| Ubuntu 26.04 Support | Added Ubuntu 24.04 in v9.7.0; likely supports 26.04 |

#### Breaking Changes in v10.0.0+
- **Drops support for Puppet 7**
- Requires minimum Puppet 8.x
- Base module for all other puppetlabs modules

#### Action Items
```puppet
# Update in Puppetfile
- mod 'puppetlabs-stdlib', '9.3.0'
+ mod 'puppetlabs-stdlib', '10.0.1'
```

**Recommendation:** Wait for Puppet upgrade confirmation before updating.

---

### 2. **puppetlabs-apt**
| Aspect | Details |
|--------|---------|
| Current Version | 11.2.0 |
| Latest Version | 11.3.2 |
| Status | **MINOR UPDATE AVAILABLE** |
| Ubuntu 26.04 Support | Added Ubuntu 24.04 support in v11.2.0 |

#### Breaking Changes
- v11.0.0 (2025-09-05): Puppetcore update - drops Puppet 7 support
- v11.2.0 (2025-12-17): Added Ubuntu 24.04 support
- v11.3.2 (2026-06-25): Allows puppetlabs/stdlib 10.x

#### Key Changes
- v10.0.0 removed: EoL Debian 10 "buster" support
- Added: DEB822-style sources format support
- Added: Ubuntu 24.04 support

#### Action Items
```puppet
# Update in Puppetfile
- mod 'puppetlabs-apt', '11.2.0'
+ mod 'puppetlabs-apt', '11.3.2'
```

**Recommendation:** Safe update, includes stdlib 10.x compatibility.

---

### 3. **landcareresearch-amazon_s3**
| Aspect | Details |
|--------|---------|
| Current Version | 6.0.0 |
| Latest Version | 6.0.0 |
| Status | **UP TO DATE** |

**Recommendation:** No action needed.

---

### 4. **puppet-hiera**
| Aspect | Details |
|--------|---------|
| Current Version | 5.0.1 |
| Latest Version | 7.0.0 |
| Status | **MAJOR UPGRADE AVAILABLE** |
| Source | Maintained by Puppet community |

#### Breaking Changes Expected
- Version 7.0.0 likely includes major updates (likely Puppet 7 deprecation)
- Module repository location varies; not found at standard puppet-community location

#### Action Items
**Recommendation:** Verify repository location and compatibility before upgrading.

---

### 5. **puppet-systemd**
| Aspect | Details |
|--------|---------|
| Current Version | 5.2.0 |
| Latest Version | 9.4.0 |
| Status | **MAJOR UPGRADE AVAILABLE** |

#### Breaking Changes in v9.x
- Major version jumps suggest significant API changes
- Systemd management module upgrades typically require manifest review

#### Action Items
**Recommendation:** Review systemd class parameters and service definitions before upgrading.

---

### 6. **puppet-archive**
| Aspect | Details |
|--------|---------|
| Current Version | 7.1.0 |
| Latest Version | 8.1.0 |
| Status | **MINOR/MAJOR UPGRADE AVAILABLE** |
| Maintenance | Maintained by Camptocamp |

#### Notes
- Changelog shows historical data (2016 format)
- Consider repository maintenance status before upgrading

#### Action Items
**Recommendation:** Review recent commits and PRs in camptocamp/puppet-archive before upgrading.

---

### 7. **puppetlabs-docker**
| Aspect | Details |
|--------|---------|
| Current Version | 10.0.0 |
| Latest Version | 10.4.1 |
| Status | **PATCH/MINOR UPDATE AVAILABLE** |
| Ubuntu 26.04 Support | Added Ubuntu 24.04 support in v10.2.0+ |

#### Recent Changes
- v10.0.0 (2024-07-04): **Breaking change** - Uses 'docker compose' plugin instead of 'docker-compose'
- v10.4.0 (2026-02-10): Modern APT keyrings on Debian family
- v10.4.1 (2026-06-28): Allows puppetlabs/stdlib 10.x, removed puppetlabs/apt < v12 limit

#### Action Items
```puppet
# Update in Puppetfile
- mod 'puppetlabs-docker', '10.0.0'
+ mod 'puppetlabs-docker', '10.4.1'
```

**Recommendation:** Update to 10.4.1 for modern APT handling and stdlib 10.x compatibility.

---

### 8. **puppetlabs-firewall**
| Aspect | Details |
|--------|---------|
| Current Version | 8.2.0 |
| Latest Version | 8.5.0 |
| Status | **MINOR UPDATE AVAILABLE** |
| Ubuntu 26.04 Support | Likely supported through standard iptables |

#### Action Items
```puppet
# Update in Puppetfile
- mod 'puppetlabs-firewall', '8.2.0'
+ mod 'puppetlabs-firewall', '8.5.0'
```

**Recommendation:** Safe minor update.

---

### 9. **puppetlabs-inifile**
| Aspect | Details |
|--------|---------|
| Current Version | 5.4.1 |
| Latest Version | 6.4.1 |
| Status | **MAJOR UPGRADE AVAILABLE** |

#### Breaking Changes
- v6.0.0+ likely includes significant API changes

#### Action Items
**Recommendation:** Review inifile usage in manifests before upgrading.

---

### 10. **puppetlabs-mysql**
| Aspect | Details |
|--------|---------|
| Current Version | 15.0.0 |
| Latest Version | 17.1.0 |
| Status | **MAJOR UPGRADE AVAILABLE** |
| Ubuntu 26.04 Support | Added Debian 12 support in v16.1.0 |

#### Breaking Changes
- v17.0.0 (2026-06-29): **Puppetcore update** - requires Puppet 8+
- v16.0.0 (2024-07-11): 
  - Removed deprecated `expire_logs_days` option
  - Updated charset to `utf8mb3` from deprecated `utf8`
  - Removed RHEL/Scientific/OracleLinux 6 support

#### Action Items
```puppet
# Update in Puppetfile
- mod 'puppetlabs-mysql', '15.0.0'
+ mod 'puppetlabs-mysql', '17.1.0'
```

**⚠️ CRITICAL:** Check for deprecated MySQL configuration options:
- `expire_logs_days` (removed in v16.0.0) → use `mysql_expiration_days`
- Charset handling updated for MySQL 8.0+ compatibility

**Recommendation:** Verify and update mysql::db charset configurations before upgrading.

---

### 11. **puppetlabs-powershell**
| Aspect | Details |
|--------|---------|
| Current Version | 6.0.0 |
| Latest Version | 6.1.0 |
| Status | **MINOR UPDATE AVAILABLE** |

#### Changes
- v6.1.0 (2025-10-16): Puppetcore update, Ubuntu 24.04 CI support
- v6.0.0 (2023-04-24): **Dropped Puppet 6 support**, added Puppet 8

#### Action Items
```puppet
# Update in Puppetfile
- mod 'puppetlabs-powershell', '6.0.0'
+ mod 'puppetlabs-powershell', '6.1.0'
```

**Recommendation:** Safe update for current users (already on v6.0.0).

---

### 12. **puppetlabs-puppetserver_gem**
| Aspect | Details |
|--------|---------|
| Current Version | 1.1.1 |
| Latest Version | 1.1.1 |
| Status | **UP TO DATE** |

**Recommendation:** No action needed.

---

### 13. **puppetlabs-reboot**
| Aspect | Details |
|--------|---------|
| Current Version | 5.0.0 |
| Latest Version | 5.1.0 |
| Status | **PATCH UPDATE AVAILABLE** |

#### Action Items
```puppet
# Update in Puppetfile
- mod 'puppetlabs-reboot', '5.0.0'
+ mod 'puppetlabs-reboot', '5.1.0'
```

**Recommendation:** Safe patch update.

---

### 14. **puppetlabs-vcsrepo**
| Aspect | Details |
|--------|---------|
| Current Version | 3.2.1 |
| Latest Version | 7.0.0 |
| Status | **MAJOR UPGRADE AVAILABLE** |

#### Breaking Changes
- v7.0.0+ likely significant API changes across 4 major versions

#### Action Items
**Recommendation:** Review all git/svn/hg provider usage in manifests before upgrading.

---

### 15. **saz-timezone**
| Aspect | Details |
|--------|---------|
| Current Version | 6.3.0 |
| Latest Version | 7.0.0 |
| Status | **MAJOR UPGRADE AVAILABLE** |

#### Breaking Changes in v7.0.0
- **Drops support for Puppet 6**
- **Drops support for Ubuntu 18.04**
- Adds support for Puppet 8
- Adds support for Ubuntu 24.04
- Adds support for Debian 12

#### Action Items
```puppet
# Update in Puppetfile
- mod 'saz-timezone', '6.3.0'
+ mod 'saz-timezone', '7.0.0'

# Also requires updating stm-debconf dependency
# saz-timezone 7.0.0 requires stm-debconf 6.x
```

**Recommendation:** Coordinate with stm-debconf upgrade.

---

### 16. **stm-debconf**
| Aspect | Details |
|--------|---------|
| Current Version | 5.0.0 |
| Latest Version | 8.0.0 |
| Status | **MAJOR UPGRADE AVAILABLE** |

#### Breaking Changes in v8.0.0
- **Likely significant API changes** across 3 major versions
- Required by saz-timezone 7.0.0

#### Action Items
```puppet
# Update in Puppetfile
- mod 'stm-debconf', '5.0.0'
+ mod 'stm-debconf', '8.0.0'
```

**Recommendation:** Coordinate with saz-timezone upgrade.

---

### 17. **geoffwilliams-sysctl**
| Aspect | Details |
|--------|---------|
| Current Version | 1.0.1 |
| Latest Version | 1.0.1 |
| Status | **UP TO DATE** |

**Recommendation:** No action needed.

---

## Recommended Upgrade Path

### Phase 1: Foundation (Requires Puppet 8.x)
If upgrading from Puppet 7 to Puppet 8:

```puppet
# Update core foundation first
mod 'puppetlabs-stdlib', '10.0.1'
mod 'puppetlabs-apt', '11.3.2'
```

### Phase 2: Service Modules (Dependent on Phase 1)
```puppet
mod 'puppetlabs-docker', '10.4.1'
mod 'puppetlabs-mysql', '17.1.0'
mod 'puppetlabs-powershell', '6.1.0'
mod 'saz-timezone', '7.0.0'
mod 'stm-debconf', '8.0.0'
mod 'puppetlabs-firewall', '8.5.0'
mod 'puppetlabs-reboot', '5.1.0'
```

### Phase 3: Review & Test (Requires Manifest Updates)
```puppet
# After thorough testing, update these complex modules:
mod 'puppetlabs-mysql', '17.1.0'      # Check charset configs
mod 'puppetlabs-vcsrepo', '7.0.0'     # Review git/svn providers
mod 'puppet-archive', '8.1.0'         # Review archive sources
mod 'puppetlabs-inifile', '6.4.1'     # Review INI configs
```

### Phase 4: TBD (Needs Verification)
```puppet
# These need additional verification/maintenance status checks:
mod 'puppet-hiera', '7.0.0'           # Verify repository location
mod 'puppet-systemd', '9.4.0'         # Review systemd units
```

---

## Ubuntu 26.04 Compatibility Assessment

### Current Status: ⚠️ NOT EXPLICITLY CONFIRMED

Most modules list Ubuntu 24.04 as latest supported version. Ubuntu 26.04 support is:
- **Likely compatible** through Debian/Ubuntu package inheritance
- **Not formally tested** by module maintainers as of 2026-07-17

### Recommended Testing
1. Test in development environment with Ubuntu 26.04
2. Verify key modules:
   - puppetlabs-apt (package management)
   - puppetlabs-mysql (database services)
   - puppetlabs-docker (container runtime)

---

## Inter-Module Dependencies

### Critical Dependency Chain
```
puppetlabs-stdlib (base dependency for most modules)
├── puppetlabs-apt
├── puppetlabs-docker
├── puppetlabs-mysql
├── puppetlabs-firewall
└── Other modules
```

**Upgrade Note:** Always upgrade stdlib first, then modules that depend on it.

### saz-timezone Dependencies
```
saz-timezone v7.0.0
└── requires stm-debconf >= 6.x
```

---

## Code Changes Required

### MySQL Module (v15.0.0 → v17.1.0)

**Issue:** Deprecated charset in mysql::db

```puppet
# BEFORE (v15.0.0)
mysql::db { 'myapp':
  user     => 'appuser',
  password => 'password',
  charset  => 'utf8',  # ❌ DEPRECATED
}

# AFTER (v17.0.0+)
mysql::db { 'myapp':
  user     => 'appuser',
  password => 'password',
  charset  => 'utf8mb3',  # ✅ Use explicit utf8mb3
}
```

**Issue:** Removed expire_logs_days parameter

```puppet
# BEFORE (v15.0.0)
class { 'mysql::server':
  expire_logs_days => 10,  # ❌ REMOVED
}

# AFTER (v16.0.0+)
# Remove this parameter entirely and use MySQL native config
```

### Docker Module (v10.0.0+)

**Issue:** docker-compose command change

```puppet
# BEFORE (v9.x)
docker::run { 'myapp':
  compose_file => '/path/to/docker-compose.yml',
}

# AFTER (v10.0.0+)
# Module now uses 'docker compose' plugin instead of 'docker-compose' command
# No manifest changes needed - this is transparent
```

---

## Compatibility Matrix

| Module | Current | Latest | Min Puppet | Ubuntu 26.04 | Breaking Changes |
|--------|---------|--------|-----------|--------------|------------------|
| puppetlabs-stdlib | 9.3.0 | 10.0.1 | 8.x | Likely | Drops Puppet 7 |
| puppetlabs-apt | 11.2.0 | 11.3.2 | 8.x | Likely | Drops Puppet 7 |
| landcareresearch-amazon_s3 | 6.0.0 | 6.0.0 | ? | ? | None |
| puppet-hiera | 5.0.1 | 7.0.0 | ? | ? | Unknown |
| puppet-systemd | 5.2.0 | 9.4.0 | 8.x | Likely | Yes (major) |
| puppet-archive | 7.1.0 | 8.1.0 | ? | ? | Verify |
| puppetlabs-docker | 10.0.0 | 10.4.1 | 8.x | Likely | Yes (compose) |
| puppetlabs-firewall | 8.2.0 | 8.5.0 | 8.x | Likely | No |
| puppetlabs-inifile | 5.4.1 | 6.4.1 | 8.x | Likely | Yes (major) |
| puppetlabs-mysql | 15.0.0 | 17.1.0 | 8.x | Likely | Yes (charset, params) |
| puppetlabs-powershell | 6.0.0 | 6.1.0 | 8.x | Likely | No |
| puppetlabs-puppetserver_gem | 1.1.1 | 1.1.1 | ? | ? | None |
| puppetlabs-reboot | 5.0.0 | 5.1.0 | 8.x | Likely | No |
| puppetlabs-vcsrepo | 3.2.1 | 7.0.0 | 8.x | Likely | Yes (major) |
| saz-timezone | 6.3.0 | 7.0.0 | 8.x | Yes | Drops Puppet 6 & Ubuntu 18.04 |
| stm-debconf | 5.0.0 | 8.0.0 | 8.x | Likely | Yes (major) |
| geoffwilliams-sysctl | 1.0.1 | 1.0.1 | ? | ? | None |

---

## Migration Checklist

- [ ] Verify current Puppet version (must be 8.x+ for most upgrades)
- [ ] Test Ubuntu 26.04 compatibility in dev environment
- [ ] Backup current Puppetfile
- [ ] Review mysql::db charset configurations
- [ ] Check for expire_logs_days usage in mysql configs
- [ ] Audit vcsrepo provider usage
- [ ] Verify systemd unit definitions
- [ ] Test puppet runs in dev with new module versions
- [ ] Update Puppetfile in stages (base deps first)
- [ ] Run `r10k puppetfile install` to update modules
- [ ] Test on dev nodes first
- [ ] Deploy to staging environment
- [ ] Final production deployment

---

## Additional Resources

- [Puppet Forge](https://forge.puppet.com)
- [Puppet Module Repositories](https://github.com/puppetlabs/)
- [Community Puppet Modules](https://github.com/puppet-community/)
- [Ubuntu 26.04 Release Notes](https://releases.ubuntu.com/noble/)

---

*Last Updated: 2026-07-17*
*Analysis Tool: GitHub Copilot with Puppet Forge API*
