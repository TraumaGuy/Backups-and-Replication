# Borg Backup Script
Bash Script for Borg Backup, Prune and Check

##   BEWARE!
**Before use, and in order to make your life easier, learn how to manually use at least these three Borg Commands:**
- `borg create`     https://borgbackup.readthedocs.io/en/stable/usage/create.html
- `borg prune`      https://borgbackup.readthedocs.io/en/stable/usage/prune.html
- `borg check`      https://borgbackup.readthedocs.io/en/stable/usage/check.html

## How to Use
Open your terminal, then run
```
bash /path/borg.sh /path/borg.json
```

### Parameters
1 .json file

### Packages requirement
- `jq`    Package for json data parsing

##  How to fill the config file (.json)
Example
```
{
    "GeneralConfig":{
        "Debug": true,
        "Wait": 2
        },
    "Telegram":{
        "Enable": true,
        "ChatID": "-123",
        "APIkey": "123:ABC"
        },
    "Task": [
        {
            "Repository": "/data/borg-testing/test_repo",
            "BorgPassphrase": "testingtesting", 
            "Prefix": "MyBackup",     
            "BorgCreate":{
                "Enable": true,
                "ArchivePath": "/home/user/",
                "Options": "--stats --info --list --filter=E --compression auto,lzma,9"
                },
            "BorgPrune":{
                "Enable": true,
                "Options": "-v --stats --info --list --keep-daily=7 --keep-weekly=2 --keep-monthly=6"
                },
            "BorgCheck":{
                "Enable": true,
                "Options": "-v --verify-data --show-rc"
                }
        },
        {
            "Repository": "/data/borg-testing/test_repo_2",
            "BorgPassphrase": "testingtesting", 
            "Prefix": "MyOtherBackup",     
            "BorgCreate":{
                "Enable": true,
                "ArchivePath": "/data/Photo/",
                "Options": "--stats --info --list --filter=E --compression auto,lzma,9"
                },
            "BorgPrune":{
                "Enable": true,
                "Options": "-v --stats --info --list --keep-daily=7 --keep-weekly=2 --keep-monthly=6"
                },
            "BorgCheck":{
                "Enable": true,
                "Options": "-v --verify-data --show-rc"
                }
        }    
    ]
}
```
### .json Instructions
| Parameter | Value | Description |
|---------------------- | -----------| ---------------------------------|
| GeneralConfig.Debug | true / false | Enable more verbosity in the program log |
| GeneralConfig.Wait | number | Seconds to wait between task |
| Telegram.Enable | true / false | Enable Telegram Notifications |
| Telegram.ChatID | number | Enable Telegram Notifications (you can get this when you add the bot @getmyid_bot to your chat/group) |
| Telegram.APIkey | alphanumeric | Telegram Bot API Key |
| Task.Repository | Path | Full path to Repository |
| Task.BorgPassphrase | alphanumeric | Repository's password |
| Task.Prefix | alphanumeric | Backup Name |
| Task.BorgCreate.Enable | true / false | Enable Backup Creation for this task |
| Task.BorgCreate.ArchivePath | Path | Full path to the folder that is going to be backed up |
| Task.BorgCreate.Options | Text | `borg create` options https://borgbackup.readthedocs.io/en/stable/usage/create.html |
| Task.BorgPrune.Enable | true / false | Enable Backup Prune (automatic deletion) for this task |
| Task.BorgPrune.Options | Text | `borg prune` Options https://borgbackup.readthedocs.io/en/stable/usage/prune.html |
| Task.BorgCheck.Enable | true / false | Enable Backup Check for this task |
| Task.BorgCheck.Options | Text | `borg check` Options https://borgbackup.readthedocs.io/en/stable/usage/check.html

##  Version Story
- 2020-04-24  First version
- 2020-04-25  Uploaded a GitHub version
- 2021-08-06  v0.3    Disable PRUNE Option
- 2021-08-07  v0.4    Enable "--prefix PREFIX" for Pruning
- 2021-08-20  v1.0.2    Feature: All-in-One code refactor