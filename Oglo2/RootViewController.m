//
//  RootViewController.m
//  Oglo
//
//  Created by Charles-Hubert Basuiau on 04/05/2016.
//  Copyright © 2016 Appiway. All rights reserved.
//

#import "RootViewController.h"

#import "HomeViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "Constants.h"

@interface RootViewController () <CBCentralManagerDelegate, CBPeripheralDelegate> {
    CBCentralManager *cbManager;
    CBPeripheral *chosenPeripheral;
    HomeViewController *homeVC;
}

@end

@implementation RootViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    cbManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    [self performSelector:@selector(connectToOglo) withObject:nil afterDelay:0.5];
}

-(void)connectToOglo {
    if (chosenPeripheral) {
        [cbManager connectPeripheral:chosenPeripheral options:nil];
    } else {
        [self performSelector:@selector(connectToOglo) withObject:nil afterDelay:0.5];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
//    [cbManager stopScan];
    [super viewWillDisappear:animated];
}



#pragma mark - ConnectionManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if(central.state != CBCentralManagerStatePoweredOn){
        return;
    }
    if(central.state == CBCentralManagerStatePoweredOn){
        NSLog(@"Scanning for BTLE device");
        [central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
    }
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    NSLog(@"%s",__FUNCTION__);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
//    NSLog(@"Peripheral : %@",peripheral);
//    if ([self isMyOglo:peripheral]) {
//        chosenPeripheral = peripheral;
//    }
    if ([self isMyFlip:peripheral]) {
        chosenPeripheral = peripheral;
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%s",__FUNCTION__);
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"%s",__FUNCTION__);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - Peripheral Delegate

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral NS_AVAILABLE(NA, 6_0) {
    NSLog(@"%s",__FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices NS_AVAILABLE(NA, 7_0) {
    NSLog(@"%s",__FUNCTION__);
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error NS_DEPRECATED(NA, NA, 5_0, 8_0) {
    NSLog(@"%s",__FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error NS_AVAILABLE(NA, 8_0) {
    NSLog(@"%s",__FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    NSLog(@"Discover Service");
    
    for (CBService *service in peripheral.services)
    {
        NSLog(@"Discovering characteristics for service %@", service);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {
    NSLog(@"%s",__FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    NSLog(@"Discover Characteristics");
//    Characteristic : <CBCharacteristic: 0x13e520e00, UUID = 65786365-6C70-6F69-6E74-2E636F6D0001, properties = 0x12, value = (null), notifying = NO>
//    Characteristic : <CBCharacteristic: 0x13e546270, UUID = 65786365-6C70-6F69-6E74-2E636F6D0002, properties = 0x8, value = (null), notifying = NO>
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"Characteristic : %@",characteristic);
//        [peripheral discoverDescriptorsForCharacteristic:characteristic];
        
        UInt16 i0 = 0x01FF; // Or = 6992
        UInt16 i1 = 0x0000; // Or = 6992
        UInt16 i2 = 0x000A; // Or = 6992
        UInt16 i3 = 0x0207; // Or = 6992
        UInt16 i4 = 0x01; // Or = 6992
        NSMutableData *packet = [[NSMutableData alloc] init];
//        [packet appendData:[[NSData alloc] initWithBytes: &i0 length: sizeof(i0)]];
//        [packet appendData:[[NSData alloc] initWithBytes: &i1 length: sizeof(i1)]];
//        [packet appendData:[[NSData alloc] initWithBytes: &i2 length: sizeof(i2)]];
        [packet appendData:[[NSData alloc] initWithBytes: &i3 length: sizeof(i3)]];
        [packet appendData:[[NSData alloc] initWithBytes: &i4 length: sizeof(i4)/2]];
        
        if (characteristic.properties == CBCharacteristicPropertyWrite) {

            static unsigned char networkPacket[1024];
            const NSUInteger packetHeaderSize = sizeof(int);

            NSInteger *pintData0 = (NSInteger *)&networkPacket[0];
            pintData0[0] = 10;
            NSInteger *pintData1 = (NSInteger *)&networkPacket[packetHeaderSize];
            pintData1[0] = 519;
//            NSInteger *pintData2 = (NSInteger *)&networkPacket[packetHeaderSize*2];
//            pintData2[0] = 10;
//            NSInteger *pintData3 = (NSInteger *)&networkPacket[packetHeaderSize*3];
//            pintData3[0] = 519;
            NSInteger *pintData4 = (NSInteger *)&networkPacket[packetHeaderSize*2];
            pintData4[0] = 0;
//                                    NSInteger *pintData5 = (NSInteger *)&networkPacket[packetHeaderSize*5];
//                                    pintData5[0] = class;
            
            
//            NSData *packet = [NSData dataWithBytes:networkPacket length:(packetHeaderSize*2.5)];
//            [peripheral writeValue:packet forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        } else {
//            NSLog(@"Discovered characteristic %@", characteristic);
//            NSLog(@"Reading value for characteristic %@", characteristic);
//            [peripheral readValueForCharacteristic:characteristic];
//            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    
//    CBCharacteristic *characteristic = [service.characteristics firstObject];
//    [peripheral readValueForCharacteristic:characteristic];
//    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSData *data = characteristic.value;
    
    NSLog(@"Data = %@ %@", data, error);
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"%s %@ %@",__FUNCTION__, characteristic, error);
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"%s %@ %@",__FUNCTION__, characteristic, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"%s",__FUNCTION__);
    
    NSLog(@"Descriptors : %@",characteristic.descriptors);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    NSLog(@"%s",__FUNCTION__);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark private methods

-(BOOL)isMyOglo:(CBPeripheral *)peripheral {
    if ([peripheral.identifier.UUIDString isEqualToString:kOGLO_UUID]) {
        return YES;
    }
    return NO;
}

-(BOOL)isMyFlip:(CBPeripheral *)peripheral {
    if ([peripheral.identifier.UUIDString isEqualToString:kFLIP_UUID]) {
        return YES;
    }
    return NO;
}

@end
