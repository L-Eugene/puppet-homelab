# S3 Puppet Module Changelog

## 2021-02-23 Release 6.0.0

- Updated PDK and changed version to coincide with puppet compatibility.

## 2020-01-14 Release 0.3.1

- Added parameters for using mount specific credentials instead of global credentials.
- Fixed metadata to comply with PDK standards.
- Removed anchor pattern.
- Fixed ruby spec code to comply with linting.

## 2019-10-30 Release 0.3.0

- Updated Changelog to comply with Markdown Linting.
- Updated Readme to comply with Markdown Linting.
- Added Ubuntu 18.04 support.
- Migrated from r10k to g10k in the vagrant testing environment.
- Removed Ubuntu 12.04 support (as puppet 5 is not available).
- Removed Centos6 support as requires [fuse to be compiled](https://github.com/s3fs-fuse/s3fs-fuse/wiki/Installation-Notes).
- Set default s3fs version to 1.85 (only effects compilation and not system packages).

## 2019-08-15 Release 0.2.7

- Added multireq_max to default options

## 2019-05-15 Release 0.2.6

- Unified changelog documentation.
- Tested on Ubuntu 18.04 and added as supported.

## 2019-05-15 Release 0.2.5

- Added _netdev as an option to ensure on boot mounts work through fstab.

## 2019-04-23 Release 0.2.4

- Fixed source url.

## 2019-04-23 Release 0.2.3

- Added a flag to use distribution's repositories instead of compiling.

## 2018-07-20 Release 0.2.2

- Changed comments to use puppet strings.
- Added reference document generated from puppet strings comments.

## 2018-04-09 Release 0.2.1

- Added initial support for Centos operating systems.
- Added usage of IAM roles instead of Access/Secret.
- Updated readme with additional information regarding iam roles.

## 2017-04-28 Release 0.2.0

- Merged PR to remove mode on mount point.
- Removed a redundant package.
- Added Puppet 4 typed parameters.
- Updated Readme.

## 2016-08-15 Release 0.1.7

- Added support for compiling on Ubuntu 16.04.
- Removed author from comments since there is a contributors.txt file.
- Updated the default version of s3fs to 1.80.

## 2016-07-04 Release 0.1.6

- Added a check for a parameter.
- Updated documentation on new parameter.
- Added a vagrant folder for testing.

## 2015-12-10 Release 0.1.5

- Added a params class for better encapsulation.
- Added a contributors file.

## 2015-04-17 Release 0.1.4

- Added a parameter to toggle if the mime-support package should be installed.

## 2015-03-04 Release 0.1.3

- Migrated source code control to bitbucket.
- Changed ownership to landcare research puppetforge account.
- Added copywrite notice to all source files.

## 2015-02-19 Release 0.1.2

- Added license file.

## 2015-02-11 Release 0.1.1

- Merged changes from Kentzo to specify mounting options.
- Fixed an error where puppet would try a force remount on an already mounted bucket.
- Updated readme with new changes to s3_mount.

## 2015-01-16 Release 0.1.0

Initial release.
