```json

{
  "paths" : {
    "/tmp" : {},                // implicit name+path, just count everything + report
    "/tmp swapfiles" : {        // names must be unique
      "path" : "/tmp",          // explicit path
      "match" : "^\\..*\.swp$", // regular expression match
      "atime" : {"min": 1354051358},
      // max, (and relative: -min/-max)
      // also for: mtime, ctime, size (only absolute min/max)
      // uid/gid : [35, 47], or by excluding: ["not", 0, 42]
      // permissions: "0[67][45]0" // right-anchored regexp
    },
    "/opt" : {"no_list" : true},    // will skip stat() on contents
    "/bin" : {"no_list" : true,     // will only return the count,
      "mtime" : {"-min" : 600}},    // but stat is needed for the check
    "/vmlinuz" : {
      "path"   : "/",
      "only"   : ["vmlinuz"],       // explicit list / skip readdir()
      "filter" : ["symlink"],       // must be a symlink
      "mtime"  : {"-min" : 3600},   // relative to Time.now
    },
    "/bin symlinks" : {"path" : "/bin/", "filter" : ["symlink"]},
    "/usr/bin swapfiles" : {"path" : "/usr/bin/", "glob" : ".*.swp"}
  }
}

```
