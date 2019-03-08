# Search-Function-In-Files

# Overview
This script lists the functions described in the file, you can search by selecting one from the list.  
**Note**: The assumption of use is PHP.

# Description
This script lists the functions described in the file, you can search by selecting one from the list.  
You can only search for methods that have **the visibility of public** defined.  
The search range is lower than the current directory.  
By passing a number as the second argument, you can specify the number of output characters of the search result.  
For example, if you pass 300, only 300 letters will be displayed.  
This is useful when search results are too long.  
The upper limit of the number that can be passed to the second argument is **999**.

## Requirement
**Shell type:** bash  
**Version:** GNU bash, version 3.2.57

# DEMO
For example, let's say you want to examine a function in an file--**HogeController**.  
In the HogeController, it is described as follows.

```php
class HogeController extends AppController
{
	public function huga() {
		~~~
	}

	public function hogehoge() {
		~~~
	}

	protected function _hogehugahoge() {
		~~~
	}

	public function hugahuga() {
		~~~
	}
}
```

If you use this script for this file, it looks like the following.

```bash
$ pwd
/your/project/
$ ~/sfif.sh app/Controller/HogeController.php
1) huga
2) hogehoge
3) hugahuga
Please select number:
```

In this way, you can only retrieve methods that have the visibility of public defined.  
（In this time, *_hogehugahoge* is excluded.）  
When you enter the number of the function you want to search, the search begins.  
The search range is lower than the current directory.  
Files above the current directory are not searchable.

```bash
Please select number:1
app/Controller/PiyoPiyoTest.php:38: $piyo = $this->huga();
```

If you pass the second argument, it will not display more than that number of characters.  
（*It can pass up to 999.*）

```bash
$ ~/sfif.sh app/Controller/HogeController.php 20
1) huga
2) hogehoge
3) hugahuga
Please select number:1
app/Controller/Piyo  #Display only 20 characters.
```

# Usage
```bash
$ cd /your/develop/directory
$ git clone git@github.com:hiroaki510/Search-Function-In-Files.git
$ cp Search-Function-In-Files/sfif.sh ~/  #or  $mv sfif.sh ~/
```

**Only this!**
**Please use it by all means!**

# LICENCE
Please use this script freely.  
License free.
