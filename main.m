/*
 * UDIDGenerator.
 * Tool to generate the UDID just like Apple does.
 * Copyright (C) Cykey 2013.
 */

#import <CommonCrypto/CommonDigest.h>
#import <CoreFoundation/CoreFoundation.h>
#import "MobileGestalt/MobileGestalt.h"

int main(int argc, char **argv, char **envp)
{
    CFStringRef deviceSerial     = MGCopyAnswer(kMGSerialNumber);
    CFStringRef wiFiAddress      = MGCopyAnswer(kMGWifiAddress);
    CFStringRef bluetoothAddress = MGCopyAnswer(kMGBluetoothAddress);
    CFStringRef IMEI             = MGCopyAnswer(kMGInternationalMobileEquipmentIdentity);

    CFStringRef format = CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR("%@%@%@%@"), deviceSerial, IMEI, wiFiAddress, bluetoothAddress);

    CFIndex length = CFStringGetLength(format);
    CFIndex maxSize = CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingUTF8);
    char *buffer = (char *)malloc(maxSize);

    Boolean ret = CFStringGetCString(format, buffer, maxSize, kCFStringEncodingUTF8);
    if (ret == false) {
        printf("FATAL: CFStringGetCString failed. Exiting. \n");
        exit(EXIT_FAILURE);
    }

    unsigned char hash[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(buffer, strlen(buffer), hash);

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        printf("%02x", hash[i]);
    }

    printf("\n");

    CFRelease(deviceSerial);
    CFRelease(wiFiAddress);
    CFRelease(bluetoothAddress);
    CFRelease(IMEI);

    free(buffer);

    return 0;
}
