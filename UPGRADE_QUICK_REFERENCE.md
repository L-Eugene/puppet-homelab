# Quick Reference - Module Upgrade Status

## Latest Versions (as of 2026-07-17)

| Module | Current | Latest | Priority | Action |
|--------|---------|--------|----------|--------|
| puppetlabs-stdlib | 9.3.0 | **10.0.1** ⚠️ | **HIGH** | Requires Puppet 8.x; update first |
| puppetlabs-apt | 11.2.0 | 11.3.2 | MEDIUM | Safe minor update |
| landcareresearch-amazon_s3 | 6.0.0 | 6.0.0 ✓ | - | Up to date |
| puppet-hiera | 5.0.1 | **7.0.0** ⚠️ | MEDIUM | Verify repo location first |
| puppet-systemd | 5.2.0 | **9.4.0** ⚠️ | MEDIUM | Review systemd configs |
| puppet-archive | 7.1.0 | 8.1.0 | LOW | Verify maintenance status |
| puppetlabs-docker | 10.0.0 | 10.4.1 | MEDIUM | Good update (no manifest changes) |
| puppetlabs-firewall | 8.2.0 | 8.5.0 | LOW | Safe minor update |
| puppetlabs-inifile | 5.4.1 | **6.4.1** ⚠️ | MEDIUM | Review INI file configs |
| puppetlabs-mysql | 15.0.0 | **17.1.0** ⚠️ | **HIGH** | **CRITICAL:** charset & config changes |
| puppetlabs-powershell | 6.0.0 | 6.1.0 | LOW | Safe minor update |
| puppetlabs-puppetserver_gem | 1.1.1 | 1.1.1 ✓ | - | Up to date |
| puppetlabs-reboot | 5.0.0 | 5.1.0 | LOW | Safe patch update |
| puppetlabs-vcsrepo | 3.2.1 | **7.0.0** ⚠️ | MEDIUM | Major changes - review git usage |
| saz-timezone | 6.3.0 | **7.0.0** ⚠️ | MEDIUM | Coordinate with stm-debconf v8 |
| stm-debconf | 5.0.0 | **8.0.0** ⚠️ | MEDIUM | Required for saz-timezone 7.0.0 |
| geoffwilliams-sysctl | 1.0.1 | 1.0.1 ✓ | - | Up to date |

**Legend:**
- ✓ = Up to date
- ⚠️ = Breaking changes or major version upgrade
- **HIGH** = Must update or requires significant review
- **MEDIUM** = Should update, some review needed
- **LOW** = Optional update

---

## Immediate Action Items

### 🔴 CRITICAL (Review First)
1. **puppetlabs-mysql v15.0.0 → v17.1.0**
   - Search manifests for `expire_logs_days` (will break)
   - Search manifests for `charset => 'utf8'` (needs updating to `utf8mb3`)
   - Check: `site/profile/manifests/mysql_server.pp`

2. **puppetlabs-stdlib v9.3.0 → v10.0.1**
   - Requires Puppet 8.x
   - Base dependency for all other modules
   - Update this FIRST before other modules

### 🟡 IMPORTANT (Coordinate Updates)
3. **saz-timezone v6.3.0 → v7.0.0 + stm-debconf v5.0.0 → v8.0.0**
   - These have inter-dependencies
   - Update together to avoid conflicts

### 🟢 OPTIONAL (Low Risk)
- puppetlabs-apt: 11.2.0 → 11.3.2
- puppetlabs-docker: 10.0.0 → 10.4.1
- puppetlabs-firewall: 8.2.0 → 8.5.0
- puppetlabs-reboot: 5.0.0 → 5.1.0

---

## Ubuntu 26.04 Compatibility Status

⚠️ **NOT FORMALLY CONFIRMED** - Most modules list Ubuntu 24.04 as latest tested version

**Recommendation:** Test these modules in Ubuntu 26.04 dev environment:
- puppetlabs-apt (critical for package management)
- puppetlabs-mysql (database compatibility)
- puppetlabs-docker (container runtime)

---

## Puppet Version Requirement

**Minimum Required: Puppet 8.x**

Modules requiring Puppet 8+:
- puppetlabs-stdlib 10.0.1+
- puppetlabs-apt 11.0.0+
- puppetlabs-mysql 17.0.0+
- Most v10+ modules

⚠️ If still on Puppet 7, these upgrades will break existing installations.

---

## Files Generated

- ✅ `/workspaces/puppet-homelab/FORGE_MODULES_UPGRADE_ANALYSIS.md` - Full detailed analysis
- ✅ `/workspaces/puppet-homelab/UPGRADE_QUICK_REFERENCE.md` - This file

---

## Next Steps

1. ✅ Review MySQL configurations for deprecated parameters
2. ✅ Confirm Puppet version compatibility (need 8.x+)
3. ✅ Test in dev environment with Ubuntu 26.04
4. ✅ Create feature branch for upgrades
5. ✅ Update Puppetfile incrementally (base deps first)
6. ✅ Run `r10k puppetfile install` to sync changes
7. ✅ Test puppet runs on dev nodes
8. ✅ Stage to testing environment
9. ✅ Deploy to production after validation

---

Generated: 2026-07-17
