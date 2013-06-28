/*
 * UDIDGenerator.
 * Tool to generate the UDID just like Apple does.
 *
 * Copyright (c) 2013, Cykey (David Murray)
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Cykey nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <CommonCrypto/CommonDigest.h>
#import <CoreFoundation/CoreFoundation.h>
#import "MobileGestalt/MobileGestalt.h"
#include <assert.h>

int main(int argc, char **argv, char **envp)
{
    CFStringRef deviceSerial     = MGCopyAnswer(kMGSerialNumber);
    CFStringRef wiFiAddress      = MGCopyAnswer(kMGWifiAddress);
    CFStringRef bluetoothAddress = MGCopyAnswer(kMGBluetoothAddress);
    CFStringRef IMEI             = MGCopyAnswer(kMGInternationalMobileEquipmentIdentity);

    // Exit if we could not get one of the 4 required values.
    assert(deviceSerial != NULL);
    assert(wiFiAddress != NULL);
    assert(bluetoothAddress != NULL);
    assert(IMEI != NULL);

    CFStringRef format = CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR("%@%@%@%@"), deviceSerial, IMEI, wiFiAddress, bluetoothAddress);

    assert(format != NULL);

    CFIndex length = CFStringGetLength(format);
    CFIndex maxSize = CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingUTF8);
    char *buffer = (char *)malloc(maxSize);

    Boolean ret = CFStringGetCString(format, buffer, maxSize, kCFStringEncodingUTF8);
    assert(ret != false);

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
    CFRelease(format);

    free(buffer);

    return 0;
}
