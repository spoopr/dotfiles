ZFS requires `networking.hostId` to be set, as each ZFS pool requires a host id;
the idea is that a mismatch between a pool's recorded host id and the running
machine's host id would signal to ZFS that the given pool is being improperly
imported.

for the most part, this function would only get in my way--i override it, see
`boot.zfs.forceImportAll` and `boot.zfs.forImportRoot`--and host id's are
[sorta deprecated](https://github.com/openzfs/spl/commit/acf0ade362cb8b26d67770114ee6fa17816e6b65)(?)
anyways.

anyways:
```bash
head --bytes 4 /dev/urandom | od --address-radix=none --format=x4
```

# done
