/*
 * UDIDGenerator.
 * Tool to generate the UDID just like Apple does.
 * Copyright (C) Cykey <david.murray16@hotmail.com> 2013.
 */

#import <CommonCrypto/CommonDigest.h>
#import <CoreFoundation/CoreFoundation.h>
#import "MobileGestalt/MobileGestalt.h"

static void exit_with_error(const char *error)
{
    puts(error);
    exit(EXIT_FAILURE);
}

int main(int argc, char **argv, char **envp)
{
    CFStringRef deviceSerial     = MGCopyAnswer(kMGSerialNumber);
    CFStringRef wiFiAddress      = MGCopyAnswer(kMGWifiAddress);
    CFStringRef bluetoothAddress = MGCopyAnswer(kMGBluetoothAddress);
    CFStringRef IMEI             = MGCopyAnswer(kMGInternationalMobileEquipmentIdentity);

    if (!deviceSerial)
        exit_with_error("FATAL: Could not get serial number. Exiting.\n");
    if (!wiFiAddress)
        exit_with_error("FATAL: Could not get WiFi address. Exiting.\n");
    if (!bluetoothAddress)
        exit_with_error("FATAL: Could not get Bluetooth address. Exiting.\n");
    if (!IMEI)
        exit_with_error("FATAL: Could not get IMEI. Exiting.\n");

    CFStringRef format = CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR("%@%@%@%@"), deviceSerial, IMEI, wiFiAddress, bluetoothAddress);

    if (!format)
        exit_with_error("FATAL: CFStringCreateWithFormat failed. Exiting.\n");

    CFIndex length = CFStringGetLength(format);
    CFIndex maxSize = CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingUTF8);
    char *buffer = (char *)malloc(maxSize);

    Boolean ret = CFStringGetCString(format, buffer, maxSize, kCFStringEncodingUTF8);
    if (ret == false)
        exit_with_error("FATAL: CFStringGetCString failed. Exiting.\n");

    unsigned char hash[CC_SHA1_DIGEST_LENGTH];

    // SHA1 the string.
    CC_SHA1(buffer, strlen(buffer), hash);

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        printf("%02x", hash[i]);

    printf("\n");

    CFRelease(deviceSerial);
    CFRelease(wiFiAddress);
    CFRelease(bluetoothAddress);
    CFRelease(IMEI);

    free(buffer);

    return 0;
}
