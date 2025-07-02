{
  ...
}: {
    boot = {
        kernelParams = [
            "zswap.enabled=1"
            "zswap.compressor=lz4" # apparently the fastest algorithm
            "zswap.max_pool_percent=20" # might wanna tune this value later
        ];
    };
}
