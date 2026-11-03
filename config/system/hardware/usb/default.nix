{
  ...
}: {
    boot.kernelModules = [
        # usb support
        "usbhid"
        # usb ethernet modules
        "usbnet"
        "cdc_ether"
        "cdc_mbim"
        "cdc_wdm"
        "cdc_ncm"
    ];
}
